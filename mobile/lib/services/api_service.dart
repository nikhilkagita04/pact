import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api/v1';
  
  // Get auth headers with Firebase token
  static Future<Map<String, String>> _getAuthHeaders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated. Please sign in.');
    }
    
    final token = await user.getIdToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Get all contacts
  static Future<List<Map<String, dynamic>>> getContacts({
    String? search,
    String? relationship,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      String url = '$baseUrl/contacts';
      
      // Add query parameters
      List<String> queryParams = [];
      if (search != null && search.isNotEmpty) {
        queryParams.add('search=${Uri.encodeComponent(search)}');
      }
      if (relationship != null && relationship.isNotEmpty) {
        queryParams.add('relationship=${Uri.encodeComponent(relationship)}');
      }
      
      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load contacts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting contacts: $e');
      // No fallback - throw error if API fails
      throw Exception('Failed to load contacts from API');
    }
  }

  // Get contact by ID
  static Future<Map<String, dynamic>?> getContactById(String contactId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/contacts/$contactId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load contact: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting contact: $e');
      // No fallback - throw error if API fails
      throw Exception('Failed to load contact from API');
    }
  }

  // Create a pact
  static Future<Map<String, dynamic>> createPact({
    required String title,
    required String description,
    required String recipientId,
    required String recipientName,
    required String recipientPhone,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/pacts'),
        headers: headers,
        body: json.encode({
          'title': title,
          'description': description,
          'recipient_id': recipientId,
          'recipient_name': recipientName,
          'recipient_phone': recipientPhone,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create pact: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating pact: $e');
      throw Exception('Failed to create pact: $e');
    }
  }

  // Get user's pacts
  static Future<List<Map<String, dynamic>>> getUserPacts(String type) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/pacts?type=$type'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load pacts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting pacts: $e');
      // No fallback - throw error if API fails
      throw Exception('Failed to load pacts from API');
    }
  }

  // Accept a pact
  static Future<void> acceptPact(String pactId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/pacts/$pactId/accept'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to accept pact: ${response.statusCode}');
      }
    } catch (e) {
      print('Error accepting pact: $e');
      throw Exception('Failed to accept pact: $e');
    }
  }

  // Complete a pact
  static Future<void> completePact(String pactId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/pacts/$pactId/complete'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to complete pact: ${response.statusCode}');
      }
    } catch (e) {
      print('Error completing pact: $e');
      throw Exception('Failed to complete pact: $e');
    }
  }

  // Decline a pact
  static Future<void> declinePact(String pactId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/pacts/$pactId/decline'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to decline pact: ${response.statusCode}');
      }
    } catch (e) {
      print('Error declining pact: $e');
      throw Exception('Failed to decline pact: $e');
    }
  }

}
