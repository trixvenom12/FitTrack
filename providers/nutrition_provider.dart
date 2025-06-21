import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../model/meal_model.dart';

class NutritionProvider with ChangeNotifier {
  List<Meal> _meals = [];
  double _dailyCalorieGoal = 2000;
  double _todayCalories = 0;
  double _todayProtein = 0;
  double _todayCarbs = 0;
  double _todayFats = 0;

  List<Meal> get meals => List.unmodifiable(_meals);
  double get dailyCalorieGoal => _dailyCalorieGoal;
  double get todayCalories => _todayCalories;
  double get todayProtein => _todayProtein;
  double get todayCarbs => _todayCarbs;
  double get todayFats => _todayFats;

  /// Fetch meals from backend
  Future<void> fetchMeals() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.24.185:8000/getMeals'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _meals = data.map((mealData) => Meal.fromJson(mealData)).toList();
        _calculateTodayNutrition();
        notifyListeners();
      } else {
        throw Exception('Failed to fetch meals: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching meals: $e');
    }
  }

  void _calculateTodayNutrition() {
    final today = DateTime.now();
    final todayMeals = _meals.where((meal) {
      final time = meal.time;
      return time != null &&
          time.year == today.year &&
          time.month == today.month &&
          time.day == today.day;
    }).toList();

    _todayCalories = todayMeals.fold(0, (sum, meal) => sum + meal.calories);
    _todayProtein = todayMeals.fold(0, (sum, meal) => sum + meal.protein);
    _todayCarbs = todayMeals.fold(0, (sum, meal) => sum + meal.carbs);
    _todayFats = todayMeals.fold(0, (sum, meal) => sum + meal.fats);
  }

  /// Add meal locally (optional if your backend handles it)
  Future<void> addMeal(Meal meal) async {
    _meals.add(meal);
    _calculateTodayNutrition();
    notifyListeners();
  }

  void setDailyCalorieGoal(double goal) {
    _dailyCalorieGoal = goal;
    notifyListeners();
  }
}
