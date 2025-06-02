import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

class FoodRecognitionService {
  static const String modelFile = "assets/model/food_model.tflite";
  static const String labelsFile = "assets/model/food_labels.txt";

  static List<String> labels = [];

  static Future<void> loadModel() async {
    try {
      await Tflite.loadModel(model: modelFile, labels: labelsFile);

      // Load labels
      String labelContent = await rootBundle.loadString(labelsFile);
      labels = labelContent.split('\n').map((e) => e.trim()).toList();
    } catch (e) {
      print("Failed to load model: $e");
    }
  }

  static Future<Map<String, dynamic>> recognizeFood(File imageFile) async {
    try {
      // Read image bytes
      Uint8List imageBytes = await imageFile.readAsBytes();

      // Decode image using dart:ui
      ui.Image image = await _loadUiImage(imageBytes);

      // Resize to 224x224 for model input
      ui.Image resizedImage = await _resizeUiImage(image, 224, 224);

      // Convert resized image to normalized Float32List bytes for tflite
      Uint8List inputBytes = await _imageToByteListFloat32(resizedImage, 224, 127.5, 127.5);

      // Run inference
      var recognitions = await Tflite.runModelOnBinary(binary: inputBytes);

      if (recognitions == null || recognitions.isEmpty) {
        return {"success": false, "message": "No recognition results"};
      }

      var topResult = recognitions[0];
      return {
        "success": true,
        "foodType": labels[topResult['index']],
        "confidence": topResult['confidence'],
      };
    } catch (e) {
      print("Recognition error: $e");
      return {"success": false, "message": e.toString()};
    }
  }

  // Load image from bytes using dart:ui
  static Future<ui.Image> _loadUiImage(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  // Resize the ui.Image using canvas
  static Future<ui.Image> _resizeUiImage(ui.Image image, int targetWidth, int targetHeight) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final paint = ui.Paint();

    final src = ui.Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dst = ui.Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble());

    canvas.drawImageRect(image, src, dst, paint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(targetWidth, targetHeight);
    return img;
  }

  // Convert ui.Image to normalized Float32List
  static Future<Uint8List> _imageToByteListFloat32(
      ui.Image image, int inputSize, double mean, double std) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) throw Exception("Failed to get image bytes");

    final buffer = byteData.buffer;
    final float32List = Float32List(inputSize * inputSize * 3);
    int pixelIndex = 0;

    // Pixels are RGBA, 4 bytes per pixel
    for (int i = 0; i < buffer.lengthInBytes; i += 4) {
      final r = buffer.asUint8List()[i];
      final g = buffer.asUint8List()[i + 1];
      final b = buffer.asUint8List()[i + 2];

      float32List[pixelIndex++] = (r - mean) / std;
      float32List[pixelIndex++] = (g - mean) / std;
      float32List[pixelIndex++] = (b - mean) / std;
    }
    return float32List.buffer.asUint8List();
  }

  static void dispose() {
    Tflite.close();
  }
}
