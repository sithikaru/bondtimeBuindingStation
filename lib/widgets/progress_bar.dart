import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProgressBar extends StatelessWidget {
  final int totalActivities;
  final int completedActivities;

  const ProgressBar({
    super.key,
    required this.totalActivities,
    required this.completedActivities,
  });

  @override
  Widget build(BuildContext context) {
    double progressPercent =
        totalActivities == 0
            ? 0.0
            : (completedActivities / totalActivities).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Daily Progress",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progressPercent),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, _) {
                  return Container(
                    height: 9.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey[300],
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: value,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: value == 0.0 ? Colors.grey[300] : Colors.blue,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "$completedActivities",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFA500),
              ),
            ),
            const SizedBox(width: 4),
            SvgPicture.asset(
              "assets/icons/star_icon.svg",
              height: 16,
              width: 16,
              color: const Color(0xFFFFA500),
            ),
          ],
        ),
      ],
    );
  }
}
