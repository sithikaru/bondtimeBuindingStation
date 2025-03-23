import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ai_chat_screen.dart'; // Import the Chat Screen

class AIWelcomeScreen extends StatelessWidget {
  const AIWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // <--- Gradient Background Container
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF), // Pure white base color
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFCE4EC), // Very Light Pink
            Color(0xFFE3F2FD), // Very Light Blue
          ],
          stops: [0.3, 1.0], // Adjusted stops for smoother transition
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Transparent to show gradient
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Title
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "BondTime",
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Avatar
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/images/bondy.png'),
              ),
              SizedBox(height: 20),

              // Gradient Text
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: <Color>[
                      Color(0xFFF28AAC), // Pinkish
                      Color(0xFF6C7DD2), // Bluish
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  "Hi I'm Bondy,",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    color:
                        Colors
                            .white, // Text color doesn't matter; masked by gradient
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Subtitle
              Text(
                "Your AI companion",
                style: GoogleFonts.poppins(fontSize: 20, color: Colors.black54),
              ),
              SizedBox(height: 10),

              Text(
                "How can I help you today?",
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.black54),
              ),

              Spacer(),

              // Input Field with Navigation
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AIChatScreen()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white, // Input field background
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Ask me anything...",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Icon(Icons.mic, color: Colors.blue),
                    ],
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
