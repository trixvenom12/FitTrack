class Workout {
  final String name;
  final String description;
  final int duration;
  final String difficulty;
  final List<String> equipment;
  final List<Map<String, dynamic>> exercises;
  final List<String> tags;

  Workout({
    required this.name,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.equipment,
    required this.exercises,
    required this.tags,
  });
}

class WorkoutPlan {
  final String name;
  final String description;
  final String difficulty;
  final List<Workout> workouts;

  WorkoutPlan({
    required this.name,
    required this.description,
    required this.difficulty,
    required this.workouts,
  });
}
