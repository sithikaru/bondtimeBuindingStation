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
    return Card(
      elevation: 5,
      color: Colors.pink[50], // Light pink background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(color: Colors.red, width: 2), // Red border
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
            SvgPicture.asset(imagePath, height: 200, width: 200),
            const SizedBox(height: 24),
            // Title
            Text(
              title,
              style: const TextStyle(
                fontFamily: "InterTight",
                fontSize: 20,
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
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            // Primary Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPrimaryButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  primaryButtonText,
                  style: const TextStyle(
                    fontFamily: "InterTight",
                    color: Colors.white,
                    fontSize: 16,
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
