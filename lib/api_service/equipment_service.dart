import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_service/auth_service.dart';
import '../model/equipment.dart' as EquipmentModel;

class EquipmentService {
  static const String _baseUrl = 'https://splendid-wallaby-ethical.ngrok-free.app';

  Future<List<EquipmentModel.Data>> getAllEquipments() async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/equipments/get-all-equipments');
      
      print('Getting all equipments from: $url');
      print('Headers: $headers');
      
      final response = await http.get(url, headers: headers);
      
      print('Get all equipments response status: ${response.statusCode}');
      print('Get all equipments response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final equipmentResponse = EquipmentModel.Equipment.fromJson(jsonData);
        
        return equipmentResponse.data ?? [];
      } else {
        throw Exception('Failed to load equipments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting all equipments: $e');
      throw Exception('Error loading equipments: $e');
    }
  }

  Future<bool> deleteEquipment(int equipmentId) async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/equipments/delete-equipment/$equipmentId');
      
      final response = await http.delete(url, headers: headers);
      
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete equipment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting equipment: $e');
      throw Exception('Error deleting equipment: $e');
    }
  }
}
