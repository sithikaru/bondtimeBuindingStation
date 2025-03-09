import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:8000";

  static Future<Map<String, dynamic>> getActivities(String userId) async {
    final url = Uri.parse("$baseUrl/get-activities");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Failed to fetch activities: ${response.statusCode} - ${response.body}",
      );
    }
  }

  static Future<String> submitFeedback(
    String userId,
    String activityId,
    int rating,
    String comment,
  ) async {
    final url = Uri.parse("$baseUrl/submit-feedback");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "activityId": activityId,
        "rating": rating,
        "comment": comment,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["message"];
    } else {
      throw Exception(
        "Failed to submit feedback: ${response.statusCode} - ${response.body}",
      );
    }
  }
}
