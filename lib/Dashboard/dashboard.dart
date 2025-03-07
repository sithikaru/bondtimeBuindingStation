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

  @override
  void initState() {
    super.initState();
    _fetchActivities();
  }

  Future<void> _fetchActivities() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .get();

      Map<String, dynamic>? childData = userDoc.get("child");
      if (childData != null && childData.containsKey("dob")) {
        String dobStr = childData["dob"]; // Expected format "dd/mm/yyyy"
        List<String> parts = dobStr.split("/");
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        DateTime dob = DateTime(year, month, day);
        DateTime now = DateTime.now();
        int age = now.year - dob.year;
        if (now.month < dob.month ||
            (now.month == dob.month && now.day < dob.day)) {
          age--;
        }

        var result = await ApiService.getActivities(userId, age);
        setState(() {
          activities = List<Map<String, dynamic>>.from(
            result["activities"]["activities"],
          );
          if (activities.isEmpty) {
            errorMessage = 'No activities available today';
          }
        });
      } else {
        setState(() {
          errorMessage = 'Please complete your child\'s profile';
        });
      }
    } catch (e) {
      print("Error fetching activities: $e");
      setState(() {
        errorMessage = 'Failed to load activities';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                const Text(
                  "Good Evening, Juan",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'InterTight',
                  ),
                ),
                const SizedBox(height: 16),
                // Progress Bar Widget
                ProgressBar(rewardStars: rewardStars),
                const SizedBox(height: 20),
                // Slidable Activity Cards
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
                                case 'fine motor':
                                  icon = 'assets/icons/fine_motor.svg';
                                  break;
                                case 'gross motor':
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
                                  day: "Today's Activity",
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
                // Slidable Daily Tips Card
                SizedBox(
                  height: 175,
                  child: PageView.builder(
                    controller: _tipsPageController,
                    itemCount: 2,
                    onPageChanged: (index) {
                      setState(() {
                        tipsCurrentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return TipsCard(
                        title: "Daily tips for mama",
                        description:
                            index == 0
                                ? "Drink 12 cups of water (3 litres)"
                                : "Take deep breaths and relax",
                        buttonText: index == 0 ? "Done!" : "Got it!",
                        icon:
                            index == 0
                                ? "assets/icons/tips1.svg"
                                : "assets/icons/tips2.svg",
                        currentPage: tipsCurrentPage,
                        index: index,
                        totalPages: 2,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Daily Time Chart
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
