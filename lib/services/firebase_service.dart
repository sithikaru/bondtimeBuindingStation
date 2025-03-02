import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _functions = FirebaseFunctions.instance;

  // Get current user ID
  String get userId => _auth.currentUser?.uid ?? '';

  // Call activity generation function
  Future<List<Map<String, dynamic>>> generateActivities() async {
    try {
      final result =
          await _functions.httpsCallable('generateActivities').call();
      return List<Map<String, dynamic>>.from(result.data['activities']);
    } catch (e) {
      throw Exception('Failed to generate activities: $e');
    }
  }

  // Submit feedback for an activity
  Future<void> submitActivityFeedback({
    required String activityId,
    required int rating,
    required String comment,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('pastActivities')
        .doc(activityId)
        .set({
          'feedback': {
            'rating': rating,
            'comment': comment,
            'timestamp': FieldValue.serverTimestamp(),
          },
        });
  }

  // Stream for real-time skill updates
  Stream<Map<String, dynamic>> getChildDataStream() {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snap) => snap.data()?['child'] ?? {});
  }
}
