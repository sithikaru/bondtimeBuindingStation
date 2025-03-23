import 'package:flutter/material.dart';

class ThriveScreen extends StatelessWidget {
  const ThriveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Play, Love, and Watch Them Thrive",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'InterTight',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Image.asset("assets/thrive.png", height: 250),
            const SizedBox(height: 20),
            const Text(
              "Engage in playful, brain-boosting activities designed to support your baby's emotional, social, and cognitive development every step of the way.",
              style: TextStyle(fontFamily: 'InterTight'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 309,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  // Handle next action or navigation to another screen
                },
                child: const Text(
                  "Next",
                  style: TextStyle(fontFamily: 'InterTight'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
