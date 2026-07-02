import 'package:health/health.dart';

class HealthService {
  // Initialize the Health plugin
  final Health _health = Health();

  Future<int?> fetchTodaySteps() async {
    // Define exactly what data you want to read
    final types = [HealthDataType.STEPS];
    final permissions = [HealthDataAccess.READ];

    try {
      // FIX: Just call configure() empty! Health Connect is now the default.
      _health.configure();

      // Request authorization
      bool hasPermission = await _health.requestAuthorization(types, permissions: permissions);

      if (hasPermission) {
        final now = DateTime.now();
        final midnight = DateTime(now.year, now.month, now.day);

        // Fetch the steps safely
        int? steps = await _health.getTotalStepsInInterval(midnight, now);
        
        return steps ?? 0;
      } else {
        print("User denied Health Connect permissions.");
        return null;
      }
    } catch (e) {
      print("Error communicating with Health Connect: $e");
      return null;
    }
  }
}