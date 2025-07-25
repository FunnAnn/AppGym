import 'dart:convert';
import 'dart:io'; 
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'https://splendid-wallaby-ethical.ngrok-free.app';
  static const String _tokenKey = 'auth_token';
  static const String _userRoleKey = 'user_role';
  static const String _userIdKey = 'user_id';
  
  // This should store the current user's information
  static Map<String, dynamic>? _currentUser;
  static String? _token;
  
  // Getters
  static Map<String, dynamic>? get currentUser => _currentUser;
  static String? get token => _token;
  static int? get currentUserId => _currentUser?['id'];
  static String? get currentUserRole => _currentUser?['role'];
  
  // Role checks
  static bool get isAdmin => currentUserRole == 'ADMIN';
  static bool get isOwner => currentUserRole == 'OWNER';
  static bool get isCoach => currentUserRole == 'COACH';
  static bool get isUser => currentUserRole == 'USER' || currentUserRole == 'CUSTOMER';
  
  // Permission checks
  static bool get canManageAllSchedules => isAdmin || isOwner;
  static bool get canViewOthersSchedules => isCoach || isUser;
  
  // Set user data after login
  static void setCurrentUser(Map<String, dynamic> user, {String? authToken}) {
    _currentUser = user;
    _token = authToken;
    print('AuthService: User set - Role: ${currentUserRole}, ID: ${currentUserId}');
  }
  
  // Save token to SharedPreferences
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    print('Token saved to SharedPreferences: ${token.substring(0, 20)}...');
  }
  
  // Get token from SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    print('Token retrieved from SharedPreferences: ${token != null ? '${token.substring(0, 20)}...' : 'null'}');
    return token;
  }
  
  // Public method to get token (this was missing)
  static Future<String?> getToken() async {
    return await _getToken();
  }
  
  // Create headers with token (private method)
  static Future<Map<String, String>> _getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
      'ngrok-skip-browser-warning': 'any',
      'User-Agent': 'FlutterApp/1.0',
    };
    
    final token = await _getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
  
  // Save user role
  static Future<void> _saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRoleKey, role);
    print('User role saved: $role');
  }
  
  // Make sure this method exists and works correctly
  static Future<String?> getUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString('user_role');
      print('Retrieved user role from storage: $role');
      return role;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }
  
  // Save user ID
  static Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    print('User ID saved: $userId');
  }
  
  // Get user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }
  
  // Check if user is customer
  static Future<bool> isCustomer() async {
    final role = await getUserRole();
    return role == 'CUSTOMER';
  }

  // Check if user has admin or owner permission
  static Future<bool> hasAdminPermission() async {
    final role = await getUserRole();
    return role == 'ADMIN' || role == 'OWNER';
  }

  // Check if user has manager permission (admin, owner, coach)
  static Future<bool> hasManagerPermission() async {
    final role = await getUserRole();
    return role == 'ADMIN' || role == 'OWNER' || role == 'COACH';
  }

  // Check if user has system access (all roles)
  static Future<bool> hasSystemAccess() async {
    final role = await getUserRole();
    return role == 'ADMIN' || role == 'OWNER' || role == 'COACH' || role == 'CUSTOMER';
  }
  
  // Clear token from SharedPreferences
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_userIdKey);
    print('All auth data cleared');
  }
  
  // Create headers with token (public method)
  static Future<Map<String, String>> getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
      'ngrok-skip-browser-warning': 'any',
      'User-Agent': 'FlutterApp/1.0',
    };
    
    final token = await _getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  // Register a regular user
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String dateOfBirth,
    required String phoneNumber,
    required bool gender,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/register');
      
      final body = jsonEncode({
        'full_name': fullName,
        'email': email,
        'password': password,
        'date_of_birth': dateOfBirth,
        'phone_number': phoneNumber,
        'gender': gender,
      });

      print('Registration request body: $body');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: body,
      );
      
      print('Registration response status: ${response.statusCode}');
      print('Registration response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data; // Return the parsed Map instead of calling jsonDecode again
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Registration failed');
      }
    } catch (e) {
      print('Registration error: $e');
      throw Exception('Registration failed: $e');
    }
  }

  // Login a regular user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/login');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'any',
          'User-Agent': 'FlutterApp/1.0',
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode != 200) {
        try {
          final data = jsonDecode(response.body);
          throw Exception(data['message'] ?? 'Đăng nhập thất bại');
        } catch (e) {
          throw Exception('Đăng nhập thất bại. Status: ${response.statusCode}. Error: $e');
        }
      }

      final data = jsonDecode(response.body);
      final responseData = data['data'];
      
      // Save token
      String? tokenToSave;
      if (responseData['token'] != null) {
        tokenToSave = responseData['token'];
      } else if (responseData['accessToken'] != null) {
        tokenToSave = responseData['accessToken'];
      }
      
      if (tokenToSave != null) {
        await _saveToken(tokenToSave);
        print('Token saved successfully: ${tokenToSave.substring(0, 20)}...');
      }
      
      // FIX: Save user ID from JWT token or decode from token
      String? userId;
      if (responseData['user_id'] != null) {
        userId = responseData['user_id'].toString();
      } else if (responseData['id'] != null) {
        userId = responseData['id'].toString();
      } else if (tokenToSave != null) {
        // Decode JWT token to get user_id
        userId = _extractUserIdFromToken(tokenToSave);
      }
      
      if (userId != null) {
        await _saveUserId(userId);
        print('User ID saved: $userId');
      }
      
      // Save role
      final userRole = responseData['role']?.toString() ?? 'CUSTOMER';
      await _saveUserRole(userRole);
      
      return responseData;
    } catch (e) {
      print('Error in login: $e');
      rethrow;
    }
  }

  // Admin login
  static Future<Map<String, dynamic>> adminLogin({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/admin/login');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'any',
          'User-Agent': 'FlutterApp/1.0',
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      print('Admin login response status: ${response.statusCode}');
      print('Admin login response body: ${response.body}');

      if (response.body.isEmpty) {
        throw Exception('Server trả về response rỗng');
      }

      if (response.body.trim().startsWith('<')) {
        throw Exception('Server trả về HTML thay vì JSON. Có thể do ngrok warning page.');
      }

      if (response.statusCode != 200) {
        try {
          final data = jsonDecode(response.body);
          throw Exception(data['message'] ?? 'Đăng nhập admin thất bại');
        } catch (e) {
          throw Exception('Đăng nhập admin thất bại. Status: ${response.statusCode}. Error: $e');
        }
      }

      final data = jsonDecode(response.body);
      final responseData = data['data'] ?? data;
      
      // Check admin role
      final userRole = responseData['role']?.toString() ?? '';
      if (userRole != 'ADMIN') {
        throw Exception('Bạn không có quyền truy cập admin');
      }
      
      // Save token
      String? tokenToSave;
      if (responseData['token'] != null) {
        tokenToSave = responseData['token'];
      } else if (responseData['accessToken'] != null) {
        tokenToSave = responseData['accessToken'];
      } else if (data['token'] != null) {
        tokenToSave = data['token'];
      } else if (data['accessToken'] != null) {
        tokenToSave = data['accessToken'];
      }
      
      if (tokenToSave != null) {
        await _saveToken(tokenToSave);
        print('Admin token saved successfully: ${tokenToSave.substring(0, 20)}...');
      }
      
      // Save user ID and role
      final userId = responseData['user_id']?.toString() ?? responseData['id']?.toString() ?? '';
      
      await _saveUserId(userId);
      await _saveUserRole('ADMIN');
      
      return responseData;
    } catch (e) {
      print('Error in admin login: $e');
      rethrow;
    }
  }

  // Coach login
  static Future<Map<String, dynamic>> coachLogin({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/coach/login');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'any',
          'User-Agent': 'FlutterApp/1.0',
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      print('Coach login response status: ${response.statusCode}');
      print('Coach login response body: ${response.body}');

      if (response.body.isEmpty) {
        throw Exception('Server trả về response rỗng');
      }

      if (response.body.trim().startsWith('<')) {
        throw Exception('Server trả về HTML thay vì JSON. Có thể do ngrok warning page.');
      }

      if (response.statusCode != 200) {
        try {
          final data = jsonDecode(response.body);
          throw Exception(data['message'] ?? 'Đăng nhập coach thất bại');
        } catch (e) {
          throw Exception('Đăng nhập coach thất bại. Status: ${response.statusCode}. Error: $e');
        }
      }

      final data = jsonDecode(response.body);
      final responseData = data['data'] ?? data;
      
      // Check coach role
      final userRole = responseData['role']?.toString() ?? '';
      if (userRole != 'COACH') {
        throw Exception('Bạn không có quyền truy cập coach');
      }
      
      // Save token
      String? tokenToSave;
      if (responseData['token'] != null) {
        tokenToSave = responseData['token'];
      } else if (responseData['accessToken'] != null) {
        tokenToSave = responseData['accessToken'];
      } else if (data['token'] != null) {
        tokenToSave = data['token'];
      } else if (data['accessToken'] != null) {
        tokenToSave = data['accessToken'];
      }
      
      if (tokenToSave != null) {
        await _saveToken(tokenToSave);
        print('Coach token saved successfully: ${tokenToSave.substring(0, 20)}...');
      }
      
      // Save user ID and role
      final userId = responseData['user_id']?.toString() ?? responseData['id']?.toString() ?? '';
      
      await _saveUserId(userId);
      await _saveUserRole('COACH');
      
      return responseData;
    } catch (e) {
      print('Error in coach login: $e');
      rethrow;
    }
  }

  // Owner login
  static Future<Map<String, dynamic>> ownerLogin({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/owner/login');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'any',
          'User-Agent': 'FlutterApp/1.0',
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      print('Owner login response status: ${response.statusCode}');
      print('Owner login response body: ${response.body}');

      if (response.body.isEmpty) {
        throw Exception('Server trả về response rỗng');
      }

      if (response.body.trim().startsWith('<')) {
        throw Exception('Server trả về HTML thay vì JSON. Có thể do ngrok warning page.');
      }

      if (response.statusCode != 200) {
        try {
          final data = jsonDecode(response.body);
          throw Exception(data['message'] ?? 'Đăng nhập owner thất bại');
        } catch (e) {
          throw Exception('Đăng nhập owner thất bại. Status: ${response.statusCode}. Error: $e');
        }
      }

      final data = jsonDecode(response.body);
      final responseData = data['data'] ?? data;
      
      // Check owner role
      final userRole = responseData['role']?.toString() ?? '';
      if (userRole != 'OWNER') {
        throw Exception('Bạn không có quyền truy cập owner');
      }
      
      // Save token
      String? tokenToSave;
      if (responseData['token'] != null) {
        tokenToSave = responseData['token'];
      } else if (responseData['accessToken'] != null) {
        tokenToSave = responseData['accessToken'];
      } else if (data['token'] != null) {
        tokenToSave = data['token'];
      } else if (data['accessToken'] != null) {
        tokenToSave = data['accessToken'];
      }
      
      if (tokenToSave != null) {
        await _saveToken(tokenToSave);
        print('Owner token saved successfully: ${tokenToSave.substring(0, 20)}...');
      }
      
      // Save user ID and role
      final userId = responseData['user_id']?.toString() ?? responseData['id']?.toString() ?? '';
      
      await _saveUserId(userId);
      await _saveUserRole('OWNER');
      
      return responseData;
    } catch (e) {
      print('Error in owner login: $e');
      rethrow;
    }
  }

  // Logout
  static Future<void> logout() async {
    await clearToken();
    _currentUser = null;
    _token = null;
    print('Logged out: local token and user info cleared.');
  }

  // Create guest user
  static Future<Map<String, dynamic>> createGuestUser() async {
    try {
      // Generate a simple guest ID based on timestamp
      final guestId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
      
      // Create a mock response similar to what a real API might return
      final guestData = {
        'user_id': guestId,
        'id': guestId,
        'email': 'guest@example.com',
        'full_name': 'Guest User',
        'is_guest': true,
        'role': 'GUEST',
      };
      
      // Save guest info
      await _saveUserId(guestId);
      await _saveUserRole('GUEST');
      
      print('Guest user created: $guestData');
      return guestData;
    } catch (e) {
      print('Error creating guest user: $e');
      
      // Fallback: return mock data even if API fails
      final fallbackId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
      final fallbackData = {
        'user_id': fallbackId,
        'id': fallbackId,
        'email': 'guest@example.com',
        'full_name': 'Guest User',
        'is_guest': true,
        'role': 'GUEST',
      };
      
      await _saveUserId(fallbackId);
      await _saveUserRole('GUEST');
      
      return fallbackData;
    }
  }

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  // Validate token by making a test API call
  static Future<bool> validateToken() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        print('No token available for validation');
        return false;
      }

      // Try to make a simple API call to validate token
      final url = Uri.parse('$_baseUrl/user/profile');
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);
      
      print('Token validation response: ${response.statusCode}');
      
      if (response.statusCode == 401 || response.statusCode == 403) {
        await clearToken();
        return false;
      }
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error validating token: $e');
      return false;
    }
  }

  // Check if user is authenticated (has valid token)
  static Future<bool> ensureAuthenticated() async {
    final token = await _getToken();
    if (token == null) return false;
    
    return await validateToken();
  }

  // Get user profile
  static Future<String?> getUserProfile() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print('No token available');
        return null;
      }

      final url = Uri.parse('$_baseUrl/user/me'); 
      final headers = await _getHeaders();
      print('GET_PROFILE: Requesting profile from $url with headers: $headers');
      final response = await http.get(url, headers: headers);
      
      print('GET_PROFILE: Response status: ${response.statusCode}');
      print('GET_PROFILE: Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Return the raw JSON string instead of parsed data
        return response.body;
      }
      
      // Add error handling for 401/403 for expired/invalid tokens
      else if (response.statusCode == 401 || response.statusCode == 403) {
        print('GET_PROFILE: Token invalid/expired. Clearing token.');
        await clearToken();
      }
      
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Update user gender
  static Future<void> updateGender({
    required String userId,
    required int gender,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      final url = Uri.parse('$_baseUrl/user/update-user/$userId');
      final headers = await _getHeaders();
      
      final body = jsonEncode({
        'gender': gender,
        'user_id': userId, // This might be redundant if userId is in the URL path
      });
      
      print('Updating gender at: $url');
      print('Request body: $body');
      
      final response = await http.put(url, headers: headers, body: body);
      
      print('Gender update response: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Gender updated successfully');
        return;
      }
      
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['message'] ?? 'Không thể cập nhật giới tính');
    } catch (e) {
      if (e.toString().contains('No token')) {
        await clearToken();
      }
      print('Error in updateGender: $e');
      rethrow;
    }
  }

  // Update gender with simpler approach
  static Future<void> updateGenderSimple({
    required String userId,
    required int gender,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      final url = Uri.parse('$_baseUrl/user/update-user/$userId');
      final headers = await _getHeaders();
      
      final body = jsonEncode({'gender': gender});
      
      print('Simple gender update to: $url');
      print('Headers: $headers');
      print('Body: $body');
      
      final response = await http.put(url, headers: headers, body: body);
      
      print('Simple gender update response: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Gender updated successfully');
        return;
      }
      
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['message'] ?? 'Không thể cập nhật giới tính');
    } catch (e) {
      if (e.toString().contains('No token')) {
        await clearToken();
      }
      print('Error in updateGenderSimple: $e');
      rethrow;
    }
  }

  // Check admin access (updated to include owner)
  static Future<bool> checkAdminPermission() async {
    try {
      final hasPermission = await hasAdminPermission();
      final isAuth = await isAuthenticated();
      
      return hasPermission && isAuth;
    } catch (e) {
      print('Error checking admin permission: $e');
      return false;
    }
  }

  // Check manager access (admin, owner, coach)
  static Future<bool> checkManagerPermission() async {
    try {
      final hasPermission = await hasManagerPermission();
      final isAuth = await isAuthenticated();
      
      return hasPermission && isAuth;
    } catch (e) {
      print('Error checking manager permission: $e');
      return false;
    }
  }

  // Get current user info (updated to include all 4 roles)
  static Future<Map<String, dynamic>?> getCurrentUserInfo() async {
    try {
      final userId = await getUserId();
      final userRole = await getUserRole();
      final token = await _getToken();
      
      if (userId == null || userRole == null || token == null) {
        return null;
      }
      
      return {
        'user_id': userId,
        'role': userRole,
        'is_admin': userRole == 'ADMIN',
        'is_owner': userRole == 'OWNER',
        'is_coach': userRole == 'COACH',
        'is_customer': userRole == 'CUSTOMER',
        'has_admin_permission': userRole == 'ADMIN' || userRole == 'OWNER',
        'has_manager_permission': userRole == 'ADMIN' || userRole == 'OWNER' || userRole == 'COACH',
        'has_system_access': userRole == 'ADMIN' || userRole == 'OWNER' || userRole == 'COACH' || userRole == 'CUSTOMER',
        'has_token': token.isNotEmpty,
      };
    } catch (e) {
      print('Error getting current user info: $e');
      return null;
    }
  }

  // Debug authentication status (updated to include all 4 roles)
  static Future<void> debugAuthStatus() async {
    try {
      final token = await _getToken();
      final userId = await getUserId();
      final userRole = await getUserRole();
      
      print('=== AUTH DEBUG ===');
      print('Token exists: ${token != null}');
      print('User ID: $userId');
      print('User Role: $userRole');
      print('Is Admin: ${userRole == 'ADMIN'}');
      print('Is Owner: ${userRole == 'OWNER'}');
      print('Is Coach: ${userRole == 'COACH'}');
      print('Is Customer: ${userRole == 'CUSTOMER'}');
      print('Has Admin Permission: ${userRole == 'ADMIN' || userRole == 'OWNER'}');
      print('Has Manager Permission: ${userRole == 'ADMIN' || userRole == 'OWNER' || userRole == 'COACH'}');
      print('Has System Access: ${userRole == 'ADMIN' || userRole == 'OWNER' || userRole == 'COACH' || userRole == 'CUSTOMER'}');
      
      if (token != null) {
        print('Token preview: ${token.length > 20 ? token.substring(0, 20) + '...' : token}');
        
        // Try to validate token
        final isValid = await validateToken();
        print('Token is valid: $isValid');
        
        // Try to get user profile
        final profile = await getUserProfile();
        print('Can get profile: ${profile != null}');
        if (profile != null) {
          print('Profile preview: ${profile.toString().length > 100 ? profile.toString().substring(0, 100) + '...' : profile}');
        }
      }
      print('==================');
    } catch (e) {
      print('Error in debugAuthStatus: $e');
    }
  }

  // Get current user token (for debugging)
  static Future<String?> getCurrentToken() async {
    return await _getToken();
  }

  // Add method to decode JWT token
  static String? _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      final payload = parts[1];
      final decoded = utf8.decode(base64Url.decode(base64Url.normalize(payload)));
      final data = jsonDecode(decoded);
      
      return data['user_id']?.toString();
    } catch (e) {
      print('Error extracting user ID from token: $e');
      return null;
    }
  }

  // Get user ID with fallback from profile
  static Future<String?> getUserIdWithFallback() async {
    try {
      // Try to get from SharedPreferences first
      String? userId = await getUserId();
      
      if (userId != null && userId.isNotEmpty) {
        return userId;
      }
      
      // If not available, get from profile
      final userProfileJson = await getUserProfile();
      if (userProfileJson != null) {
        final userProfile = jsonDecode(userProfileJson);
        if (userProfile is Map && userProfile['data'] != null) {
          final data = userProfile['data'];
          userId = data['user_id']?.toString();
          
          if (userId != null) {
            // Save for next time, no need to call API
            await _saveUserId(userId);
            print('User ID saved from profile: $userId');
            return userId;
          }
        }
      }
      
      return null;
    } catch (e) {
      print('Error getting user ID with fallback: $e');
      return null;
    }
  }

  // Get current user ID from profile
  static Future<int?> getCurrentUserId() async {
    try {
      // Check if we have a token first
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        print('[AuthService] getCurrentUserId - No token available');
        return null;
      }
      
      print('[AuthService] getCurrentUserId - Token exists, fetching profile');
      final profileJson = await getUserProfile();
      print('[AuthService] getCurrentUserId - profileJson: $profileJson');
      
      if (profileJson != null) {
        final profileData = jsonDecode(profileJson);
        print('[AuthService] getCurrentUserId - parsed profileData: $profileData');
        
        if (profileData is Map) {
          // Check if data is directly in the response
          Map<String, dynamic>? userData;
          
          if (profileData.containsKey('data')) {
            userData = profileData['data'] as Map<String, dynamic>?;
          } else {
            // Sometimes the user data is directly in the response
            userData = profileData as Map<String, dynamic>;
          }
          
          print('[AuthService] getCurrentUserId - userData: $userData');
          
          if (userData != null) {
            // Try different possible field names for user ID
            dynamic userIdValue = userData['user_id'] ?? 
                                 userData['id'] ?? 
                                 userData['userId'];
            
            print('[AuthService] getCurrentUserId - userIdValue: $userIdValue (type: ${userIdValue.runtimeType})');
            
            if (userIdValue != null) {
              final userId = int.tryParse(userIdValue.toString());
              print('[AuthService] getCurrentUserId final result: $userId');
              
              // Save the userId for future use to avoid repeated API calls
              if (userId != null) {
                await _saveUserId(userId.toString());
              }
              
              return userId;
            }
          }
        }
      }
      
      print('[AuthService] getCurrentUserId - No user ID found in profile');
      return null;
    } catch (e) {
      print('[AuthService] Error getting current user ID: $e');
      return null;
    }
  }
}