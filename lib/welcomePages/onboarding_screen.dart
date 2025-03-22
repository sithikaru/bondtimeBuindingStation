import 'package:flutter/material.dart';
import '../widgets/onboarding_page.dart';
import 'welcome_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "", // No image for welcome screen
      "title": "Welcome to BondTime",
      "description":
          "Where every moment with your child becomes a journey of love, learning, and connection.",
    },
    {
      "title": "The First Years Shape a Lifetime",
      "image": "assets/images/mother_baby.png",
      "description":
          "Love and connection lay the foundation for strong learning, confidence, and emotional well-being.",
    },
    {
      "image": "assets/images/father_child.png",
      "title": "Bonding is the Key to Growth",
      "description":
          "Through guided emotional and social activities, strengthen your bond while nurturing skills.",
    },
    {
      "image": "assets/images/mother_daughter.png",
      "title": "Play, Love, and Watch Them Thrive",
      "description":
          "Engage in fun, brain-boosting activities to support your baby's emotional, social, and cognitive growth.",
    },
  ];

  void _nextPage() {
    if (_currentIndex < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Center everything vertically and horizontally
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    title: onboardingData[index]["title"]!,
                    image: onboardingData[index]["image"]!,
                    description: onboardingData[index]["description"]!,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(309, 58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: _nextPage,
                child: const Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
