import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

class ApiService {
  // The Hugging Face direct API endpoint
  static String get baseUrl => 'https://muhammadahsanmask-disease-predictor-api.hf.space';

  static Future<List<String>> getSymptoms() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/symptoms'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['symptoms']);
      } else {
        throw Exception('Failed to load symptoms');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> predictDisease(List<String> selectedSymptoms) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'symptoms': selectedSymptoms}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get prediction');
      }
    } catch (e) {
      throw Exception('Network error: \$e');
    }
  }
}
