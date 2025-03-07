import 'package:flutter/material.dart';
import 'thank_you_screen.dart';
import '../widgets/feedback_card.dart';

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BondTime"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: FeedbackCard(
          question:
              "Did you observe any difficulties while your child was doing this activity?",
          onNext: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ThankYouScreen(),
              ),
            );
          },
          isLast: true,
        ),
      ),
    );
  }
}
