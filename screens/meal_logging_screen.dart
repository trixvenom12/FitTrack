import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:fittrack/services/food_recognition_service.dart';
import 'package:fittrack/widgets/nutrition_input_form.dart';

class MealLoggingScreen extends StatefulWidget {
  const MealLoggingScreen({super.key});

  @override
  State<MealLoggingScreen> createState() => _MealLoggingScreenState();
}

class _MealLoggingScreenState extends State<MealLoggingScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;
  String? _barcodeData;
  String? _recognizedFood;
  double? _confidence;

  @override
  void initState() {
    super.initState();
    FoodRecognitionService.loadModel();
  }

  @override
  void dispose() {
    FoodRecognitionService.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          _imagePath = photo.path;
        });

        // Try to recognize food
        final result = await FoodRecognitionService.recognizeFood(
          File(photo.path),
        );
        if (result['success'] == true) {
          setState(() {
            _recognizedFood = result['foodType'];
            _confidence = result['confidence'];
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error taking photo: ${e.toString()}")),
      );
    }
  }

  Future<void> _scanBarcode() async {
    try {
      final result = await BarcodeScanner.scan();
      setState(() {
        _barcodeData = result.rawContent;
      });

      // TODO: Fetch product info using barcode from database if needed
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error scanning barcode: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log a Meal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image preview
            if (_imagePath != null)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: FileImage(File(_imagePath!)),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.fastfood, size: 50, color: Colors.grey),
              ),

            const SizedBox(height: 16),

            // Recognition results
            if (_recognizedFood != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recognized: $_recognizedFood",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Confidence: ${((_confidence ?? 0.0) * 100).toStringAsFixed(1)}%",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // Barcode results
            if (_barcodeData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Scanned Barcode:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(_barcodeData!),
                  const SizedBox(height: 16),
                ],
              ),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                    onPressed: _takePhoto,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner), // fallback icon
                    label: const Text('Scan Barcode'),
                    onPressed: _scanBarcode,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Nutrition input form
            NutritionInputForm(
              initialFoodName: _recognizedFood,
              onSave: (mealData) {
                // TODO: Save meal to backend
                // Include _imagePath and _barcodeData if available
              },
            ),
          ],
        ),
      ),
    );
  }
}
