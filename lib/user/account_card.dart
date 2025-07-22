import 'package:flutter/material.dart';
import '../api_service/auth_service.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AccountCard extends StatefulWidget {
  const AccountCard({super.key});

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  bool _isLoading = true;
  String _name = 'N/A';
  String _phone = 'N/A';
  String _exp = 'N/A';
  String _pt = '';
  bool _hasPackage = false;
  String _packageName = 'No package available';
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      // Get user profile from /user/me
      final profileJson = await AuthService.getUserProfile();
      
      if (profileJson != null) {
        final profileData = jsonDecode(profileJson);
        
        setState(() {
          // Extract user data
          if (profileData is Map && profileData.containsKey('data')) {
            final userData = profileData['data'];
            
            // Get full name
            _name = userData['full_name']?.toString() ?? 'N/A';
            
            // Get phone number
            _phone = userData['phone_number']?.toString() ?? 'N/A';
            
            // Get user ID using the centralized function
            _userId = userData['user_id']?.toString() ?? userData['id']?.toString();
            
            print('User data loaded: name=$_name, phone=$_phone, userId=$_userId');
            
            // Step 2: Get membership data if userId is available
            if (_userId != null) {
              _loadMembershipInfo(_userId!);
            }
          }
          
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user info: $e');
      setState(() {
        _isLoading = false;
        _name = 'N/A';
        _phone = 'N/A';
        _exp = 'N/A';
        _pt = '0';
        _hasPackage = false;
        _packageName = 'No package available';
      });
    }
  }

  Future<void> _loadMembershipInfo(String userId) async {
    try {
      final headers = await AuthService.getHeaders();
      const String baseUrl = 'https://splendid-wallaby-ethical.ngrok-free.app';
      final url = Uri.parse('$baseUrl/memberships/get-membership-card-by-user-id/$userId');
      
      print('Getting membership info from: $url');
      
      final response = await http.get(url, headers: headers);
      
      print('Membership response status: ${response.statusCode}');
      print('Membership response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final membershipData = jsonDecode(response.body);
        
        if (membershipData is Map && membershipData.containsKey('data')) {
          final data = membershipData['data'];
          
          // Get expiration date
          final endDate = data['end_date'];
          if (endDate != null && endDate.toString().isNotEmpty) {
            try {
              final date = DateTime.parse(endDate.toString());
              _exp = DateFormat('dd/MM/yyyy').format(date);
            } catch (e) {
              _exp = 'N/A';
            }
          } else {
            _exp = 'N/A';
          }
          
          // Get package ID and fetch package details
          final packageId = data['package_id'];
          if (packageId != null) {
            await _loadPackageInfo(packageId.toString());
          } else {
            _hasPackage = false;
            _packageName = 'No package available';
          }
        }
      } else {
        // No membership found
        _hasPackage = false;
        _packageName = 'No package available';
        _exp = 'N/A';
      }
    } catch (e) {
      print('Error loading membership info: $e');
      _hasPackage = false;
      _packageName = 'No package available';
      _exp = 'N/A';
    }
  }

  Future<void> _loadPackageInfo(String packageId) async {
    try {
      final headers = await AuthService.getHeaders();
      const String baseUrl = 'https://splendid-wallaby-ethical.ngrok-free.app';
      final url = Uri.parse('$baseUrl/packages/get-package-by-id/$packageId');
      
      print('Getting package info from: $url');
      
      final response = await http.get(url, headers: headers);
      
      print('Package response status: ${response.statusCode}');
      print('Package response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final packageData = jsonDecode(response.body);
        
        if (packageData is Map && packageData.containsKey('data')) {
          final data = packageData['data'];
          
          // Get package name
          _packageName = data['package_name']?.toString() ?? 'No package available';
          _hasPackage = _packageName != 'No package available' && _packageName.isNotEmpty;
          
          print('Package loaded: $_packageName, hasPackage: $_hasPackage');
        }
      } else {
        _hasPackage = false;
        _packageName = 'No package available';
      }
    } catch (e) {
      print('Error loading package info: $e');
      _hasPackage = false;
      _packageName = 'No package available';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFB3CF), Color(0xFFF7A6C1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB3CF), Color(0xFFF7A6C1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Package status
          if (_hasPackage && _packageName != 'No package available')
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      _packageName,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          
          // No package available
          if (!_hasPackage || _packageName == 'No package available')
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.error_outline, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'No package available',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

          // Name & Phone - Bottom left corner
          Positioned(
            bottom: 16,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _phone,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          // EXP & PT - Centered together, on the right
          Positioned(
            bottom: 16,
            right: 20,
            child: Column(
              children: [
                Text(
                  'EXP: $_exp',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
