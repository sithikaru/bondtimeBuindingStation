import 'package:bondtime/utils/api_service.dart';
import 'package:bondtime/widgets/ai_message_bubble.dart';
import 'package:bondtime/widgets/ai_text_input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MergedScreen extends StatefulWidget {
  const MergedScreen({Key? key}) : super(key: key);

  @override
  _MergedScreenState createState() => _MergedScreenState();
}

class _MergedScreenState extends State<MergedScreen> {
  List<Map<String, String>> messages = [];
  final ScrollController _scrollController = ScrollController();

  // Auto-scroll helper to ensure the latest message is visible.
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendMessage(String text) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    setState(() {
      messages.add({'sender': 'user', 'text': text});
      messages.add({'sender': 'ai', 'text': 'Thinking...'});
    });
    scrollToBottom();

    try {
      final aiReply = await ApiService.sendChatMessage(userId, text);
      setState(() {
        messages.removeLast();
        messages.add({'sender': 'ai', 'text': aiReply});
      });
      scrollToBottom();
    } catch (e) {
      setState(() {
        messages.removeLast();
        messages.add({'sender': 'ai', 'text': 'Oops! Something went wrong.'});
      });
      scrollToBottom();
    }
  }

  /// Displays the welcome section with title, avatar, and introductory text.
  Widget welcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title
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
                Color(0xFFF28AAC), // Pinkish.
                Color(0xFF6C7DD2), // Bluish.
              ],
            ).createShader(bounds);
          },
          child: Text(
            "Hi I'm Bondy,",
            style: GoogleFonts.poppins(
              fontSize: 28,
              color: Colors.white, // The actual color is masked.
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
        SizedBox(height: 20),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Overall gradient background.
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFCE4EC), // Very Light Pink.
            Color(0xFFE3F2FD), // Very Light Blue.
          ],
          stops: [0.3, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // To display the gradient.
        body: Column(
          children: [
            // Scrollable area for welcome section and messages.
            Expanded(
              child: ScrollConfiguration(
                behavior: _NoGlowScrollBehavior(),
                child: ListView.builder(
                  controller: _scrollController,
                  // Remove extra top padding to prevent overscrolling.
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    top: 20,
                  ),
                  physics: const ClampingScrollPhysics(), // No bounce effect.
                  // One extra item for the welcome section.
                  itemCount: messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return welcomeSection();
                    } else {
                      // Adjust index: messages start after the welcome section.
                      final message = messages[index - 1];
                      return AIMessageBubble(
                        text: message['text']!,
                        isUser: message['sender'] == 'user',
                      );
                    }
                  },
                ),
              ),
            ),
            // Fixed input area at the bottom.
            AITextInput(onSend: sendMessage),
          ],
        ),
      ),
    );
  }
}

/// Custom ScrollBehavior to remove the overscroll glow effect.
class _NoGlowScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
