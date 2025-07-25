import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class MembershipService {
  static const String _baseUrl = 'https://splendid-wallaby-ethical.ngrok-free.app';

  // Lấy package by ID
  static Future<Map<String, dynamic>?> getPackageById(int packageId) async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/packages/get-package-by-id/$packageId');
      
      print('Getting package by ID: $packageId');
      print('Package URL: $url');
      
      final response = await http.get(url, headers: headers);
      
      print('Get package response status: ${response.statusCode}');
      print('Get package response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      
      return null;
    } catch (e) {
      print('Error getting package by ID: $e');
      return null;
    }
  }

  // Lấy tất cả packages (fallback method)
  static Future<List<Map<String, dynamic>>> getAllPackages() async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/packages/get-all-packages');
      
      final response = await http.get(url, headers: headers);
      
      print('Get all packages response status: ${response.statusCode}');
      print('Get all packages response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      
      return [];
    } catch (e) {
      print('Error getting all packages: $e');
      return [];
    }
  }

  // Lấy package name by ID với fallback
  static Future<String?> getPackageNameById(int packageId) async {
    try {
      // Thử lấy package riêng lẻ với endpoint đúng
      final packageData = await getPackageById(packageId);
      if (packageData != null) {
        // Kiểm tra các field có thể chứa package name
        return packageData['name'] ?? 
               packageData['package_name'] ?? 
               packageData['title'] ?? 
               packageData['display_name'];
      }
      
      // Fallback: lấy tất cả packages và tìm theo ID
      final allPackages = await getAllPackages();
      for (final package in allPackages) {
        if (package['id'] == packageId || package['package_id'] == packageId) {
          return package['name'] ?? 
                 package['package_name'] ?? 
                 package['title'] ?? 
                 package['display_name'];
        }
      }
      
      return null;
    } catch (e) {
      print('Error getting package name by ID: $e');
      return null;
    }
  }

  // Lấy tất cả membership cards
  static Future<List<Map<String, dynamic>>> getAllMembershipCards() async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/memberships/get-all-membership-cards');
      
      final response = await http.get(url, headers: headers);
      
      print('Get all membership cards response status: ${response.statusCode}');
      print('Get all membership cards response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      
      throw Exception('Failed to load membership cards');
    } catch (e) {
      print('Error getting all membership cards: $e');
      rethrow;
    }
  }

  // Lấy membership card theo ID
  static Future<Map<String, dynamic>?> getMembershipCardById(String membershipCardId) async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/memberships/get-membership-card-by-id/$membershipCardId');
      
      final response = await http.get(url, headers: headers);
      
      print('Get membership card by ID response status: ${response.statusCode}');
      print('Get membership card by ID response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      
      return null;
    } catch (e) {
      print('Error getting membership card by ID: $e');
      return null;
    }
  }

  // Lấy membership card theo user ID
  static Future<Map<String, dynamic>?> getMembershipCardByUserId(String userId) async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/memberships/get-membership-card-by-user-id/$userId');
      
      print('Requesting membership card for user ID: $userId');
      print('Full URL: $url');
      
      final response = await http.get(url, headers: headers);
      
      print('Get membership card by user ID response status: ${response.statusCode}');
      print('Get membership card by user ID response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Parsed membership data: $data');
        return data['data'];
      } else if (response.statusCode == 404) {
        print('No membership card found for user ID: $userId');
        return null;
      } else {
        print('Error response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting membership card by user ID: $e');
      return null;
    }
  }

  // Lấy thông tin user và membership card với package name
  static Future<Map<String, dynamic>> getUserMembershipInfo() async {
    try {
      // Lấy user ID với fallback
      final userId = await AuthService.getUserIdWithFallback();
      print('Getting membership info for user ID: $userId');
      
      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found');
      }

      // Lấy thông tin user profile
      final userProfile = await AuthService.getUserProfile();
      Map<String, dynamic> userData = {};
      
      if (userProfile != null) {
        final profileData = jsonDecode(userProfile);
        userData = profileData['data'] ?? {};
        print('User profile data: $userData');
      }

      // Lấy membership card của user
      final membershipCard = await getMembershipCardByUserId(userId);
      print('Membership card data: $membershipCard');

      if (membershipCard != null) {
        // Lấy package_id từ membership card
        final packageId = membershipCard['package_id'];
        print('Package ID from membership: $packageId');
        
        if (packageId != null) {
          // Lấy package name từ package_id
          final packageName = await getPackageNameById(packageId);
          print('Package name: $packageName');
          
          // Thêm package_name vào membership data
          membershipCard['package_name'] = packageName ?? 'Unknown Package';
        }
      }

      return {
        'user': userData,
        'membership': membershipCard,
        'hasPackage': membershipCard != null && 
                     membershipCard['package_name'] != null && 
                     membershipCard['package_name'].toString().isNotEmpty &&
                     membershipCard['package_name'] != 'Unknown Package',
      };
    } catch (e) {
      print('Error getting user membership info: $e');
      
      // Fallback để tránh crash
      try {
        final userProfile = await AuthService.getUserProfile();
        Map<String, dynamic> userData = {};
        
        if (userProfile != null) {
          final profileData = jsonDecode(userProfile);
          userData = profileData['data'] ?? {};
        }
        
        return {
          'user': userData,
          'membership': null,
          'hasPackage': false,
        };
      } catch (fallbackError) {
        print('Fallback error: $fallbackError');
        rethrow;
      }
    }
  }

  // Debug method để test package API
  static Future<void> testPackageEndpoints() async {
    try {
      print('=== TESTING CORRECT PACKAGE ENDPOINTS ===');
      
      // Test get all packages với endpoint đúng
      final allPackages = await getAllPackages();
      print('All packages count: ${allPackages.length}');
      if (allPackages.isNotEmpty) {
        print('First package: ${allPackages.first}');
      }
      
      // Test get package by ID với endpoint đúng (thử với ID 4 từ membership data)
      final packageData = await getPackageById(4);
      print('Package ID 4 data: $packageData');
      
      // Test get package name by ID
      final packageName = await getPackageNameById(4);
      print('Package ID 4 name: $packageName');
      
      print('=== END PACKAGE TEST ===');
    } catch (e) {
      print('Error testing package endpoints: $e');
    }
  }

  // Debug method để kiểm tra user ID
  static Future<void> debugUserInfo() async {
    try {
      final userId = await AuthService.getUserId();
      final userIdFallback = await AuthService.getUserIdWithFallback();
      final userRole = await AuthService.getUserRole();
      final token = await AuthService.getCurrentToken();
      
      print('=== MEMBERSHIP DEBUG ===');
      print('User ID (storage): $userId');
      print('User ID (fallback): $userIdFallback');
      print('User Role: $userRole');
      print('Token exists: ${token != null}');
      print('Token preview: ${token?.substring(0, 20) ?? 'null'}...');
      
      if (userIdFallback != null) {
        final url = Uri.parse('$_baseUrl/memberships/get-membership-card-by-user-id/$userIdFallback');
        print('Will call URL: $url');
        
        final headers = await AuthService.getHeaders();
        print('Headers: $headers');
      }
      print('========================');
    } catch (e) {
      print('Debug error: $e');
    }
  }
}