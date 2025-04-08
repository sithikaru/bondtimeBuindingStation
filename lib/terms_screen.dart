import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sticky Title
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Text(
                "Terms & Conditions",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            // Scrollable Content without gradient
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Before you begin, please take a moment to read our Terms and Conditions. By continuing, you agree to the following:",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 24),
                    _buildTerm(
                      title: "1. Data Usage",
                      content:
                          "BondTime collects limited information to personalize your experience and improve app functionality. Your data will never be sold or shared without your permission.",
                    ),
                    _buildTerm(
                      title: "2. Notifications",
                      content:
                          "You may receive reminders, parenting tips, and daily activity prompts. You can turn these off anytime in your device settings.",
                    ),
                    _buildTerm(
                      title: "3. Health Disclaimer",
                      content:
                          "BondTime provides guidance based on expert research, but it is not a substitute for professional medical advice. Always consult a healthcare provider when needed.",
                    ),
                    _buildTerm(
                      title: "4. User Responsibility",
                      content:
                          "You are responsible for any actions taken based on the content provided in the app.",
                    ),
                    _buildTerm(
                      title: "5. Withdrawal of Consent",
                      content:
                          "You may withdraw your consent and delete your data at any time through the app’s settings.",
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "By tapping “Agree”, you confirm that you have read, understood, and accepted these terms.",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // Bottom Buttons in SafeArea
            SafeArea(
              minimum: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: _buildButtonRow(context),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildTerm({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(content, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            side: const BorderSide(color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("You declined the terms.")),
            );
          },
          child: const Text(
            "Decline",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/sign-up');
          },
          child: const Text(
            "Agree",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white, // <- sets the text color to white
            ),
          ),
        ),
      ],
    );
  }
}
