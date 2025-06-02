import 'package:flutter/foundation.dart';
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

  Future<void> fetchMeals() async {
    final now = DateTime.now();

    // Replace with actual API call to fetch meals
    _meals = [
      Meal(
        id: '1',
        name: 'Breakfast',
        calories: 500,
        protein: 30,
        carbs: 50,
        fats: 20,
        time: DateTime(now.year, now.month, now.day, 8, 0),
      ),
      Meal(
        id: '2',
        name: 'Lunch',
        calories: 700,
        protein: 40,
        carbs: 60,
        fats: 25,
        time: DateTime(now.year, now.month, now.day, 12, 30),
      ),
    ];

    _calculateTodayNutrition();
    notifyListeners();
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
