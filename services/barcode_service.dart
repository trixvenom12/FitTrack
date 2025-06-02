import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeService {
  static Future<String?> scanBarcode() async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color of the scanning line
        'Cancel', // Cancel button text
        true, // Show flash icon
        ScanMode.BARCODE,
      );

      if (barcode == '-1') {
        return null; // User cancelled the scan
      }
      return barcode;
    } catch (e) {
      print('Error scanning barcode: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> getProductByBarcode(String barcode) async {
    // Simulate an API/database lookup with dummy data
    // Replace this with actual API integration logic
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
}
