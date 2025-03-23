import 'package:flutter/material.dart';
import 'growth_screen.dart';

class BondingScreen extends StatelessWidget {
  const BondingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'InterTight'),
          bodyMedium: TextStyle(fontFamily: 'InterTight'),
          displayLarge: TextStyle(fontFamily: 'InterTight'),
          displayMedium: TextStyle(fontFamily: 'InterTight'),
          displaySmall: TextStyle(fontFamily: 'InterTight'),
          headlineMedium: TextStyle(fontFamily: 'InterTight'),
          headlineSmall: TextStyle(fontFamily: 'InterTight'),
          titleLarge: TextStyle(fontFamily: 'InterTight'),
        ),
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Bonding is the Key to Growth",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Image.asset("assets/bonding.png", height: 250),
                const SizedBox(height: 20),
                const Text(
                  "Through guided emotional and social activities, you'll strengthen your bond while nurturing essential skills.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 309,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GrowthScreen()),
                      );
                    },
                    child: const Text("Next"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
