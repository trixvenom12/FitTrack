import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late TextEditingController _weightController;
  late TextEditingController _targetWeightController;
  late TextEditingController _stepsController;

  String _selectedGoal = '';
  String _selectedActivityLevel = '';

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserModel>(context, listen: false);

    _weightController =
        TextEditingController(text: user.currentWeight.toString());
    _targetWeightController =
        TextEditingController(text: user.targetWeight.toString());
    _stepsController =
        TextEditingController(text: user.dailySteps.toString());

    _selectedGoal = user.fitnessGoal;
    _selectedActivityLevel = user.activityLevel;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _targetWeightController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveGoals,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fitness Goal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildGoalChip('Lose Weight'),
                _buildGoalChip('Build Muscle'),
                _buildGoalChip('Maintain Weight'),
                _buildGoalChip('Improve Endurance'),
                _buildGoalChip('General Fitness'),
              ],
            ),
            const SizedBox(height: 24),
            _buildTextField(_weightController, 'Current Weight (kg)'),
            const SizedBox(height: 16),
            _buildTextField(_targetWeightController, 'Target Weight (kg)'),
            const SizedBox(height: 24),
            const Text(
              'Activity Level',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                _buildActivityLevelRadio('Sedentary', 'Little or no exercise'),
                _buildActivityLevelRadio(
                  'Lightly Active',
                  'Light exercise 1-3 days/week',
                ),
                _buildActivityLevelRadio(
                  'Moderately Active',
                  'Moderate exercise 3-5 days/week',
                ),
                _buildActivityLevelRadio(
                  'Very Active',
                  'Hard exercise 6-7 days/week',
                ),
                _buildActivityLevelRadio(
                  'Extremely Active',
                  'Very hard exercise & physical job',
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildTextField(_stepsController, 'Daily Step Goal'),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalChip(String goal) {
    return ChoiceChip(
      label: Text(goal),
      selected: _selectedGoal == goal,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedGoal = goal;
          });
        }
      },
    );
  }

  Widget _buildActivityLevelRadio(String level, String description) {
    return RadioListTile<String>(
      title: Text(level),
      subtitle: Text(description),
      value: level,
      groupValue: _selectedActivityLevel,
      onChanged: (value) {
        setState(() {
          _selectedActivityLevel = value!;
        });
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }

  void _saveGoals() {
    final user = Provider.of<UserModel>(context, listen: false);

    user.updateUser(
      fitnessGoal: _selectedGoal,
      currentWeight:
          double.tryParse(_weightController.text) ?? user.currentWeight,
      targetWeight:
          double.tryParse(_targetWeightController.text) ?? user.targetWeight,
      activityLevel: _selectedActivityLevel,
      dailySteps: int.tryParse(_stepsController.text) ?? user.dailySteps,
    );

    Navigator.pop(context);
  }
}
