import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://127.0.0.1:8000'; // Use local IP for emulator or real device

  // ------------------ Get Product by Barcode ------------------
  Future<Map<String, dynamic>> getProductByBarcode(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/food/barcode/$barcode'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to fetch product: ${response.statusCode}');
      }
    } catch (e) {
      print('Barcode API error: $e');
      // Simulated fallback (remove in production)
      return {
        'product_name': 'Protein Bar',
        'calories': 210,
        'protein': 20,
        'carbohydrates': 22,
        'fat': 8,
        'serving_size': '1 bar (50g)',
        'image_url': 'https://example.com/protein-bar.jpg',
      };
    }
  }

  // ------------------ Get Recommended Workouts ------------------
  Future<List<Map<String, dynamic>>> getRecommendedWorkouts() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/workouts/recommendations'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load workouts: ${response.statusCode}');
      }
    } catch (e) {
      print('Workout API error: $e');
      // Simulated fallback (remove in production)
      return [
        {
          'name': 'Full Body HIIT',
          'description': 'High intensity training for full body',
          'duration': 30,
          'difficulty': 'Intermediate',
          'equipment': ['Dumbbells', 'Yoga Mat'],
          'exercises': [
            {
              'name': 'Jump Squats',
              'sets': 3,
              'reps': 12,
              'rest': '30 sec',
              'image_url': 'https://example.com/jump-squats.jpg',
            },
          ],
          'tags': ['HIIT', 'Full Body'],
        }
      ];
    }
  }

  // ------------------ Get User Data ------------------
  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/user/$userId'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('User API error: $e');
      throw Exception('Unable to fetch user data');
    }
  }

  // ------------------ Sync with Wearable ------------------
  Future<void> syncWithWearable(String userId, String wearableType) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/wearable/sync'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId, 'wearable_type': wearableType}),
      );

      if (response.statusCode != 200) {
        throw Exception('Sync failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Wearable Sync error: $e');
      throw Exception('Unable to sync with wearable');
    }
  }
}
