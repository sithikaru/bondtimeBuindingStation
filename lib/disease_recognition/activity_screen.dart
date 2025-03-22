import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // ✅ Align to center
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// **Image**
              SvgPicture.asset(
                'assets/icons/warning.svg',
                height: 200, // ✅ Adjust size as needed
                width: 200,
              ),
              const SizedBox(height: 24), // ✅ Added space after image

              /// **Title**
              const Text(
                "We are a bit concerned !",
                style: TextStyle(
                  fontFamily: "InterTight",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16), // ✅ Increased space after title

              /// **Description**
              const Text(
                "Based on feedback from Days 3, 4, 5, and 6, we've noticed potential signs of developmental delays in your child's motor skills. "
                "To ensure the best care, we strongly recommend consulting a pediatrician at the earliest. "
                "Early support can make a big difference!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "InterTight",
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24), // ✅ Added more space before buttons

              /// **See Pediatricians Button**
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Add action for Pediatrician redirection
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14), // ✅ Button padding
                  ),
                  child: const Text(
                    "See Pediatricians",
                    style: TextStyle(
                      fontFamily: "InterTight",
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16), // ✅ Added space between buttons

              /// **Ask Bondy Button**
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Add action for AI assistant Bondy
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14), // ✅ Button padding
                  ),
                  child: const Text(
                    "Ask Bondy",
                    style: TextStyle(
                      fontFamily: "InterTight",
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
