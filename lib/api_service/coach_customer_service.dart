import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_coach.dart';
import 'auth_service.dart';

class CoachCustomerService {
  static const String baseUrl = 'https://splendid-wallaby-ethical.ngrok-free.app';
  
  static Future<UserCoach> getCoachCustomers() async {
    try {
      final headers = await AuthService.getHeaders();
      if (headers == null) {
        throw Exception('No authentication headers found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/coach-customers/get-coach-customers'),
        headers: headers,
      );

      print('Coach Customers API Response Status: ${response.statusCode}');
      print('Coach Customers API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        
        // Handle different response formats
        if (jsonData is List) {
          // If response is a direct list, wrap it in UserCoach structure
          return UserCoach(
            data: jsonData.map((item) => Data.fromJson(item)).toList(),
            message: 'Success',
            statusCode: 200,
            date: DateTime.now().toIso8601String(),
          );
        } else if (jsonData is Map<String, dynamic>) {
          // If response is an object, try to parse as UserCoach
          return UserCoach.fromJson(jsonData);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load coach customers: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getCoachCustomers: $e');
      throw Exception('Error loading coach customers: $e');
    }
  }
}
