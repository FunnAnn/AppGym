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

  static Future<List<Data>> fetchAtHomePlans() async {
    final url = Uri.parse('$_baseUrl/plan-exercises/get-all-plan-exercises');
    final headers = await AuthService.getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<Data> result = [];
      for (var item in json['data']) {
        // Lấy diet_plan từ cả 2 kiểu dữ liệu
        String? dietPlan;
        if (item['training_plans'] != null && item['training_plans']['diet_plan'] != null) {
          dietPlan = item['training_plans']['diet_plan'].toString();
        } else if (item['diet_plan'] != null) {
          dietPlan = item['diet_plan'].toString();
        }
        if (dietPlan != null && dietPlan.trim().toUpperCase() == 'AT HOME') {
          result.add(Data.fromJson(item));
        }
      }
      return result;
    } else {
      throw Exception('Failed to load AT HOME plans');
    }
  }

  static Future<List<Data>> fetchAtGymPlans() async {
    final url = Uri.parse('$_baseUrl/plan-exercises/get-all-plan-exercises');
    final headers = await AuthService.getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<Data> result = [];
      for (var item in json['data']) {
        String? dietPlan;
        if (item['training_plans'] != null && item['training_plans']['diet_plan'] != null) {
          dietPlan = item['training_plans']['diet_plan'].toString();
        } else if (item['diet_plan'] != null) {
          dietPlan = item['diet_plan'].toString();
        }
        if (dietPlan != null && dietPlan.trim().toUpperCase() == 'AT GYM') {
          result.add(Data.fromJson(item));
        }
      }
      return result;
    } else {
      throw Exception('Failed to load AT GYM plans');
    }
  }

  static Future<Data> fetchPlanExerciseById(int planExerciseId) async {
    final url = Uri.parse('$_baseUrl/plan-exercises/get-plan-exercises-by-id/$planExerciseId');
    final headers = await AuthService.getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Data.fromJson(json['data']);
    } else {
      throw Exception('Failed to load plan exercise');
    }
  }

  /// Lấy reps, sets của một plan exercise theo id
  static Future<Map<String, int>> fetchRepSetByPlanExerciseId(int planExerciseId) async {
    final data = await PlanService.fetchPlanExerciseById(planExerciseId);
    return {
      'reps': data.reps ?? 0,
      'sets': data.sets ?? 0,
    };
  }

  static Future<Map<String, int>> fetchRestTimeByPlanExerciseId(int planExerciseId) async {
    final data = await PlanService.fetchPlanExerciseById(planExerciseId);
    return {
      'restTime': data.restTime ?? 0,
    };
  }
}