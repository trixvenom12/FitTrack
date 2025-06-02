class Meal {
  final String id;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fats;
  final String? imageUrl;
  final String? servingSize;
  final String? barcode;
  final DateTime? time; // ✅ use DateTime instead of String

  Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.imageUrl,
    this.servingSize,
    this.barcode,
    this.time,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      calories: json['calories'] ?? 0,
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fats: (json['fats'] ?? 0).toDouble(),
      imageUrl: json['image_url'],
      servingSize: json['serving_size'],
      barcode: json['barcode'],
      time: json['time'] != null ? DateTime.tryParse(json['time']) : null, // ✅ safely parse
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'image_url': imageUrl,
      'serving_size': servingSize,
      'barcode': barcode,
      'time': time?.toIso8601String(),
    };
  }
}