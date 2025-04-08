import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class BadgeMilestone {
  final String key;
  final String title;
  final String description;
  final int dayTarget;

  const BadgeMilestone({
    required this.key,
    required this.title,
    required this.description,
    required this.dayTarget,
  });
}

const List<BadgeMilestone> allMilestones = [
  BadgeMilestone(
    key: "steady_starter",
    title: "Steady Starter",
    description: "Recognizing the early consistency in bonding.",
    dayTarget: 10,
  ),
  BadgeMilestone(
    key: "growth_hero",
    title: "Growth Hero",
    description: "Honoring continued efforts in growth.",
    dayTarget: 20,
  ),
  BadgeMilestone(
    key: "bonding_boss",
    title: "Bonding Boss",
    description: "Master of playful connection!",
    dayTarget: 30,
  ),
  BadgeMilestone(
    key: "consistency_king",
    title: "Consistency King",
    description: "You’re seriously committed to bonding.",
    dayTarget: 60,
  ),
  BadgeMilestone(
    key: "bonded_pro",
    title: "Bonded Pro",
    description: "90 days of love & learning.",
    dayTarget: 90,
  ),
  BadgeMilestone(
    key: "daily_legend",
    title: "Daily Legend",
    description: "120 days! You’re unstoppable!",
    dayTarget: 120,
  ),
  BadgeMilestone(
    key: "unstoppable",
    title: "Unstoppable",
    description: "180 days of pure bonding mastery.",
    dayTarget: 180,
  ),
];

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int currentStreak = 0;
  List<String> unlockedBadges = [];

  @override
  void initState() {
    super.initState();
    // First, call the update streak endpoint, then fetch the Firestore data.
    callUpdateStreak().then((_) {
      fetchStreakData();
    });
  }

  Future<void> callUpdateStreak() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userId = user.uid;
    // Replace with your actual backend URL.
    final url = Uri.parse(
      "https://bondtime-backend-nodejs1.vercel.app/update-streak",
    );
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userId}),
      );
      print("updateStreak response: ${response.body}");
    } catch (e) {
      print("Error calling updateStreak: $e");
    }
  }

  Future<void> fetchStreakData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("progress")
        .doc("streak");
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      setState(() {
        currentStreak = snapshot.data()?["currentStreak"] ?? 0;
        unlockedBadges = List<String>.from(
          snapshot.data()?["unlockedBadges"] ?? [],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Split unlocked and upcoming badges
    final unlocked =
        allMilestones.where((b) => unlockedBadges.contains(b.key)).toList();
    final upcoming =
        allMilestones.where((b) => !unlockedBadges.contains(b.key)).toList();

    // Get the last unlocked badge (or the first milestone if none)
    final lastUnlocked =
        unlocked.isNotEmpty ? unlocked.last : allMilestones.first;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Rewards",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Container(
            constraints: BoxConstraints(minWidth: 46, minHeight: 28),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFFFED7D7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$currentStreak",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4),
                SvgPicture.asset(
                  'assets/icons/streaks_icon.svg',
                  height: 18,
                  width: 18,
                  colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/reward_icon.svg',
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Last Earned Badge
              Container(
                width: MediaQuery.of(context).size.width,
                height: 181,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/reward_icon.svg',
                      height: 50,
                      width: 50,
                      colorFilter: ColorFilter.mode(
                        Colors.orange,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      lastUnlocked.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${lastUnlocked.description}\n(${lastUnlocked.dayTarget} days streak)",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // Show Unlocked Badges
              if (unlocked.isNotEmpty) ...[
                Text(
                  "Unlocked Badges",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: unlocked.length,
                  itemBuilder: (context, index) {
                    final badge = unlocked[index];
                    return badgeTile(badge, true);
                  },
                ),
                SizedBox(height: 24),
              ],
              // Show What's Next
              Text(
                "What's next",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: upcoming.length,
                itemBuilder: (context, index) {
                  final badge = upcoming[index];
                  return badgeTile(badge, false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget badgeTile(BadgeMilestone badge, bool isUnlocked) {
    final progress = (currentStreak / badge.dayTarget).clamp(0.0, 1.0);
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/reward_icon.svg',
            height: 30,
            width: 30,
            colorFilter: ColorFilter.mode(
              isUnlocked ? Colors.amber : Colors.black,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isUnlocked ? Colors.amber[800] : Colors.black,
                  ),
                ),
                Text(
                  "${badge.description}\n(${badge.dayTarget} days streak)",
                  style: TextStyle(
                    color: isUnlocked ? Colors.amber[600] : Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                "$currentStreak/${badge.dayTarget}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? Colors.amber[800] : Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Container(
                width: 50,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isUnlocked ? Colors.amber : Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
