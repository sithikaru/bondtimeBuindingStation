// ignore_for_file: use_build_context_synchronously

import 'package:bondtime/feedback/thank_you_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/api_service.dart';
import 'feedback_card.dart';

class FeedbackScreen extends StatefulWidget {
  final String activityId;
  final int durationSpent;

  const FeedbackScreen({
    super.key,
    required this.activityId,
    required this.durationSpent,
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  Future<void> saveFeedback(int rating, String comment) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }
      String userId = user.uid;

      // Step 1: Submit feedback to backend
      await ApiService.submitFeedback(
        userId,
        widget.activityId,
        rating,
        comment,
      );

      // Step 2: Save completion to Firestore
      await saveActivityCompletion(
        userId: userId,
        activityId: widget.activityId,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveActivityCompletion({
    required String userId,
    required String activityId,
  }) async {
    // Expected activityId format: "<userId>_<scheduledDate>_<activityType>"
    // For example: "c6nEqzciSneNjIY8VonfSOQxAry1_2025-03-29_communication"
    final parts = activityId.split('_');

    // Validate the activityId format:
    if (parts.length < 3) {
      // If the format is unexpected, log and use today's date as a fallback.
      print(
        "[saveActivityCompletion] Unexpected activityId format: $activityId. Using today's date as scheduled date.",
      );
    }

    // Extract the scheduled date and activity type.
    final scheduledDate =
        parts.length >= 3
            ? parts[1]
            : DateTime.now().toIso8601String().split('T')[0];

    // In case the activity type itself contains underscores, join the remaining parts.
    final activityType =
        parts.length >= 3 ? parts.sublist(2).join('_') : activityId;

    // Use today's date as the completion date.
    final completionDate = DateTime.now().toIso8601String().split('T')[0];

    print("[saveActivityCompletion] Scheduled date: $scheduledDate");
    print("[saveActivityCompletion] Completion date: $completionDate");
    print("[saveActivityCompletion] Activity type: $activityType");

    // Get the document in the "activities" collection using the scheduled date.
    final dateDocRef = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("activities")
        .doc(scheduledDate);

    // Create the parent document with a placeholder field, if it doesn't exist.
    await dateDocRef.set({'created': true}, SetOptions(merge: true));

    // Construct the document ID for the completed activity
    final completedActivityDocId = "${userId}_${completionDate}_$activityType";
    print(
      "[saveActivityCompletion] Saving completed activity with doc ID: $completedActivityDocId",
    );

    final completedRef = dateDocRef
        .collection("completedActivities")
        .doc(completedActivityDocId);

    // Save the completion details.
    await completedRef.set({
      "completed": true,
      "completedAt": DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));

    print(
      "[saveActivityCompletion] Saved completion for activityId: $activityId",
    );
    print("[saveActivityCompletion] Path: ${completedRef.path}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BondTime"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: FeedbackCard(
          question: "How did this activity go with your child?",
          onNext: (int rating, String comment) async {
            final BuildContext currentContext = context;
            try {
              await saveFeedback(rating, comment);
              if (mounted) {
                Navigator.push(
                  currentContext,
                  MaterialPageRoute(
                    builder: (context) => const ThankYouScreen(),
                  ),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(currentContext).showSnackBar(
                  SnackBar(content: Text("Failed to submit feedback: $e")),
                );
              }
            }
          },
          isLast: true,
        ),
      ),
    );
  }
}
