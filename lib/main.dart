import 'package:bondtime/Dashboard/dashboard.dart';
import 'package:bondtime/activity/activity_screen.dart';
import 'package:bondtime/feedback/feedback_screen.dart';
import 'package:bondtime/signin/forgot_password_screen.dart';
import 'package:bondtime/signin/sign_in_screen.dart';
import 'package:bondtime/signup/baby_registration_screen.dart';
import 'package:bondtime/signup/onboarding_screen.dart';
import 'package:bondtime/signup/role_selection_page.dart';
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
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/sign-up': (context) => const SignUpScreen(),
        '/baby-registration': (context) => const BabyRegistrationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/sign-in': (context) => const SignInScreen(),
        '/forgotPassword': (context) => const ForgotPasswordScreen(),
        '/role_selection': (context) => RoleSelectionPage(),
        '/activityScreen':
            (context) => ActivityScreen(
              activity:
                  ModalRoute.of(context)!.settings.arguments
                      as Map<String, dynamic>,
            ),
        '/feedbackScreen':
            (context) => FeedbackScreen(
              activityId: ModalRoute.of(context)!.settings.arguments as String,
            ),
      },
    );
  }
}
