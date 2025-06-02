import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel with ChangeNotifier {
  final SharedPreferences prefs;

  UserModel(this.prefs) {
    _loadFromPrefs();
  }

  String _name = 'John Doe';
  String _email = 'john@example.com';
  int _age = 30;
  double _height = 180;
  double _currentWeight = 75.5;
  double _targetWeight = 70;
  String _fitnessGoal = 'Lose Weight';
  String _activityLevel = 'Moderately Active';
  int _dailySteps = 10000;
  int _workoutDays = 4;
  DateTime _joinDate = DateTime.now();

  String get name => _name;
  String get email => _email;
  int get age => _age;
  double get height => _height;
  double get currentWeight => _currentWeight;
  double get targetWeight => _targetWeight;
  String get fitnessGoal => _fitnessGoal;
  String get activityLevel => _activityLevel;
  int get dailySteps => _dailySteps;
  int get workoutDays => _workoutDays;
  DateTime get joinDate => _joinDate;

  Future<void> _loadFromPrefs() async {
    _name = prefs.getString('name') ?? _name;
    _email = prefs.getString('email') ?? _email;
    _age = prefs.getInt('age') ?? _age;
    _height = prefs.getDouble('height') ?? _height;
    _currentWeight = prefs.getDouble('currentWeight') ?? _currentWeight;
    _targetWeight = prefs.getDouble('targetWeight') ?? _targetWeight;
    _fitnessGoal = prefs.getString('fitnessGoal') ?? _fitnessGoal;
    _activityLevel = prefs.getString('activityLevel') ?? _activityLevel;
    _dailySteps = prefs.getInt('dailySteps') ?? _dailySteps;
    _workoutDays = prefs.getInt('workoutDays') ?? _workoutDays;
    final joinDateString = prefs.getString('joinDate');
    _joinDate = joinDateString != null ? DateTime.parse(joinDateString) : _joinDate;
    notifyListeners();
  }

  Future<void> updateUser({
    String? name,
    String? email,
    int? age,
    double? height,
    double? currentWeight,
    double? targetWeight,
    String? fitnessGoal,
    String? activityLevel,
    int? dailySteps,
    int? workoutDays,
    DateTime? joinDate,
  }) async {
    if (name != null) _name = name;
    if (email != null) _email = email;
    if (age != null) _age = age;
    if (height != null) _height = height;
    if (currentWeight != null) _currentWeight = currentWeight;
    if (targetWeight != null) _targetWeight = targetWeight;
    if (fitnessGoal != null) _fitnessGoal = fitnessGoal;
    if (activityLevel != null) _activityLevel = activityLevel;
    if (dailySteps != null) _dailySteps = dailySteps;
    if (workoutDays != null) _workoutDays = workoutDays;
    if (joinDate != null) _joinDate = joinDate;

    await prefs.setString('name', _name);
    await prefs.setString('email', _email);
    await prefs.setInt('age', _age);
    await prefs.setDouble('height', _height);
    await prefs.setDouble('currentWeight', _currentWeight);
    await prefs.setDouble('targetWeight', _targetWeight);
    await prefs.setString('fitnessGoal', _fitnessGoal);
    await prefs.setString('activityLevel', _activityLevel);
    await prefs.setInt('dailySteps', _dailySteps);
    await prefs.setInt('workoutDays', _workoutDays);
    await prefs.setString('joinDate', _joinDate.toIso8601String());

    notifyListeners();
  }
}
