import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class CalorieTrackingProvider extends ChangeNotifier {
  Interpreter? _interpreter;
  List<String> _labels = [];

  String? detectedFood;
  double? estimatedCalories;

  CalorieTrackingProvider() {
    _loadModelAndLabels();
  }

  Future<void> _loadModelAndLabels() async {
    try {
      // Load tflite model from assets
      _interpreter = await Interpreter.fromAsset('model.tflite');

      // Load labels from asset as string
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsData.split('\n').map((e) => e.trim()).toList();
    } catch (e) {
      print('Error loading model or labels: $e');
    }
  }

  Future<void> classifyImage(Uint8List imageBytes) async {
    if (_interpreter == null) return;

    // Preprocess imageBytes here to match model input (e.g., 224x224 RGB normalized floats)
    // For demonstration, assuming input shape: [1, 224, 224, 3]

    // Example preprocessing: convert imageBytes to a Float32List normalized between 0-1
    // You'll want to decode imageBytes, resize to 224x224, and normalize pixels.
    // Since no helper package, this must be done manually or via another package like 'image'.

    // TODO: Implement actual image preprocessing here.
    // For now, create a dummy input tensor filled with zeros:
    var input = List.generate(1, (_) => List.generate(224 * 224 * 3, (_) => 0.0));

    // Prepare output buffer. Output shape usually [1, number_of_labels]
    var output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

    // Run inference
    _interpreter!.run(input, output);

    // Find the index of max probability
    List<double> probabilities = List<double>.from(output[0]);
    int maxIndex = 0;
    double maxProb = probabilities[0];

    for (int i = 1; i < probabilities.length; i++) {
      if (probabilities[i] > maxProb) {
        maxProb = probabilities[i];
        maxIndex = i;
      }
    }

    detectedFood = _labels[maxIndex];
    estimatedCalories = _getCaloriesForFood(detectedFood!);
    notifyListeners();
  }

  double _getCaloriesForFood(String foodName) {
    Map<String, double> calorieMap = {
      'apple': 52.0,
      'banana': 89.0,
      'burger': 295.0,
      'pizza': 266.0,
      'salad': 33.0,
    };
    return calorieMap[foodName.toLowerCase()] ?? 0.0;
  }
}
