import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bondtime/activity/activity_screen.dart';

class ActivityCard extends StatelessWidget {
  final Map<String, dynamic> activity;
  final String icon;
  final int currentPage;
  final int index;
  final int totalPages;

  ActivityCard({
    super.key,
    required this.activity,
    required this.icon,
    required this.currentPage,
    required this.index,
    required this.totalPages,
  });

  final List<Map<String, Color>> cardColors = [
    {"fill": const Color(0xFFDCE6FF), "stroke": const Color(0xFF5283FF)},
    {"fill": const Color(0xFFE9FFEB), "stroke": const Color(0xFF60D46B)},
    {"fill": const Color(0xFFFFF2CF), "stroke": const Color(0xFFF6CE61)},
    {"fill": const Color(0xFFFFEAEA), "stroke": const Color(0xFFEB9595)},
  ];

  @override
  Widget build(BuildContext context) {
    final fillColor =
        cardColors[index % cardColors.length]["fill"] ??
        const Color(0xFFDCE6FF);
    final strokeColor =
        cardColors[index % cardColors.length]["stroke"] ??
        const Color(0xFF5283FF);

    return Container(
      width: 380,
      height: 175,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: strokeColor, width: 1),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Text(
              activity['title'] ?? "Today's Activity",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 30,
            left: 0,
            child: SizedBox(
              width: 250,
              height: 60,
              child: Text(
                activity['description'] ?? 'No description available',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                softWrap: true,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityScreen(activity: activity),
                  ),
                );
              },
              child: SvgPicture.asset(
                "assets/icons/playicon.svg",
                width: 50,
                height: 50,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SvgPicture.asset(icon, width: 98, height: 131),
          ),
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
                  margin: const EdgeInsets.symmetric(horizontal: 4),
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
