import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'InterTight'),
          bodyMedium: TextStyle(fontFamily: 'InterTight'),
          labelLarge: TextStyle(fontFamily: 'InterTight'),
          bodySmall: TextStyle(fontFamily: 'InterTight'),
          displayLarge: TextStyle(fontFamily: 'InterTight'),
          displayMedium: TextStyle(fontFamily: 'InterTight'),
          displaySmall: TextStyle(fontFamily: 'InterTight'),
          headlineMedium: TextStyle(fontFamily: 'InterTight'),
          headlineSmall: TextStyle(fontFamily: 'InterTight'),
          titleLarge: TextStyle(fontFamily: 'InterTight'),
          titleMedium: TextStyle(fontFamily: 'InterTight'),
          titleSmall: TextStyle(fontFamily: 'InterTight'),
        ),
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to BondTime!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(200, 50),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/onBoarding');
                },
                child: const Text(
                  "Get Started",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
