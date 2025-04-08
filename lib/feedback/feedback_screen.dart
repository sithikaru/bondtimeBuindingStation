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
    // This ensures we use local date or use a library like intl if you prefer
    final dateKey = DateTime.now().toIso8601String().split('T').first;

    final dateDocRef = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("activities")
        .doc(dateKey);

    // Create the date doc with a top-level field so it's visible in the console
    await dateDocRef.set({'created': true}, SetOptions(merge: true));

    // Now add a doc in "completedActivities"
    final completedRef = dateDocRef
        .collection("completedActivities")
        .doc(activityId);

    await completedRef.set({
      "completed": true,
      "completedAt": DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));

    print("Saved completion for $activityId on $dateKey for user $userId");
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
