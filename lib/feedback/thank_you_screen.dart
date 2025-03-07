import 'package:flutter/material.dart';
import '../styles/app_styles.dart'; // Ensure this file exists

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 368,
          height: 484,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.65),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Thank You for Your Feedback!",
                style: AppStyles.headline, // Fixed reference
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 40,
              ),
              const SizedBox(height: 15),
              Text(
                "Your insights help us tailor activities that better suit your child’s needs. We’re grateful for your support in their growth journey!",
                style: AppStyles.bodyText, // Fixed reference
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/next_activity');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Next Activity", style: AppStyles.buttonText),
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black, width: 2),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Close", style: AppStyles.buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
