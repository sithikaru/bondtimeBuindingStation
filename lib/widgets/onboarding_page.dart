import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String image;
  final String description;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.image,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    bool isWelcomeScreen = title == "Welcome to BondTime";

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isWelcomeScreen) ...[
              const Text(
                "Welcome to",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 314.77,
                height: 62,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    "BondTime",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ] else ...[
              // Title above image
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              Image.asset(
                image,
                height: 250,
              ),
              const SizedBox(height: 24),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
