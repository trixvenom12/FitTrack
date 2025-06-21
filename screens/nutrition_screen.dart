import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});
  @override State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final DbHelper _db = DbHelper();
  List<dynamic>? _meals;
  String? _error;

  @override void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    try {
      final data = await _db.getMeals();
      setState(() {
        _meals = data;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition')),
      body: _meals != null
        ? ListView.builder(
            itemCount: _meals!.length,
            itemBuilder: (_, i) => ListTile(
              title: Text(_meals![i]['name'] ?? 'Meal $i'),
              subtitle: Text('Calories: ${_meals![i]['calories']}'),
            ),
          )
        : Center(
            child: _error != null
              ? Text('Error: $_error', style: const TextStyle(color: Colors.red))
              : const CircularProgressIndicator(),
          ),
    );
  }
}
