// lib/screens/activity_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fittrack/providers/activity_provider.dart';
import 'package:fittrack/model/activity_model.dart';

import 'package:intl/intl.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();

  @override
  void dispose() {
    _stepsController.dispose();
    _caloriesController.dispose();
    _heartRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildActivitySummary(activityProvider),
            const SizedBox(height: 20),
            Expanded(child: _buildActivityHistory(activityProvider)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddActivitySheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildActivitySummary(ActivityProvider provider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Today\'s Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Steps', provider.todaySteps.toString()),
                _buildStatItem('Calories', provider.todayCalories.toString()),
                _buildStatItem('Heart Rate', provider.todayHeartRate.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildActivityHistory(ActivityProvider provider) {
    if (provider.activities.isEmpty) {
      return const Center(child: Text('No activities recorded yet'));
    }

    return ListView.builder(
      itemCount: provider.activities.length,
      itemBuilder: (context, index) {
        final activity = provider.activities[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            title: Text(DateFormat.yMMMd().format(activity.date)),
            subtitle: Text('Steps: ${activity.steps}, HR: ${activity.heartRate}'),
            trailing: Text('${activity.caloriesBurned} cal'),
          ),
        );
      },
    );
  }

  void _showAddActivitySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: [
                const Text(
                  'Add Activity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _stepsController,
                  decoration: const InputDecoration(labelText: 'Steps'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _caloriesController,
                  decoration: const InputDecoration(labelText: 'Calories Burned'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _heartRateController,
                  decoration: const InputDecoration(labelText: 'Heart Rate'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final steps = int.tryParse(_stepsController.text.trim()) ?? 0;
                    final calories = int.tryParse(_caloriesController.text.trim()) ?? 0;
                    final heartRate = int.tryParse(_heartRateController.text.trim()) ?? 0;

                    if (steps > 0 && calories > 0 && heartRate > 0) {
                      final activity = Activity(
                        steps: steps,
                        caloriesBurned: calories,
                        heartRate: heartRate,
                        date: DateTime.now(),
                      );

                      Provider.of<ActivityProvider>(context, listen: false)
                          .addActivity(activity);

                      _stepsController.clear();
                      _caloriesController.clear();
                      _heartRateController.clear();
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter valid numbers in all fields"),
                        ),
                      );
                    }
                  },
                  child: const Text('Save Activity'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
