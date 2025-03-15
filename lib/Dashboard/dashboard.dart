import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/bottom_navbar.dart';
import '../activity/activity_card.dart';
import '../widgets/progress_bar.dart';
import '../widgets/daily_time_chart.dart';
import '../widgets/tips_card.dart';
import 'package:bondtime/utils/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final PageController _tipsPageController = PageController(initialPage: 0);
  int currentPage = 0;
  int tipsCurrentPage = 0;
  int selectedDayIndex = 3; // Default selected day for time chart

  int rewardStars = 10;

  List<Map<String, dynamic>> activities = [];
  bool isLoading = true;
  String errorMessage = '';

  List<String> dailyTips = [];
  bool isTipsLoading = true;
  String tipsErrorMessage = '';

  // Stores the display role (e.g., Mama, Papa, etc.)
  String userDisplayRole = "";
  // Stores the SVG icon path based on user's role
  String roleIcon = "";
  // Stores the user's first name
  String userFirstName = "";

  @override
  void initState() {
    super.initState();
    _fetchActivities();
    _fetchDailyTips();
  }

  Future<void> _fetchActivities() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      var result = await ApiService.getActivities(userId);
      print("API Response: $result"); // Debug log

      if (result == null || !result.containsKey("activities")) {
        throw Exception(
          "Invalid API response: Missing 'activities' key or null response",
        );
      }

      // Convert the activities map to a list (including recommendedDuration)
      Map<String, dynamic> activitiesMap = result["activities"] ?? {};
      List<Map<String, dynamic>> fetchedActivities =
          activitiesMap.entries.map((entry) {
            return {
              "category": entry.value["category"] ?? "unknown",
              "title": entry.value["title"] ?? "No Title",
              "description":
                  entry.value["description"] ?? "No description available",
              "activityId": entry.value["activityId"],
              "recommendedDuration": entry.value["recommendedDuration"] ?? 10,
            };
          }).toList();

      setState(() {
        activities = fetchedActivities;
        if (activities.isEmpty) {
          errorMessage = 'No activities available today';
        }
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching activities: $e");
      setState(() {
        errorMessage =
            e.toString().contains('Timeout') || e.toString().contains('Network')
                ? 'Failed to load activities. Check your connection or try again later.'
                : 'Unexpected error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchDailyTips() async {
    setState(() {
      isTipsLoading = true;
      tipsErrorMessage = '';
    });

    try {
      // Fetch the logged-in user's document from Firestore
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (!userDoc.exists || !userDoc.data().toString().contains('role')) {
        throw Exception("User role not found.");
      }

      // Retrieve user's role and firstName from Firestore
      String userRole = userDoc.get("role");
      String firstName = userDoc.get("firstName");
      print("Fetched user role: $userRole");

      // Map the user role to display text and SVG icon
      String displayRole;
      String iconPath;
      if (userRole == "Mother") {
        displayRole = "Mama";
        iconPath = "assets/images/mother.svg";
      } else if (userRole == "Father") {
        displayRole = "Papa";
        iconPath = "assets/images/father.svg";
      } else if (userRole == "Grand Parent") {
        displayRole = "Grand Parent";
        iconPath = "assets/images/grand.svg";
      } else if (userRole == "Caregiver") {
        displayRole = "Caregiver";
        iconPath = "assets/images/caregiver.svg";
      } else {
        displayRole = userRole;
        iconPath = "assets/images/mother.svg"; // Fallback icon if needed
      }

      setState(() {
        userDisplayRole = displayRole;
        roleIcon = iconPath;
        userFirstName = firstName;
      });

      // Call the backend to get daily tips based on the user's role
      List<String> fetchedTips = await ApiService.getDailyTips(userRole);

      setState(() {
        dailyTips = fetchedTips;
        isTipsLoading = false;
      });
    } catch (e) {
      print("Error fetching daily tips: $e");
      setState(() {
        tipsErrorMessage =
            e.toString().contains('Timeout') || e.toString().contains('Network')
                ? 'Failed to load tips. Check your connection or try again later.'
                : 'Unexpected error: $e';
        isTipsLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tipsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use userFirstName instead of a fallback "User"
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 30,
        title: SvgPicture.asset('assets/icons/BondTime_logo.svg', height: 18),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/notifications.svg',
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/settings.svg',
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 3),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 0),
                Text(
                  "Good Evening, $userFirstName",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'InterTight',
                  ),
                ),
                const SizedBox(height: 16),
                ProgressBar(rewardStars: rewardStars),
                const SizedBox(height: 20),
                // Activities Section
                SizedBox(
                  height: 175,
                  child:
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : errorMessage.isNotEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(errorMessage),
                                ElevatedButton(
                                  onPressed: _fetchActivities,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                          : PageView.builder(
                            controller: _pageController,
                            itemCount: activities.length,
                            onPageChanged: (index) {
                              setState(() {
                                currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              String category = activities[index]['category'];
                              String icon;
                              switch (category) {
                                case 'fineMotor':
                                  icon = 'assets/icons/fine_motor.svg';
                                  break;
                                case 'grossMotor':
                                  icon = 'assets/icons/gross_motor.svg';
                                  break;
                                case 'communication':
                                  icon = 'assets/icons/communication.svg';
                                  break;
                                case 'sensory':
                                  icon = 'assets/icons/sensory.svg';
                                  break;
                                default:
                                  icon = 'assets/icons/activity1.svg';
                              }
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/activityScreen',
                                    arguments: activities[index],
                                  );
                                },
                                child: ActivityCard(
                                  activity: activities[index],
                                  icon: icon,
                                  currentPage: currentPage,
                                  index: index,
                                  totalPages: activities.length,
                                ),
                              );
                            },
                          ),
                ),
                const SizedBox(height: 20),
                // Daily Tips Section: show only if there are tip cards
                dailyTips.isNotEmpty
                    ? SizedBox(
                      height: 175,
                      child:
                          isTipsLoading
                              ? const Center(child: CircularProgressIndicator())
                              : tipsErrorMessage.isNotEmpty
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(tipsErrorMessage),
                                    ElevatedButton(
                                      onPressed: _fetchDailyTips,
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                              : PageView.builder(
                                controller: _tipsPageController,
                                itemCount: dailyTips.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    tipsCurrentPage = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return TipsCard(
                                    title: "Daily Tips for $userDisplayRole",
                                    description: dailyTips[index],
                                    buttonText: "Got it!",
                                    icon: roleIcon,
                                    currentPage: tipsCurrentPage,
                                    index: index,
                                    totalPages: dailyTips.length,
                                    onDone: () {
                                      setState(() {
                                        dailyTips.removeAt(index);
                                        if (tipsCurrentPage >=
                                                dailyTips.length &&
                                            tipsCurrentPage > 0) {
                                          tipsCurrentPage =
                                              dailyTips.length - 1;
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                    )
                    : const SizedBox.shrink(),
                const SizedBox(height: 20),
                // Daily Time Chart Section
                DailyTimeChart(
                  timeSpent: [1.5, 1.0, 1.7, 1.2, 0.8, 1.9, 0.5],
                  selectedDayIndex: selectedDayIndex,
                  onDaySelected: (index) {
                    setState(() {
                      selectedDayIndex = index;
                    });
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
