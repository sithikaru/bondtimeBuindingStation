import 'package:bondtime/Dashboard/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/feedback_card.dart';

class FeedbackScreen extends StatelessWidget {
  final String activityId; // Pass the activity ID

  const FeedbackScreen({super.key, required this.activityId});

  Future<void> saveFeedback(int rating, String comment) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      String userId = user.uid;

      // Reference to Firestore collection
      CollectionReference feedbackCollection = FirebaseFirestore.instance
          .collection('user_feedback');

      // Save feedback
      await feedbackCollection.doc(userId).set({
        'userId': userId,
        'feedback': FieldValue.arrayUnion([
          {
            'activityId': activityId,
            'rating': rating,
            'comment': comment,
            'timestamp': FieldValue.serverTimestamp(),
          },
        ]),
      }, SetOptions(merge: true));

      print("Feedback saved successfully!");
    } catch (e) {
      print("Error saving feedback: $e");
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
          onNext: () async {
            // Capture user rating and comment
            int rating = 4; // Replace with actual rating from UI
            String comment = "Great activity!"; // Replace with user input

            await saveFeedback(rating, comment);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          },
          isLast: false,
        ),
      ),
    );
  }
}
