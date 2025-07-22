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
}