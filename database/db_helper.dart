import 'dart:convert';
import 'package:http/http.dart' as http;

class DbHelper {
  static const String baseUrl = 'http://localhost:3000'; // change if hosted or using emulator

  // Add a meal
  Future<bool> addMeal(String name, double calories, double protein, double carbs, double fat) async {
    final url = Uri.parse('$baseUrl/addMeal');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      }),
    );

    return response.statusCode == 200;
  }

  // Fetch all meals
  Future<List<Map<String, dynamic>>> getMeals() async {
    final url = Uri.parse('$baseUrl/getMeals');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load meals');
    }
  }

  // Delete a meal
  Future<bool> deleteMeal(int id) async {
    final url = Uri.parse('$baseUrl/deleteMeal/$id');
    final response = await http.delete(url);

    return response.statusCode == 200;
  }
}
