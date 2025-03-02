import 'package:bondtime/onboarding/onboarding_screen.dart';
import 'package:bondtime/signin/sign_in_screen.dart';
import 'package:bondtime/signup/baby_registration_screen.dart';
import 'package:bondtime/signup/sign_up_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'InterTight'),
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/sign-in': (context) => const SignInScreen(),
        '/sign-up': (context) => const SignUpScreen(),
        '/baby-registration':
            (context) =>
                const BabyRegistrationScreen(), // ✅ Ensure this is correctly added
      },
    );
  }
}
