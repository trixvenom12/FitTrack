import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fittrack/model/meal.dart';
import 'package:fittrack/database/db_helper.dart';

class NutritionScreen extends StatefulWidget {
  final String? barcode;

  const NutritionScreen({super.key, this.barcode});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  List<Meal> _meals = [];

  int get totalCalories => _meals.fold(0, (sum, meal) => sum + meal.calories);

  @override
  void initState() {
    super.initState();
    _loadMeals();
    if (widget.barcode != null) {
      _addScannedMeal(widget.barcode!);
    }
  }

  Future<void> _loadMeals() async {
    final mealData = await DbHelper().getMeals();
    setState(() {
      _meals = mealData.map((data) => Meal.fromJson(data)).toList();
    });
  }

  Future<void> _addScannedMeal(String barcode) async {
    final newMeal = Meal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Scanned Meal ($barcode)',
      calories: 350,
      protein: 25.0,
      carbs: 40.0,
      fats: 15.0,
      barcode: barcode,
      time: DateTime.now(),
    );

    await DbHelper().addMeal(
      newMeal.name,
      newMeal.calories.toDouble(),
      newMeal.protein,
      newMeal.carbs,
      newMeal.fats,
    );

    _loadMeals();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, d MMMM y').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nutrition Tracker"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              formattedDate,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Total Calories: $totalCalories kcal',
              style: const TextStyle(fontSize: 18, color: Colors.redAccent),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _meals.isEmpty
                  ? const Center(child: Text("No meals added yet."))
                  : ListView.builder(
                      itemCount: _meals.length,
                      itemBuilder: (context, index) {
                        final meal = _meals[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(meal.name),
                            subtitle: Text(
                              'Calories: ${meal.calories} kcal\n'
                              'Protein: ${meal.protein}g, Carbs: ${meal.carbs}g, Fats: ${meal.fats}g\n'
                              'Time: ${meal.time != null ? DateFormat.jm().format(meal.time!) : 'N/A'}',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
