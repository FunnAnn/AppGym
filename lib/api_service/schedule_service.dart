import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/schedule.dart';

class ScheduleService {
  static const String baseUrl = 'https://splendid-wallaby-ethical.ngrok-free.app';

  Future<Schedule?> fetchSchedules() async {
    final url = Uri.parse('$baseUrl/schedules/get-schedules');
    try {
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token'); 

      if (token == null) {
        print('No token found');
        return null;
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Schedule.fromJson(jsonData);
      } else {
        // Handle error
        return null;
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      return null;
    }
  }

  Future<bool> createSchedule({
    required int customerId,
    required int coachId,
    required String title,
    required String startDate,
    required String endDate,
    required String description,
    String? color,
  }) async {
    final url = Uri.parse('$baseUrl/schedules/create-schedules');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        print('No token found');
        return false;
      }

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'customer_id': customerId,
          'coach_id': coachId,
          'title': title,
          'start_date': startDate,
          'end_date': endDate,
          'description': description,
          'color': color,
        }),
      );
      print('CREATE_SCHEDULE: Status: ${response.statusCode}');
      print('CREATE_SCHEDULE: Body: ${response.body}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getCoachCustomers() async {
    final url = Uri.parse('$baseUrl/coach-customers/get-coach-customers');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) return [];
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(jsonData['data']);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}