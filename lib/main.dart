import 'package:bondtime/Dashboard/dashboard.dart';
import 'package:bondtime/Settings/settings_page.dart';
import 'package:bondtime/activity/activity_list_screen.dart';
import 'package:bondtime/activity/activity_screen.dart';
import 'package:bondtime/bondy/ai_welcome_screen.dart';
import 'package:bondtime/feedback/feedback_screen.dart';
import 'package:bondtime/rewardScreen/rewards_screen.dart';
import 'package:bondtime/screens/pediatrician_list_screen.dart';
import 'package:bondtime/signin/forgot_password_screen.dart';
import 'package:bondtime/signin/sign_in_screen.dart';
import 'package:bondtime/signup/baby_registration_screen.dart';
import 'package:bondtime/signup/onboarding_screen.dart';
import 'package:bondtime/signup/role_selection_page.dart';
import 'package:bondtime/signup/sign_up_screen.dart';
import 'package:bondtime/welcomePages/splash_screen.dart';
import 'package:bondtime/providers/favorites_provider.dart'; // <-- Make sure this path is correct
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- Import provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Wrap MyApp in MultiProvider at the top level
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FavoritesProvider>(
          create: (_) => FavoritesProvider(),
        ),
        // Add other providers here if needed
      ],
      child: const MyApp(),
    ),
  );
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
        '/': (context) => const SplashScreen(),
        '/onBoarding': (context) => const OnboardingScreen(),
        '/sign-up': (context) => const SignUpScreen(),
        '/baby-registration': (context) => const BabyRegistrationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/sign-in': (context) => const SignInScreen(),
        '/forgotPassword': (context) => const ForgotPasswordScreen(),
        '/role_selection': (context) => RoleSelectionPage(),
        '/settings': (context) => SettingsPage(),
        '/activityScreen':
            (context) => ActivityScreen(
              activity:
                  ModalRoute.of(context)!.settings.arguments
                      as Map<String, dynamic>,
            ),
        '/feedbackScreen':
            (context) => FeedbackScreen(
              activityId: ModalRoute.of(context)!.settings.arguments as String,
              durationSpent: 0,
            ),
        '/rewardsScreen': (context) => RewardsScreen(),
        '/bondy': (context) => const AIWelcomeScreen(),
        '/pediatricianlist': (context) => const PediatricianListScreen(),
        'activities': (context) => const ActivityListScreen(),
      },
    );
  }
}
