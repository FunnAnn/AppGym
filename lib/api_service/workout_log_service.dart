import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/workout_log.dart';
import 'auth_service.dart';

class WorkoutLogService {
  static const String _baseUrl = 'https://splendid-wallaby-ethical.ngrok-free.app';

  static Future<void> createWorkoutLog({
    required int customerId,
    required int planId,
    required int exerciseId,
    required String workoutDate,
    required int actualSets,
    required int actualReps,
    required int actualWeight,
    String? notes,
  }) async {
    final url = Uri.parse('$_baseUrl/workout-logs/create-workout-log');
    final headers = await AuthService.getHeaders();
    final body = jsonEncode({
      "customer_id": customerId,
      "plan_id": planId,
      "exercise_id": exerciseId,
      "workout_date": workoutDate,
      "actual_sets": actualSets,
      "actual_reps": actualReps,
      "actual_weight": actualWeight,
      "notes": notes,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 201) {
      print('API error: ${response.body}');
      throw Exception('Failed to create workout log');
    }
  }
}