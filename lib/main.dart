import 'package:bondtime/Dashboard/dashboard.dart';
import 'package:bondtime/signup/baby_registration_screen.dart';
import 'package:bondtime/signup/onboarding_screen.dart';
import 'package:bondtime/signup/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BondTime',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      // Define routes
      routes: {
        '/': (context) => const OnboardingScreen(), // Initial screen
        '/sign-up': (context) => const SignUpScreen(),
        '/baby-registration': (context) => const BabyRegistrationScreen(),
        '/home': (context) => const DashboardScreen(), // Add this line
      },
    );
  }
}
