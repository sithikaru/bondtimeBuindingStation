// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/activity_card.dart';
import '../widgets/progress_bar.dart';
import '../widgets/daily_time_chart.dart';
import '../widgets/tips_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController(initialPage: 1);
  final PageController _tipsPageController = PageController(initialPage: 0);
  int currentPage = 1;
  int tipsCurrentPage = 0;
  int selectedDayIndex = 3; // ✅ Default selected day for time chart

  int rewardStars = 10;

  final List<Map<String, String>> activities = [
    {
      "day": "Day 4",
      "description": "Read a bedtime story to your child before sleep.",
      "icon": "assets/icons/activity1.svg",
    },
    {
      "day": "Day 4",
      "description":
          "10 minutes engaging with your child playing with building blocks.",
      "icon": "assets/icons/activity1.svg",
    },
    {
      "day": "Day 4",
      "description": "Encourage your child to draw something they love.",
      "icon": "assets/icons/activity1.svg",
    },
    {
      "day": "Day 4",
      "description": "Take a short walk outside with your child for fresh air.",
      "icon": "assets/icons/activity1.svg",
    },
  ];

  final List<Map<String, String>> tips = [
    {
      "title": "Daily tips for mama",
      "description": "Drink 12 cups of water (3 litres)",
      "buttonText": "Done!",
      "icon": "assets/icons/tips1.svg",
    },
    {
      "title": "Daily tips for mama",
      "description": "Take deep breaths and relax",
      "buttonText": "Got it!",
      "icon": "assets/icons/tips2.svg",
    },
  ];

  final List<double> timeSpent = [
    1.5,
    1.0,
    1.7,
    1.2,
    0.8,
    1.9,
    0.5,
  ]; // Hours spent per day

  // ✅ Updates the selected day when a bar in the chart is tapped
  void updateSelectedDay(int index) {
    setState(() {
      selectedDayIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
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
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          SizedBox(width: 8),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/settings.svg',
              height: 24,
              width: 24,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          SizedBox(width: 3),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
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
                    "44",
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
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
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
                SizedBox(height: 0),

                Text(
                  "Good Evening, Juan",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'InterTight',
                  ),
                ),
                SizedBox(height: 16),

                // **Progress Bar Widget**
                ProgressBar(rewardStars: rewardStars),

                SizedBox(height: 20),

                // **Slidable Activity Cards**
                SizedBox(
                  height: 175,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: activities.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return ActivityCard(
                        day: activities[index]["day"]!,
                        description: activities[index]["description"]!,
                        icon: activities[index]["icon"]!,
                        currentPage: currentPage,
                        index: index,
                        totalPages: activities.length,
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),

                // **Slidable Daily Tips Card**
                SizedBox(
                  height: 175,
                  child: PageView.builder(
                    controller: _tipsPageController,
                    itemCount: tips.length,
                    onPageChanged: (index) {
                      setState(() {
                        tipsCurrentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return TipsCard(
                        title: tips[index]["title"]!,
                        description: tips[index]["description"]!,
                        buttonText: tips[index]["buttonText"]!,
                        icon: tips[index]["icon"]!,
                        currentPage: tipsCurrentPage,
                        index: index,
                        totalPages: tips.length,
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),

                // **Daily Time Chart**
                DailyTimeChart(
                  timeSpent: timeSpent,
                  selectedDayIndex:
                      selectedDayIndex, // ✅ Controlled by tapping bars
                  onDaySelected: updateSelectedDay, // ✅ Handles bar taps
                ),

                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
