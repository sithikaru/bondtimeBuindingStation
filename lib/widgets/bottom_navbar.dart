import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5), // Maintain top padding
      decoration: BoxDecoration(
        color: Color(0xFFFDFDFD), // Background color
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // Soft shadow
            offset: Offset(0, 4), // X: 0, Y: 4
            blurRadius: 9.3,
            spreadRadius: 9,
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent, // Transparent background
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed, // No shifting
        elevation: 0, // Remove extra shadow
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 0
                  ? "assets/icons/dashboard_selected.svg"
                  : "assets/icons/dashboard.svg",
              width: 24,
            ),
            label: "dashboard",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 1
                  ? "assets/icons/bondy_selected.svg"
                  : "assets/icons/bondy.svg",
              width: 24,
            ),
            label: "bondy",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 2
                  ? "assets/icons/activities_selected.svg"
                  : "assets/icons/activities.svg",
              width: 24,
            ),
            label: "activities",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 3
                  ? "assets/icons/pediatricians_selected.svg"
                  : "assets/icons/pediatricians.svg",
              width: 24,
            ),
            label: "pediatricians",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 4
                  ? "assets/icons/profile_selected.svg"
                  : "assets/icons/profile.svg",
              width: 24,
            ),
            label: "profile",
          ),
        ],
      ),
    );
  }
}
