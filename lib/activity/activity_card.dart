import 'package:bondtime/activity/activity_screen.dart';
import 'package:bondtime/feedback/feedback_screen.dart';
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
    super.key,
    required this.day,
    required this.description,
    required this.icon,
    required this.currentPage,
    required this.index,
    required this.totalPages,
  });

  // Colors for each card
  final List<Map<String, Color>> cardColors = [
    {"fill": Color(0xFFDCE6FF), "stroke": Color(0xFF5283FF)}, // Blue
    {"fill": Color(0xFFE9FFEB), "stroke": Color(0xFF60D46B)}, // Green
    {"fill": Color(0xFFFFF2CF), "stroke": Color(0xFFF6CE61)}, // Yellow
    {"fill": Color(0xFFFFEAEA), "stroke": Color(0xFFEB9595)}, // Red
  ];

  @override
  Widget build(BuildContext context) {
    final fillColor = cardColors[index]["fill"] ?? Color(0xFFDCE6FF);
    final strokeColor = cardColors[index]["stroke"] ?? Color(0xFF5283FF);

    return Container(
      width: 380,
      height: 175,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: fillColor, // Dynamic Fill Color
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: strokeColor,
          width: 1,
        ), // Dynamic Stroke Color
      ),
      child: Stack(
        children: [
          // Day Title
          Positioned(
            top: 0,
            left: 0,
            child: Text(
              day,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Description with max width
          Positioned(
            top: 30,
            left: 0,
            child: SizedBox(
              width: 250,
              child: Text(
                description,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                softWrap: true,
              ),
            ),
          ),

          // Play Button (Bottom Left)
          Positioned(
            bottom: 0,
            left: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ActivityScreen()),
                );
              },
              child: SvgPicture.asset(
                "assets/icons/playicon.svg",
                width: 50,
                height: 50,
              ),
            ),
          ),

          // Activity Image (Bottom Right)
          Positioned(
            bottom: 0,
            right: 0,
            child: SvgPicture.asset(icon, width: 98, height: 131),
          ),

          // Page Indicators
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
