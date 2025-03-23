import 'package:flutter/material.dart';
import 'onboarding_screen.dart'; // Navigate to onboarding after splash

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Match your UI
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo.png', // Replace with your logo path
              height: 100, // Adjust size as needed
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Text(
              "BondTime",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
