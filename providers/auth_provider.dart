import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _username;
  String? _email;

  bool get isAuthenticated => _token != null;
  String? get token => _token;
  String? get userId => _userId;
  String? get username => _username;
  String? get email => _email;

  // Update the base URL with your local IP
  static const String _baseUrl = 'http://192.168.1.8:8000';

  // ---------------------- LOGIN ----------------------
  Future<void> login(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    final responseData = json.decode(response.body);
    print('Login response data: $responseData');

    if (response.statusCode != 200) {
      throw Exception(responseData['message'] ?? 'Login failed');
    }

    final token = responseData['access_token']?.toString();
    final userData = responseData['user'];

    final userId = userData['id']?.toString();
    final username = userData['username']?.toString();
    final emailResp = userData['email']?.toString();

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token missing in response');
    }
    if (userId == null || userId.isEmpty) {
      throw Exception('User ID missing in response');
    }
    if (username == null || username.isEmpty) {
      throw Exception('Username missing in response');
    }
    if (emailResp == null || emailResp.isEmpty) {
      throw Exception('Email missing in response');
    }

    _token = token;
    _userId = userId;
    _username = username;
    _email = emailResp;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    await prefs.setString('userId', _userId!);
    await prefs.setString('username', _username!);
    await prefs.setString('email', _email!);

    notifyListeners();
  } catch (error) {
    print('Login error: $error');
    rethrow;
  }
}

  // ---------------------- REGISTER ----------------------
  Future<void> register(
    String username,
    String email,
    String password,
    int age,
    double weight,
    double height,
    String fitnessGoal,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
          'age': age,
          'weight': weight,
          'height': height,
          'fitness_goal': fitnessGoal,
          'profile_picture': null, // if backend accepts null
        }),
      );

      final responseData = json.decode(response.body);
      print('Register response: $responseData');

      if (response.statusCode != 201) {
        throw Exception(responseData['detail'] ?? 'Registration failed');
      }

      // Automatically login after successful registration
      await login(email, password);
    } catch (error) {
      print('Register error: $error');
      rethrow;
    }
  }

  // ---------------------- AUTO LOGIN ----------------------
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) return false;

    _token = prefs.getString('token');
    _userId = prefs.getString('userId');
    _username = prefs.getString('username');
    _email = prefs.getString('email');

    notifyListeners();
    return true;
  }

  // ---------------------- LOGOUT ----------------------
  Future<void> logout() async {
    _token = null;
    _userId = null;
    _username = null;
    _email = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  // ---------------------- GET USER DATA ----------------------
  Future<Map<String, dynamic>> getUserData() async {
    if (_userId == null) throw Exception('User not authenticated');

    final response = await http.get(Uri.parse('$_baseUrl/users/$_userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
