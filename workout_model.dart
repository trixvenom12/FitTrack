class Workout {
  final String name;
  final int duration;
  final List<Map<String, dynamic>> exercises;
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

  // Factory constructor to create a Workout object from JSON data
  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      name: json['name'] ?? '',
      duration: json['duration'] ?? 0,
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      description: json['description'] ?? '',
      difficulty: json['difficulty'] ?? '',
      equipment: (json['equipment'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
