import 'package:health/health.dart';

class HealthService {
  // Initialize the health plugin
  final Health _health = Health();

  Future<int?> fetchTodaySteps() async {
    
    // _health.configure(useHealthConnectIfAvailable: true);
    
    // only want steps for now
    final types = [HealthDataType.STEPS];
    final permissions = [HealthDataAccess.READ];

    try {
      // 1. Check if we already have permission
      bool? hasPermissions = await _health.hasPermissions(types, permissions: permissions);
      
      // 2. If not, ask the user for permission (This triggers the Android popup)
      if (hasPermissions != true) {
        hasPermissions = await _health.requestAuthorization(types, permissions: permissions);
      }

      // 3. If they said yes, fetch the data!
      if (hasPermissions == true) {
        final now = DateTime.now();
        final midnight = DateTime(now.year, now.month, now.day);
        
        // Grab all steps from 12:00 AM today until right now
        int? steps = await _health.getTotalStepsInInterval(midnight, now);
        return steps ?? 0;
      } else {
        throw Exception("Permission denied by user.");
      }
    } catch (e) {
      print("Health API Error: $e");
      return null;
    }
  }
}