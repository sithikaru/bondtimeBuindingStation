import 'package:bondtime/widgets/statCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  /// Computes "Xy Ym Zd" style age from a date string (e.g. "23/1/2025").
  String _calculateAge(String dobString) {
    // If dobString is empty or invalid, return an empty placeholder.
    if (dobString.isEmpty || !dobString.contains('/')) {
      return '';
    }

    try {
      // Expected format: "DD/MM/YYYY"
      final parts = dobString.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final birthday = DateTime(year, month, day);
      final now = DateTime.now();

      // If dob is in the future, just show 0y 0m 0d as a fallback.
      if (birthday.isAfter(now)) {
        return '0y 0m 0d';
      }

      // Calculate difference in days.
      final totalDays = now.difference(birthday).inDays;

      // Approximate calculation for years, months, and days.
      int years = totalDays ~/ 365;
      int remainingDays = totalDays % 365;
      int months = remainingDays ~/ 30;
      int days = remainingDays % 30;

      return '${years}y ${months}m ${days}d';
    } catch (_) {
      // If there's an error parsing, return empty or "0y 0m 0d"
      return '';
    }
  }

  /// Fetch the document for the currently logged-in user.
  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchUserDoc() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If no user is signed in, throw an error or handle as needed.
      throw Exception('No user is currently signed in.');
    }
    return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'InterTight'),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F9FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Colors.black),
          centerTitle: true,
          title: const Text(
            "Baby's Profile",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: _fetchUserDoc(),
          builder: (context, snapshot) {
            /// 🔄 While loading user data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.black),
                    SizedBox(height: 12),
                    Text(
                      "Loading baby profile...",
                      style: TextStyle(
                        fontFamily: 'InterTight',
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            /// ❌ Error state
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            /// 🚫 No data state
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("No data found."));
            }

            // ✅ Data available
            final userData = snapshot.data!.data()!;
            final childData = userData['child'] ?? {};

            final firstName = childData['firstName'] ?? '';
            final lastName = childData['lastName'] ?? '';
            final dobString = childData['dob'] ?? '';

            final birthHeight = childData['birthHeight']?.toString() ?? '';
            final birthWeight = childData['birthWeight']?.toString() ?? '';
            final currentHeight = childData['currentHeight']?.toString() ?? '';
            final currentWeight = childData['currentWeight']?.toString() ?? '';

            final ageString = _calculateAge(dobString);

            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20,
              ),
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        '$firstName $lastName',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "(${userData['firstName']}'s baby)",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ageString,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                StatCard(label: "Birth Weight", value: '$birthWeight kg'),
                StatCard(label: "Birth Height", value: '$birthHeight cm'),
                StatCard(label: "Current Weight", value: '$currentWeight kg'),
                StatCard(label: "Current Height", value: '$currentHeight cm'),
              ],
            );
          },
        ),
      ),
    );
  }
}
