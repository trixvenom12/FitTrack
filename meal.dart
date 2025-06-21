class Meal {
  final String id;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fats;
  final String? barcode;
  final DateTime? time;

  Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.barcode,
    this.time,
  });

  // ✅ Factory constructor to create Meal from JSON
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unnamed Meal',
      calories: int.tryParse(json['calories'].toString()) ?? 0,
      protein: double.tryParse(json['protein'].toString()) ?? 0.0,
      carbs: double.tryParse(json['carbs'].toString()) ?? 0.0,
      fats: double.tryParse(json['fats'].toString()) ?? 0.0,
      barcode: json['barcode'],
      time: json['time'] != null ? DateTime.tryParse(json['time']) : null,
    );
  }

  // ✅ Optional: Convert a Meal instance to JSON (useful if you're sending data to backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'barcode': barcode,
      'time': time?.toIso8601String(),
    };
  }
}
