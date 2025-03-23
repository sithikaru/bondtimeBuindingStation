import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecognitionCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final VoidCallback onPrimaryButtonPressed;
  final String primaryButtonText;

  const RecognitionCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.onPrimaryButtonPressed,
    required this.primaryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.pink[50], // Light pink background
        borderRadius: BorderRadius.circular(
          20.0,
        ), // Increased corner radius for rounded edges
        border: Border.all(
          color: Colors.red,
          width: 3,
        ), // Red border with thicker width
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 25.0,
        ), // Added more padding for a spacious layout
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
            SvgPicture.asset(
              imagePath,
              height: 150,
              width: 150,
            ), // Adjusted image size for balance
            const SizedBox(
              height: 30,
            ), // Increased space between the image and the text
            // Title
            Text(
              title,
              style: const TextStyle(
                fontFamily: "InterTight",
                fontSize: 24, // Increased font size for title
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "InterTight",
                fontSize: 16, // Adjusted font size for better readability
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30), // Increased space before the button
            // Primary Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPrimaryButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded button
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ), // Added more padding for the button
                ),
                child: Text(
                  primaryButtonText,
                  style: const TextStyle(
                    fontFamily: "InterTight",
                    color: Colors.white,
                    fontSize: 18, // Larger button text
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
