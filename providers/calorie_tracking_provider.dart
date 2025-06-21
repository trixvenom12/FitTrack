import 'dart:typed_data';
import 'package:flutter/material.dart';

class CalorieTrackingProvider extends ChangeNotifier {
  String? detectedFood;
  double? estimatedCalories;

  /// Dummy food classifier (can be replaced with backend API call)
  Future<void> classifyImage(Uint8List imageBytes) async {
    // TODO: Replace this with your actual classification logic (e.g. call FastAPI backend)
    
    // Dummy logic (pretending we found "apple" for now)
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network/image processing delay
    detectedFood = "apple";
    estimatedCalories = _getCaloriesForFood(detectedFood!);
    notifyListeners();
  }

  double _getCaloriesForFood(String foodName) {
    Map<String, double> calorieMap = {
      'apple': 52.0,
      'banana': 89.0,
      'burger': 295.0,
      'pizza': 266.0,
      'salad': 33.0,
    };
    return calorieMap[foodName.toLowerCase()] ?? 0.0;
  }
}
