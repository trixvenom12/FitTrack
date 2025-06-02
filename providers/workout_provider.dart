import 'package:flutter/foundation.dart';
import '../model/workout.dart';

class WorkoutProvider with ChangeNotifier {
  List<Workout> _workouts = [];
  List<Workout> _recommendedWorkouts = [];
  List<WorkoutPlan> _workoutPlans = [];
  WorkoutPlan? _currentPlan;

  List<Workout> get workouts => List.unmodifiable(_workouts);
  List<Workout> get recommendedWorkouts => List.unmodifiable(_recommendedWorkouts);
  List<WorkoutPlan> get workoutPlans => List.unmodifiable(_workoutPlans);
  WorkoutPlan? get currentPlan => _currentPlan;

  Future<void> fetchWorkouts() async {
    _workouts = []; // Replace with API call
    notifyListeners();
  }

  Future<void> fetchWorkoutPlans() async {
    _workoutPlans = []; // Replace with API call
    notifyListeners();
  }

  Future<void> setCurrentPlan(WorkoutPlan plan) async {
    _currentPlan = plan;
    notifyListeners();
  }

  Future<void> addWorkout(Workout workout) async {
    _workouts.add(workout);
    notifyListeners();
  }

  Future<void> completeWorkout(Workout workout) async {
    // Implement completion logic if needed
    notifyListeners();
  }

  Future<void> setRecommendedWorkouts(List<Workout> workouts) async {
    _recommendedWorkouts = workouts;
    notifyListeners();
  }
}
