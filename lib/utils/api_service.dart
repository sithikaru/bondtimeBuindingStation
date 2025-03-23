import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ApiService {
  // Use 10.0.2.2 for Android emulator to reach the host machine
  static const String baseUrl = "http://10.0.2.2:8000"; // Updated for emulator

  // Fetch activities based on the user's ID and today's date
  static Future<Map<String, dynamic>> getActivities(String userId) async {
    final url = Uri.parse("$baseUrl/get-activities");
    print("Sending request to: $url with userId: $userId"); // Debug log
    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"userId": userId}),
          )
          .timeout(const Duration(seconds: 10)); // Add timeout
      print("Response status: ${response.statusCode}"); // Debug log
      print("Response body: ${response.body}"); // Debug log
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          "Failed to fetch activities: ${response.statusCode} - ${response.body}",
        );
      }
    } on TimeoutException catch (e) {
      print("Request timed out: $e");
      throw Exception("Request timed out. Check server connection.");
    } on SocketException catch (e) {
      print("Socket error: $e");
      throw Exception("Network error. Check your connection.");
    } catch (e) {
      print("Unexpected error: $e");
      throw Exception("Failed to fetch activities: $e");
    }
  }

  static Future<Map<String, String>> getHeaders() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final token = await user.getIdToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> getHealthAlerts(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/health-alerts?userId=$userId'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch health alerts');
    }
  }

  static Future<String> sendChatMessage(String userId, String message) async {
    final url = Uri.parse("$baseUrl/chat");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userId, "message": message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? "Sorry, I didn't get that.";
      } else {
        print("⚠️ Chat API failed: ${response.body}");
        throw Exception("Failed to get AI response");
      }
    } catch (e) {
      print("❌ Chat error: $e");
      rethrow;
    }
  }

  // Submit user feedback to the server
  static Future<String> submitFeedback(
    String userId,
    String activityId,
    int rating,
    String comment,
  ) async {
    final url = Uri.parse("$baseUrl/submit-feedback");
    print(
      "Sending feedback request to: $url with data: {userId: $userId, activityId: $activityId, rating: $rating, comment: $comment}",
    );
    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "userId": userId,
              "activityId": activityId,
              "rating": rating,
              "comment": comment,
            }),
          )
          .timeout(const Duration(seconds: 10));
      print("Feedback response status: ${response.statusCode}");
      print("Feedback response body: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["message"];
      } else {
        throw Exception(
          "Failed to submit feedback: ${response.statusCode} - ${response.body}",
        );
      }
    } on TimeoutException catch (e) {
      print("Feedback request timed out: $e");
      throw Exception("Feedback request timed out. Check server connection.");
    } on SocketException catch (e) {
      print("Socket error: $e");
      throw Exception("Network error. Check your connection.");
    } catch (e) {
      print("Unexpected feedback error: $e");
      throw Exception("Failed to submit feedback: $e");
    }
  }

  static Future<List<String>> getDailyTips(String role) async {
    final url = Uri.parse("$baseUrl/get-daily-tips");
    print("Sending request to: $url with role: $role"); // Debug log
    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"role": role}),
          )
          .timeout(const Duration(seconds: 10));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data["tips"]);
      } else {
        throw Exception(
          "Failed to fetch tips: ${response.statusCode} - ${response.body}",
        );
      }
    } on TimeoutException {
      throw Exception("Request timed out. Check server connection.");
    } on SocketException {
      throw Exception("Network error. Check your connection.");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
