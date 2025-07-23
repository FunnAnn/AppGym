import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_service/auth_service.dart';
import '../model/user.dart' as UserModel;
import '../model/user_coach.dart' as UserCoachModel;

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

  Future<List<UserCoachModel.Data>> getCoachCustomers() async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/coach-customers/get-coach-customers');
      
      print('Getting coach customers from: $url');
      print('Headers: $headers');
      
      final response = await http.get(url, headers: headers);
      
      print('Get coach customers response status: ${response.statusCode}');
      print('Get coach customers response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final userCoachResponse = UserCoachModel.UserCoach.fromJson(jsonData);
        
        return userCoachResponse.data ?? [];
      } else {
        throw Exception('Failed to load coach customers: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting coach customers: $e');
      throw Exception('Error loading coach customers: $e');
    }
  }

  Future<Map<String, dynamic>?> getMembershipCardByUserId(int userId) async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/memberships/get-membership-card-by-user-id?user_id=$userId');
      
      print('API CALL: Getting membership card for user $userId');
      print('URL: $url');
      print('Headers: $headers');
      
      final response = await http.get(url, headers: headers);
      
      print('RESPONSE: Status ${response.statusCode} for user $userId');
      print('RESPONSE: Body ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        
        print('PARSED JSON: $jsonData');
        
        if (jsonData['data'] != null) {
          print('SUCCESS: Found data field for user $userId');
          return jsonData['data'];
        } else {
          print('WARNING: No data field in response for user $userId');
          print('Response structure: ${jsonData.keys.toList()}');
          // Sometimes the data might be directly in the response
          if (jsonData.containsKey('package_id') || jsonData.containsKey('user_id')) {
            print('INFO: Using root level data for user $userId');
            return jsonData;
          }
          return null;
        }
      } else {
        print('ERROR: HTTP ${response.statusCode} for user $userId');
        print('ERROR BODY: ${response.body}');
        return null;
      }
    } catch (e) {
      print('EXCEPTION getting membership card for user $userId: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getPackageById(int packageId) async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/packages/get-package-by-id?package_id=$packageId');
      
      print('API CALL: Getting package details for package $packageId');
      print('URL: $url');
      print('Headers: $headers');
      
      final response = await http.get(url, headers: headers);
      
      print('RESPONSE: Status ${response.statusCode} for package $packageId');
      print('RESPONSE: Body ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        
        print('PARSED JSON: $jsonData');
        
        if (jsonData['data'] != null) {
          print('SUCCESS: Found data field for package $packageId');
          return jsonData['data'];
        } else {
          print('WARNING: No data field in response for package $packageId');
          print('Response structure: ${jsonData.keys.toList()}');
          // Sometimes the data might be directly in the response
          if (jsonData.containsKey('package_name') || jsonData.containsKey('package_id')) {
            print('INFO: Using root level data for package $packageId');
            return jsonData;
          }
          return null;
        }
      } else {
        print('ERROR: HTTP ${response.statusCode} for package $packageId');
        print('ERROR BODY: ${response.body}');
        return null;
      }
    } catch (e) {
      print('EXCEPTION getting package $packageId: $e');
      return null;
    }
  }
}