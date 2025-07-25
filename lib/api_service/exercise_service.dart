import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/excercise.dart';
import 'auth_service.dart';

class ExerciseService {
  static const String baseUrl = 'https://splendid-wallaby-ethical.ngrok-free.app';
  
  static Future<Excercise> getAllExercises() async {
    try {
      // Get auth token
      final token = await AuthService.getToken();
      
      final response = await http.get(
        Uri.parse('$baseUrl/exercises/get-all-exercises'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'any',
          'User-Agent': 'FlutterApp/1.0',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('Exercise API Response Status: ${response.statusCode}');
      print('Exercise API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Excercise.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized access. Please login again.');
      } else {
        throw Exception('Failed to load exercises: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (e.toString().contains('401') || e.toString().contains('Unauthorized')) {
        throw Exception('Authentication failed. Please login again.');
      }
      throw Exception('Error fetching exercises: $e');
    }
  }

  static Future<bool> deleteExercise(int exerciseId) async {
    try {
      final token = await AuthService.getToken();
      
      final response = await http.delete(
        Uri.parse('$baseUrl/exercises/$exerciseId'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'any',
          'User-Agent': 'FlutterApp/1.0',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('Delete Exercise Response Status: ${response.statusCode}');
      print('Delete Exercise Response Body: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Error deleting exercise: $e');
    }
  }

  static Future<Excercise> createExercise({
    required String exerciseName,
    required String description,
    required String muscleGroup,
    required String equipmentNeeded,
    String? videoUrl,
  }) async {
    try {
      final token = await AuthService.getToken();
      
      final response = await http.post(
        Uri.parse('$baseUrl/exercises'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'any',
          'User-Agent': 'FlutterApp/1.0',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'exercise_name': exerciseName,
          'description': description,
          'muscle_group': muscleGroup,
          'equipment_needed': equipmentNeeded,
          if (videoUrl != null) 'video_url': videoUrl,
        }),
      );

      print('Create Exercise Response Status: ${response.statusCode}');
      print('Create Exercise Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return Excercise.fromJson(jsonData);
      } else {
        throw Exception('Failed to create exercise: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating exercise: $e');
    }
  }

  static Future<Excercise> updateExercise({
    required int exerciseId,
    required String exerciseName,
    required String description,
    required String muscleGroup,
    required String equipmentNeeded,
    String? videoUrl,
  }) async {
    try {
      final token = await AuthService.getToken();
      
      final response = await http.put(
        Uri.parse('$baseUrl/exercises/$exerciseId'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'any',
          'User-Agent': 'FlutterApp/1.0',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'exercise_name': exerciseName,
          'description': description,
          'muscle_group': muscleGroup,
          'equipment_needed': equipmentNeeded,
          if (videoUrl != null) 'video_url': videoUrl,
        }),
      );

      print('Update Exercise Response Status: ${response.statusCode}');
      print('Update Exercise Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Excercise.fromJson(jsonData);
      } else {
        throw Exception('Failed to update exercise: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating exercise: $e');
    }
  }
}
