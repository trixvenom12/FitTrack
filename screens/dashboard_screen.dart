import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fittrack/providers/activity_provider.dart';
import 'package:fittrack/providers/nutrition_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);
    final nutritionProvider = Provider.of<NutritionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildActivityCard(activityProvider),
            const SizedBox(height: 16),
            _buildNutritionCard(nutritionProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(ActivityProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Today\'s Activity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Steps', '${provider.todaySteps}'),
                _buildStat('Calories', '${provider.todayCalories}'),
                _buildStat('Heart Rate', '${provider.todayHeartRate}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionCard(NutritionProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Today\'s Nutrition',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Calories',
                    '${provider.todayCalories}/${provider.dailyCalorieGoal}'),
                _buildStat('Protein', '${provider.todayProtein}g'),
                _buildStat('Carbs', '${provider.todayCarbs}g'),
                _buildStat('Fats', '${provider.todayFats}g'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
