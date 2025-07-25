import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/training_plan.dart';
import 'auth_service.dart';

class PlanService {
  static const String _baseUrl = 'https://splendid-wallaby-ethical.ngrok-free.app';

  static Future<TrainingPlan> fetchAllPlans() async {
    final url = Uri.parse('$_baseUrl/training-plans/get-all-training-plans');
    final headers = await AuthService.getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return TrainingPlan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load training plans');
    }
  }
}