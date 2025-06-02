class HealthService {
  // Simulated data - replace these with real data or APIs when ready
  Future<bool> checkPermissions() async {
    // Always return true for now
    return true;
  }

  Future<int> getSteps() async {
    // Return a fixed or randomly generated number of steps
    await Future.delayed(Duration(milliseconds: 100)); // simulate delay
    return 5000; // example steps count
  }

  Future<int> getCaloriesBurned() async {
    // Return a fixed or randomly generated calories burned value
    await Future.delayed(Duration(milliseconds: 100));
    return 250; // example calories burned
  }

  Future<int> getHeartRate() async {
    // Return a fixed or randomly generated heart rate value
    await Future.delayed(Duration(milliseconds: 100));
    return 72; // example heart rate in bpm
  }
}
