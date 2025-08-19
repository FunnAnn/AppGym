import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_service/auth_service.dart';
import '../model/checkin.dart';

class CheckinService {
  static const String _baseUrl = 'https://splendid-wallaby-ethical.ngrok-free.app';

  // GET /checkins/get-all-checkins
  static Future<Checkin> getAllCheckins() async {
    final headers = await AuthService.getHeaders();
    final url = Uri.parse('$_baseUrl/checkins/get-all-checkins');
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return Checkin.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load all checkins');
    }
  }

  // GET /checkins/get-checkin-by-today
  static Future<Checkin> getCheckinByToday() async {
    final headers = await AuthService.getHeaders();
    final url = Uri.parse('$_baseUrl/checkins/get-checkin-by-today');
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return Checkin.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load today checkins');
    }
  }

  // GET /checkins/get-checkin-by-today-user/{userId}
  static Future<Checkin> getCheckinByTodayUser(int userId) async {
    final headers = await AuthService.getHeaders();
    final url = Uri.parse('$_baseUrl/checkins/get-checkin-by-today-user/$userId');
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return Checkin.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load today checkin for user');
    }
  }

  // GET /checkins/get-checkin-by-user/{userId}
  static Future<Checkin> getCheckinByUser(int userId) async {
    final headers = await AuthService.getHeaders();
    final url = Uri.parse('$_baseUrl/checkins/get-checkin-by-user/$userId');
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return Checkin.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load checkins for user');
    }
  }

  // POST /checkins/create-checkin/{userId}
  static Future<bool> createCheckin(int userId) async {
    final headers = await AuthService.getHeaders();
    final url = Uri.parse('$_baseUrl/checkins/create-checkin/$userId');
    final response = await http.post(url, headers: headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to create checkin');
    }
  }

  // POST /checkins/create-checkout/{userId}
  static Future<bool> createCheckout(int userId) async {
    final headers = await AuthService.getHeaders();
    final url = Uri.parse('$_baseUrl/checkins/create-checkout/$userId');
    final response = await http.post(url, headers: headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to create checkout');
    }
  }
}