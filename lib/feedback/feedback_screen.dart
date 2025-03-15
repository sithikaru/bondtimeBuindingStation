// ignore_for_file: use_build_context_synchronously

import 'package:bondtime/feedback/thank_you_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/api_service.dart';
import 'feedback_card.dart';

class FeedbackScreen extends StatefulWidget {
  final String activityId;

  const FeedbackScreen({super.key, required this.activityId});

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
      await ApiService.submitFeedback(
        userId,
        widget.activityId,
        rating,
        comment,
      );
    } catch (e) {
      rethrow;
    }
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
          isLast: true, // Single feedback question per activity
        ),
      ),
    );
  }
}
