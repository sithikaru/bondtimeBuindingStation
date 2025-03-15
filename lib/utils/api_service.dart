import 'dart:convert';
import 'dart:io';
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
}
