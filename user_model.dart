import 'package:flutter/foundation.dart';

class UserModel with ChangeNotifier {
  String name;
  String email;
  DateTime joinDate;
  int age;
  double height;
  double currentWeight;
  double targetWeight;
  String fitnessGoal;
  String activityLevel;
  int dailySteps;

  UserModel({
    required this.name,
    required this.email,
    required this.joinDate,
    required this.age,
    required this.height,
    required this.currentWeight,
    required this.targetWeight,
    required this.fitnessGoal,
    required this.activityLevel,
    required this.dailySteps,
  });

  void updateUser({
    String? name,
    String? email,
    DateTime? joinDate,
    int? age,
    double? height,
    double? currentWeight,
    double? targetWeight,
    String? fitnessGoal,
    String? activityLevel,
    int? dailySteps,
  }) {
    if (name != null) this.name = name;
    if (email != null) this.email = email;
    if (joinDate != null) this.joinDate = joinDate;
    if (age != null) this.age = age;
    if (height != null) this.height = height;
    if (currentWeight != null) this.currentWeight = currentWeight;
    if (targetWeight != null) this.targetWeight = targetWeight;
    if (fitnessGoal != null) this.fitnessGoal = fitnessGoal;
    if (activityLevel != null) this.activityLevel = activityLevel;
    if (dailySteps != null) this.dailySteps = dailySteps;
    notifyListeners();
  }

  // Mock data
  factory UserModel.mock() {
    return UserModel(
      name: 'Aditya R.',
      email: 'aditya@example.com',
      joinDate: DateTime(2024, 1, 15),
      age: 22,
      height: 175.0,
      currentWeight: 75.0,
      targetWeight: 70.0,
      fitnessGoal: 'Lose Weight',
      activityLevel: 'Moderate',
      dailySteps: 8000,
    );
  }
}
