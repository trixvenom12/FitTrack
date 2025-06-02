import 'package:flutter/material.dart';
import 'package:fittrack/screens/product_detail_screen.dart';
import 'package:fittrack/services/barcode_service.dart';
import 'package:fittrack/widgets/custom_button.dart';
import 'package:fittrack/widgets/custom_loader.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  String? _scannedBarcode;
  bool _isLoading = false;
  Map<String, dynamic>? productData;

  void _scanBarcode() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final barcode = await BarcodeService.scanBarcode();
      setState(() {
        _scannedBarcode = barcode;
      });

      if (barcode != null && barcode.isNotEmpty) {
        final data = await BarcodeService.getProductByBarcode(barcode);
        setState(() {
          productData = data;
        });
      }
    } catch (e) {
      print('Error scanning barcode: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
      ),
      body: _isLoading
          ? const CustomLoader()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomButton(
                    text: 'Scan Barcode',
                    onPressed: _scanBarcode,
                  ),
                  const SizedBox(height: 20),
                  if (_scannedBarcode != null)
                    Text(
                      'Scanned Barcode: $_scannedBarcode',
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 20),
                  if (productData != null) ...[
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productData!['product_name'] ?? 'Unknown Product',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              productData!['description'] ?? 'No description available',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withAlpha((0.7 * 255).toInt()), // Replaced withOpacity
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      productData: productData!,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('View Details'),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ],
              ),
            ),
    );
  }
}
