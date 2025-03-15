import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TipsCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final String icon;
  final int currentPage;
  final int index;
  final int totalPages;
  final VoidCallback onDone; // New callback parameter

  const TipsCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.icon,
    required this.currentPage,
    required this.index,
    required this.totalPages,
    required this.onDone, // Marked as required
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 175,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFDE8FF), // ✅ Fill Color
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFFBC7BC2), width: 1),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 30,
            left: 0,
            child: SizedBox(
              width: 250,
              child: Text(description, style: TextStyle(fontSize: 14)),
            ),
          ),
          // Updated button that triggers the onDone callback
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF111111),
                  foregroundColor: Color(0xFFFDFDFD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SvgPicture.asset(icon, width: 98, height: 131),
          ),
          // Page Indicator
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
