import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/plan_exercise.dart';
import 'auth_service.dart';

class PlanService {
  static const String _baseUrl = 'https://splendid-wallaby-ethical.ngrok-free.app';

  static Future<PlanExcercise> fetchAllPlans() async {
    final url = Uri.parse('$_baseUrl/plan-exercises/get-all-plan-exercises');
    final headers = await AuthService.getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return PlanExcercise.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load training plans');
    }
  }
}