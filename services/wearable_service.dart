import 'package:fittrack/model/activity_model.dart';

class WearableService {
  // Removed HealthFactory and permissions

  Future<bool> requestPermissions() async {
    // Since we no longer interact with Health API,
    // just return true or simulate permissions granted.
    return true;
  }

  Future<List<Activity>> getTodayData() async {
    try {
      // Simulate or fetch steps, heart rate, and calories from your own data source here
      // For example, just return dummy data for now:
      final now = DateTime.now();

      int totalSteps = 5000; // dummy steps
      int averageHeartRate = 72; // dummy heart rate
      int totalCalories = 220; // dummy calories burned

      return [
        Activity(
          steps: totalSteps,
          heartRate: averageHeartRate,
          caloriesBurned: totalCalories,
          date: now,
        ),
      ];
    } catch (e) {
      print("Error getting wearable data: $e");
      return [];
    }
  }

  Future<void> syncWithBackend(String userId) async {
    try {
      final activities = await getTodayData();
      // You can add API call here if you want or leave as is
      print("Synced ${activities.length} activity(ies) to backend for user: $userId");
    } catch (e) {
      print("Sync error: $e");
    }
  }
}
