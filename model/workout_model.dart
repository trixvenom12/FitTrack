class Workout {
  final String name;
  final int duration;
  final List<Map<String, dynamic>> exercises; // keeping as Map for flexible exercises data
  final String description;
  final String difficulty;
  final List<String> equipment;
  final List<String> tags;

  Workout({
    required this.name,
    required this.duration,
    required this.exercises,
    this.description = '',
    this.difficulty = '',
    this.equipment = const [],
    this.tags = const [],
  });

  // Factory constructor to parse from JSON
  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      name: json['name'] ?? '',
      duration: json['duration'] ?? 0,
      exercises: List<Map<String, dynamic>>.from(json['exercises'] ?? []),
      description: json['description'] ?? '',
      difficulty: json['difficulty'] ?? '',
      equipment: List<String>.from(json['equipment'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
