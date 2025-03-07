import 'package:bondtime/activity/activity_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _selectedIndex = 2; // Default to Activities tab

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 30, // Reduced padding between back arrow and logo
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: SvgPicture.asset(
          'assets/icons/bondtime_logo.svg', // Path to your SVG logo
          height: 18, // Set height to 18px
        ),
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
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/settings.svg',
                height: 24,
                width: 24,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            SvgPicture.asset(
              'assets/icons/engagement.svg',
              height: 261,
              width: 196,
            ),
            SizedBox(height: 35),
            Text(
              'Spend 10 minutes engaging with your child',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            SizedBox(
              width: 344,
              height: 58,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActivityScreenTwo(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Start',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 5), // Added top padding for height
        decoration: BoxDecoration(
          color: Color(0xFFFDFDFD), // Background Color
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // 5% opacity
              offset: Offset(0, 4), // X: 0, Y: 4
              blurRadius: 9.3, // Blur
              spreadRadius: 9, // Spread
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor:
              Colors
                  .transparent, // Make it transparent to show the container color
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed, // Ensure no shifting behavior
          elevation: 0, // Remove shadow if any
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _selectedIndex == 0
                    ? 'assets/icons/dashboard_selected.svg'
                    : 'assets/icons/dashboard.svg',
                height: 24,
                width: 24,
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _selectedIndex == 1
                    ? 'assets/icons/bondy_selected.svg'
                    : 'assets/icons/bondy.svg',
                height: 24,
                width: 24,
              ),
              label: 'Bondy',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _selectedIndex == 2
                    ? 'assets/icons/activities_selected.svg'
                    : 'assets/icons/activities.svg',
                height: 24,
                width: 24,
              ),
              label: 'Activities',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _selectedIndex == 3
                    ? 'assets/icons/pediatricians_selected.svg'
                    : 'assets/icons/pediatricians.svg',
                height: 24,
                width: 24,
              ),
              label: 'Pediatricians',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _selectedIndex == 4
                    ? 'assets/icons/profile_selected.svg'
                    : 'assets/icons/profile.svg',
                height: 24,
                width: 24,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
