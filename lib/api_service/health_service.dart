import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'auth_service.dart';
import '../model/health.dart' as HealthModel;

class HealthService {
  static const String _baseUrl = 'https://splendid-wallaby-ethical.ngrok-free.app';
  
  // Get current user info
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/user/me');
      
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to get current user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting current user: $e');
      throw Exception('Error loading current user: $e');
    }
  }

  // Get health data by user ID - return Map for compatibility
  static Future<Map<String, dynamic>?> getHealthByUserId(int userId) async {
    try {
      final headers = await AuthService.getHeaders();
      if (headers == null) {
        throw Exception('No authentication headers found');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/health/get-health-by-user-id/$userId'),
        headers: headers,
      );

      print('Health API Response Status: ${response.statusCode}');
      print('Health API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        return jsonData['data'];
      } else if (response.statusCode == 404) {
        return null; // No health data found
      } else {
        throw Exception('Failed to load health data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting health data for user $userId: $e');
      throw Exception('Error loading health data: $e');
    }
  }

  // Save health data - return Map for compatibility
  static Future<Map<String, dynamic>> saveHealthData({
    required int userId,
    required double weight,
    required double height,
    required int age,
    required bool gender,
  }) async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/health/add');
      
      final body = {
        'user_id': userId,
        'weight': weight,
        'height': height,
        'age': age,
        'gender': gender,
      };

      print('Saving health data: $body');
      
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      
      print('Save health response status: ${response.statusCode}');
      print('Save health response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to save health data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error saving health data: $e');
      throw Exception('Error saving health data: $e');
    }
  }

  // Legacy method for backward compatibility (if other files still use it)
  static Future<void> saveHealth({
    required int userId,
    required int weight,
    required int height,
    required int age,
  }) async {
    await saveHealthData(
      userId: userId,
      weight: weight.toDouble(),
      height: height.toDouble(),
      age: age,
      gender: true, // Default to male for legacy calls
    );
  }

  // Calculate BMI
  static double calculateBMI(double weight, double height) {
    double heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  // Get BMI status
  static String getBMIStatus(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal weight';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  // Get BMI color
  static Color getBMIColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.blue;
    } else if (bmi >= 18.5 && bmi < 25) {
      return Colors.green;
    } else if (bmi >= 25 && bmi < 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  static Future<int?> getUserIdFromProfile() async {
    return await AuthService.getCurrentUserId();
  }
}
