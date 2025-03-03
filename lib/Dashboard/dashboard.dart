import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/activity_card.dart';
import '../widgets/date_selector.dart';
import '../widgets/progress_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController(initialPage: 1);
  int currentPage = 1;

  final List<String> days = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];
  final List<String> dates = ["19", "20", "21", "1/3", "22", "23", "24"];
  final List<bool> completedDays = [
    true,
    true,
    true,
    false,
    false,
    false,
    false,
  ];
  int selectedIndex = 3;
  int rewardStars = 10;

  void selectDay(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Map<String, String>> activities = [
    {
      "day": "Day 3",
      "description": "Read a bedtime story to your child before sleep.",
      "icon": "assets/icons/activity1.svg",
    },
    {
      "day": "Day 4",
      "description":
          "Spend 10 minutes engaging with your child playing with building blocks.",
      "icon": "assets/icons/activity1.svg",
    },
    {
      "day": "Day 5",
      "description": "Encourage your child to draw something they love.",
      "icon": "assets/icons/activity1.svg",
    },
  ];

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
              'assets/icons/notifications.svg', // Restored notification icon
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                "Good Evening, Juan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'InterTight',
                ),
              ),
              SizedBox(height: 5),

              // **Date Selector Widget**
              DateSelector(
                days: days,
                dates: dates,
                completedDays: completedDays,
                selectedIndex: selectedIndex,
                onSelectDay: selectDay,
              ),

              SizedBox(height: 16),

              // **Progress Bar Widget**
              ProgressBar(rewardStars: rewardStars),

              SizedBox(height: 16),

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
            ],
          ),
        ),
      ),
    );
  }
}
