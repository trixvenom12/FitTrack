// ignore_for_file: no_leading_underscores_for_local_identifiers, use_super_parameters

import 'package:flutter/material.dart';

class NutritionInputForm extends StatelessWidget {
  final String? initialFoodName;
  final void Function(Map<String, dynamic>) onSave;

  const NutritionInputForm({
    Key? key,
    this.initialFoodName,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller =
        TextEditingController(text: initialFoodName ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Food Details", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(labelText: "Food Name"),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            onSave({
              'foodName': _controller.text,
              // Add more fields if needed
            });
          },
          child: const Text("Save Meal"),
        ),
      ],
    );
  }
}