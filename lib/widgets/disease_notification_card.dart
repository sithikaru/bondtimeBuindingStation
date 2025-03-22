import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DiseaseNotificationCard extends StatelessWidget {
  final VoidCallback onTap;

  const DiseaseNotificationCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter, // Moves the card to the top
      child: Container(
        width: 380, // Fixed width
        height: 175, // Fixed height
        margin: const EdgeInsets.only(top: 16), // Space from the top
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 10), // Adjust padding
        decoration: BoxDecoration(
          color: Colors.red[100], // Light red background
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
              color: const Color(0xFFFF3030), width: 2), // FF3030 outline
        ),
        child: Stack(
          children: [
            /// **Text & Button Section**
            Positioned(
              left: 10,
              top: 12,
              width: 220, // Restrict width so it doesn’t overlap SVG
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "We are a bit concerned!",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "InterTight",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "There are signs of possible hearing issues. Please consult a pediatrician soon.",
                    style: TextStyle(
                      fontFamily: "InterTight",
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 160,
                    height: 40, // Increased button height
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                      ),
                      child: const Text(
                        "Get info",
                        style: TextStyle(
                          fontFamily: "InterTight",
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// **SVG Positioned at the Bottom-Right Outline**
            Positioned(
              bottom: -10, // Move it slightly outside the card
              right: -10, // Move it slightly outside the card
              child: SvgPicture.asset(
                'assets/icons/warning.svg',
                height: 135,
                width: 135,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
