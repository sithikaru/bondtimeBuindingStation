import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityCard extends StatelessWidget {
  final String day;
  final String description;
  final String icon;
  final int currentPage;
  final int index;
  final int totalPages;

  ActivityCard({
    required this.day,
    required this.description,
    required this.icon,
    required this.currentPage,
    required this.index,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 175,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFDCE6FF),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF5283FF), width: 1),
      ),
      child: Stack(
        children: [
          // Day Title (Fixed Position)
          Positioned(
            top: 0,
            left: 0,
            child: Text(
              day,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Description (Constrained Width)
          Positioned(
            top: 30,
            left: 0,
            child: SizedBox(
              width: 250, // ✅ Set max width for description
              child: Text(
                description,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                softWrap: true, // Allow text wrapping
              ),
            ),
          ),

          // Play Button (Bottom Left)
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(
              "assets/icons/playicon.svg",
              width: 50,
              height: 50,
            ),
          ),

          // Activity Image (Bottom Right)
          Positioned(
            bottom: 0,
            right: 0,
            child: SvgPicture.asset(
              icon,
              width: 98,
              height: 131,
            ),
          ),

          // Page Indicators (Bottom Center)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalPages, (i) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPage == i ? Colors.black : Colors.grey[400],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}