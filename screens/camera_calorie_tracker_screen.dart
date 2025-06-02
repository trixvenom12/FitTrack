import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calorie_tracking_provider.dart';

class CameraCalorieTrackerScreen extends StatefulWidget {
  const CameraCalorieTrackerScreen({super.key});

  @override
  State<CameraCalorieTrackerScreen> createState() => _CameraCalorieTrackerScreenState();
}

class _CameraCalorieTrackerScreenState extends State<CameraCalorieTrackerScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.medium);
      await _controller!.initialize();
      setState(() {});
    }
  }

  Future<void> _captureAndAnalyze() async {
    if (_controller == null || !_controller!.value.isInitialized || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      XFile file = await _controller!.takePicture();
      final bytes = await file.readAsBytes();

      await context.read<CalorieTrackingProvider>().classifyImage(bytes);
    } catch (e) {
      print('Error capturing image: $e');
    }

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final calorieProvider = context.watch<CalorieTrackingProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Calorie Tracker')),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: CameraPreview(_controller!),
          ),
          ElevatedButton(
            onPressed: _captureAndAnalyze,
            child: _isProcessing
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Capture & Analyze'),
          ),
          if (calorieProvider.detectedFood != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Detected Food: ${calorieProvider.detectedFood}\nEstimated Calories: ${calorieProvider.estimatedCalories?.toStringAsFixed(2)} kcal',
                style: const TextStyle(fontSize: 18),
              ),
            ),
        ],
      ),
    );
  }
}
