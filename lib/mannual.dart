import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> manuallySetStreakTo20(String userId) async {
  // Reference to the user's streak document under progress
  final streakRef = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("progress")
      .doc("streak");

  // Get today's date in the expected format
  final today = DateTime.now().toIso8601String().split("T")[0];

  // Manually set the streak to 20 and assign the appropriate unlocked badges.
  await streakRef.set({
    "currentStreak": 20,
    "lastCompletedDate": today,
    "unlockedBadges": ["steady_starter", "growth_hero"],
  }, SetOptions(merge: true));

  print(
    "Successfully set streak to 20 with badges [steady_starter, growth_hero] for user: $userId",
  );
}

// Example usage:
void main() async {
  // Replace with the actual userId you want to update.
  const userId = "c6nEqzciSneNjIY8VonfSOQxAry1";
  await manuallySetStreakTo20(userId);
}
