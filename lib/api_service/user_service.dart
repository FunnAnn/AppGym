import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_service/auth_service.dart';
import '../model/user.dart' as UserModel;

class UserService {
  static const String _baseUrl = 'https://splendid-wallaby-ethical.ngrok-free.app';

  Future<List<UserModel.Data>> getAllUsers() async {
    try {
      final headers = await AuthService.getHeaders();
      final currentUserRole = await AuthService.getUserRole();
      
      final url = Uri.parse('$_baseUrl/user/get-all-users');
      
      print('Getting all users from: $url');
      print('Current user role: $currentUserRole');
      print('Headers: $headers');
      
      final response = await http.get(url, headers: headers);
      
      print('Get all users response status: ${response.statusCode}');
      print('Get all users response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final userResponse = UserModel.User.fromJson(jsonData);
        
        List<UserModel.Data> users = userResponse.data ?? [];
        
        // No filtering - all users can see all other users
        print('Returning all users without filtering: ${users.length} users');
        
        return users;
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting all users: $e');
      throw Exception('Error loading users: $e');
    }
  }

  Future<List<UserModel.Data>> getCoachesWithCustomers() async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/user/get-user-role-coach');
      
      print('Getting coaches with customers from: $url');
      print('Headers: $headers');
      
      final response = await http.get(url, headers: headers);
      
      print('Get coaches with customers response status: ${response.statusCode}');
      print('Get coaches with customers response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final userResponse = UserModel.User.fromJson(jsonData);
        
        return userResponse.data ?? [];
      } else {
        throw Exception('Failed to load coaches with customers: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting coaches with customers: $e');
      throw Exception('Error loading coaches with customers: $e');
    }
  }
}