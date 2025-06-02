import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://api.fittrack.com/v1';

  Future<Map<String, dynamic>> getProductByBarcode(String barcode) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would call an actual API
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

  Future<List<Map<String, dynamic>>> getRecommendedWorkouts() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would call an actual API
    return [
      {
        'name': 'Full Body HIIT',
        'description':
            'High intensity interval training for full body conditioning',
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
          {
            'name': 'Push-ups',
            'sets': 3,
            'reps': 15,
            'rest': '30 sec',
            'image_url': 'https://example.com/pushups.jpg',
          },
          {
            'name': 'Burpees',
            'sets': 3,
            'reps': 10,
            'rest': '45 sec',
            'image_url': 'https://example.com/burpees.jpg',
          },
        ],
        'tags': ['HIIT', 'Full Body'],
      },
      {
        'name': 'Yoga Flow',
        'description': 'Relaxing yoga sequence for flexibility and mindfulness',
        'duration': 45,
        'difficulty': 'Beginner',
        'equipment': ['Yoga Mat'],
        'exercises': [
          {
            'name': 'Sun Salutation',
            'sets': 3,
            'reps': 1,
            'rest': '15 sec',
            'image_url': 'https://example.com/sun-salutation.jpg',
          },
          {
            'name': 'Warrior Pose',
            'sets': 2,
            'reps': 1,
            'rest': '20 sec',
            'image_url': 'https://example.com/warrior-pose.jpg',
          },
          {
            'name': 'Tree Pose',
            'sets': 2,
            'reps': 1,
            'rest': '20 sec',
            'image_url': 'https://example.com/tree-pose.jpg',
          },
        ],
        'tags': ['Yoga', 'Flexibility'],
      },
    ];
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/users/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> syncWithWearable(String userId, String wearableType) async {
    await http.post(
      Uri.parse('$_baseUrl/wearable/sync'),
      body: json.encode({'user_id': userId, 'wearable_type': wearableType}),
    );
  }
}
