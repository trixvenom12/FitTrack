import 'package:flutter/material.dart';

class FitnessData with ChangeNotifier {
  int steps = 8432;
  int caloriesBurned = 420;
  int activeMinutes = 45;
  int heartRate = 72;

  List<Map<String, dynamic>> weeklyData = [
    {'day': 'Mon', 'steps': 7560},
    {'day': 'Tue', 'steps': 8920},
    {'day': 'Wed', 'steps': 10240},
    {'day': 'Thu', 'steps': 6890},
    {'day': 'Fri', 'steps': 9340},
    {'day': 'Sat', 'steps': 11230},
    {'day': 'Sun', 'steps': 8432},
  ];

  void updateHealthData({
    int? steps,
    int? caloriesBurned,
    int? activeMinutes,
    int? heartRate,
  }) {
    this.steps = steps ?? this.steps;
    this.caloriesBurned = caloriesBurned ?? this.caloriesBurned;
    this.activeMinutes = activeMinutes ?? this.activeMinutes;
    this.heartRate = heartRate ?? this.heartRate;
    notifyListeners();
  }
}
