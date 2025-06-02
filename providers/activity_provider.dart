import 'package:flutter/foundation.dart';
import '../model/activity_model.dart';

class ActivityProvider with ChangeNotifier {
  final List<Activity> _activities = [];

  int _todaySteps = 0;
  int _todayCalories = 0;
  int _todayHeartRate = 0;

  List<Activity> get activities => List.unmodifiable(_activities);
  int get todaySteps => _todaySteps;
  int get todayCalories => _todayCalories;
  int get todayHeartRate => _todayHeartRate;

  Future<void> fetchActivities() async {
    _activities.clear();
    _activities.addAll([
      Activity(
        steps: 5000,
        caloriesBurned: 300,
        heartRate: 72,
        date: DateTime.now(),
      ),
      Activity(
        steps: 4500,
        caloriesBurned: 280,
        heartRate: 75,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);
    _calculateTodayStats();
    notifyListeners();
  }

  Future<void> addActivity(Activity activity) async {
    _activities.add(activity);
    _calculateTodayStats();
    notifyListeners();
  }

  void _calculateTodayStats() {
    final now = DateTime.now();

    final todayActivities = _activities.where((activity) =>
        activity.date.year == now.year &&
        activity.date.month == now.month &&
        activity.date.day == now.day);

    _todaySteps = todayActivities.fold(0, (sum, a) => sum + a.steps);
    _todayCalories = todayActivities.fold(0, (sum, a) => sum + a.caloriesBurned);

    final heartRates = todayActivities.map((a) => a.heartRate).toList();
    _todayHeartRate =
        heartRates.isNotEmpty ? (heartRates.reduce((a, b) => a + b) ~/ heartRates.length) : 0;
  }
}
