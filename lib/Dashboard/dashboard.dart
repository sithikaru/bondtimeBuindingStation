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
      var result = await ApiService.getActivities(userId);
      print("API Response: $result"); // Debug log

      if (result == null || !result.containsKey("activities")) {
        throw Exception(
          "Invalid API response: Missing 'activities' key or null response",
        );
      }

      // Convert activities map to list
      Map<String, dynamic> activitiesMap = result["activities"] ?? {};
      List<Map<String, dynamic>> fetchedActivities =
          activitiesMap.entries.map((entry) {
            return {
              "category": entry.value["category"] ?? "unknown",
              "title": entry.value["title"] ?? "No Title",
              "description":
                  entry.value["description"] ?? "No description available",
              "activityId": entry.value["activityId"],
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
      print("Error fetching activities: $e"); // Debug log
      setState(() {
        errorMessage =
            e.toString().contains('Timeout') || e.toString().contains('Network')
                ? 'Failed to load activities. Check your connection or try again later.'
                : 'Unexpected error: $e';
        isLoading = false;
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
                ProgressBar(rewardStars: rewardStars),
                const SizedBox(height: 20),
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
