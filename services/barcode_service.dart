import 'dart:io';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';

class BarcodeService {
  static final BarcodeScanner _barcodeScanner = BarcodeScanner();

  /// Picks an image from the camera and scans for a barcode.
  static Future<String?> scanBarcodeFromImage() async {
    try {
      final picker = ImagePicker();
      final XFile? imageFile = await picker.pickImage(source: ImageSource.camera);

      if (imageFile == null) return null;

      final inputImage = InputImage.fromFile(File(imageFile.path));
      final List<Barcode> barcodes = await _barcodeScanner.processImage(inputImage);

      if (barcodes.isEmpty) {
        print('No barcode found.');
        return null;
      }

      return barcodes.first.rawValue;
    } catch (e) {
      print('Error scanning barcode: $e');
      return null;
    }
  }

  /// Simulated backend or API lookup
  static Future<Map<String, dynamic>> getProductByBarcode(String barcode) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay

    return {
      'product_name': 'Protein Bar',
      'description': 'High protein snack bar with 20g protein and low sugar.',
      'barcode': barcode,
      'nutrition': {
        'calories': 200,
        'protein': '20g',
        'carbs': '18g',
        'fat': '6g',
      },
    };
  }

  static void dispose() {
    _barcodeScanner.close();
  }
}
