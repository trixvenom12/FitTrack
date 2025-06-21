class Activity {
  final int steps;
  final int caloriesBurned;
  final int heartRate;
  final double? distance;       // in meters or kilometers
  final double? sleepHours;     // duration of sleep
  final DateTime date;
  final String? source;         // e.g., "Google Fit", "Apple Health"

  Activity({
    required this.steps,
    required this.caloriesBurned,
    required this.heartRate,
    this.distance,
    this.sleepHours,
    required this.date,
    this.source,
  });

  Map<String, dynamic> toMap() {
    return {
      'steps': steps,
      'caloriesBurned': caloriesBurned,
      'heartRate': heartRate,
      'distance': distance,
      'sleepHours': sleepHours,
      'date': date.toIso8601String(),
      'source': source,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      steps: map['steps'] ?? 0,
      caloriesBurned: map['caloriesBurned'] ?? 0,
      heartRate: map['heartRate'] ?? 0,
      distance: map['distance'] != null ? (map['distance'] as num).toDouble() : null,
      sleepHours: map['sleepHours'] != null ? (map['sleepHours'] as num).toDouble() : null,
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      source: map['source'],
    );
  }

  String get formattedDate => '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';

  String get formattedTime =>
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}
