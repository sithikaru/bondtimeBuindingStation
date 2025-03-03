import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProgressBar extends StatelessWidget {
  final int rewardStars;

  const ProgressBar({required this.rewardStars});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 9.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[300],
            ),
            child: Stack(
              children: [
                Container(
                  width: 316 * 0.5,
                  height: 9.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(
          "$rewardStars",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFA500),
          ),
        ),
        SizedBox(width: 4),
        SvgPicture.asset("assets/icons/star_icon.svg", height: 16, width: 16, color: Color(0xFFFFA500)),
      ],
    );
  }
}