import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    final nutrition = productData['nutrition'] as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: Text(productData['product_name'] ?? 'Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              productData['description'] ?? 'No description available',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            if (nutrition != null) ...[
              const Text(
                'Nutritional Information:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Calories: ${nutrition['calories']}'),
              Text('Protein: ${nutrition['protein']}'),
              Text('Carbohydrates: ${nutrition['carbs']}'),
              Text('Fat: ${nutrition['fat']}'),
            ]
          ],
        ),
      ),
    );
  }
}
