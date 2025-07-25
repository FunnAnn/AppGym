import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_service/auth_service.dart';
import '../model/package.dart' as PackageModel;

class PackageService {
  static const String _baseUrl = 'https://splendid-wallaby-ethical.ngrok-free.app';

  Future<List<PackageModel.Data>> getAllPackages() async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/packages/get-all-packages'); 
      
      print('Getting all packages from: $url');
      print('Headers: $headers');
      
      final response = await http.get(url, headers: headers);
      
      print('Get all packages response status: ${response.statusCode}');
      print('Get all packages response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final packageResponse = PackageModel.Package.fromJson(jsonData);
        
        return packageResponse.data ?? [];
      } else {
        throw Exception('Failed to load packages: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting all packages: $e');
      throw Exception('Error loading packages: $e');
    }
  }

  Future<bool> deletePackage(int packageId) async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/packages/delete-package/$packageId'); // Updated endpoint
      
      final response = await http.delete(url, headers: headers);
      
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete package: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting package: $e');
      throw Exception('Error deleting package: $e');
    }
  }

  static Future<String> getPackageNameByCustomerId(int userId) async {
    try {
      final headers = await AuthService.getHeaders();
      if (headers == null) {
        throw Exception('No authentication headers found');
      }

      // Step 1: Get membership card by user ID
      final membershipResponse = await http.get(
        Uri.parse('$_baseUrl/memberships/get-membership-card-by-user-id/$userId'),
        headers: headers,
      );

      print('Package API Response Status: ${membershipResponse.statusCode}');
      print('Package API Response Body: ${membershipResponse.body}');
      print('Getting package name for user ID: $userId');

      if (membershipResponse.statusCode == 200) {
        final membershipData = json.decode(membershipResponse.body);
        
        // Step 2: Extract package_id from membership data
        final packageId = membershipData['data']?['package_id'];
        
        if (packageId != null) {
          // Step 3: Get package details by package_id
          final packageResponse = await http.get(
            Uri.parse('$_baseUrl/packages/get-package-by-id/$packageId'),
            headers: headers,
          );

          print('Package details API Response Status: ${packageResponse.statusCode}');
          print('Package details API Response Body: ${packageResponse.body}');

          if (packageResponse.statusCode == 200) {
            final packageData = json.decode(packageResponse.body);
            final packageName = packageData['data']?['package_name'];
            
            if (packageName != null) {
              return packageName.toString();
            }
          }
        }
      } else if (membershipResponse.statusCode == 404) {
        // User doesn't have a membership card
        return 'No Package';
      }
      
      return 'N/A';
    } catch (e) {
      print('Error getting package name for user $userId: $e');
      return 'N/A';
    }
  }
}