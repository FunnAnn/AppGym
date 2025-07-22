import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ChatService {
  static const String _baseUrl = 'https://splendid-wallaby-ethical.ngrok-free.app';

  static Future<String> chatWithAI(String message) async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/chat/chat-with-ai');
      
      final body = jsonEncode({
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      });

      print('Sending chat message to AI: $message');
      print('Chat URL: $url');
      
      final response = await http.post(
        url, 
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: body,
      );
      
      print('Chat response status: ${response.statusCode}');
      print('Chat response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? data['message'] ?? data['data'] ?? 'No response from AI';
      } else {
        throw Exception('Failed to get AI response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error chatting with AI: $e');
      throw Exception('Error communicating with AI: $e');
    }
  }

  // Save chat history to backend
  static Future<void> saveChatHistory(List<Map<String, String>> messages) async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/chat/save-history');
      
      final body = jsonEncode({
        'messages': messages,
        'timestamp': DateTime.now().toIso8601String(),
      });

      await http.post(
        url, 
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: body,
      );
    } catch (e) {
      print('Error saving chat history: $e');
      // Don't throw error for save operation
    }
  }

  // Get chat history from backend
  static Future<List<Map<String, String>>> getChatHistory() async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('$_baseUrl/chat/get-history');
      
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data'] is List) {
          return List<Map<String, String>>.from(
            data['data'].map((msg) => Map<String, String>.from(msg))
          );
        }
      }
      
      return [];
    } catch (e) {
      print('Error getting chat history: $e');
      return [];
    }
  }
}
