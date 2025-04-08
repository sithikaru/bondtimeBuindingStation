import 'package:bondtime/utils/api_service.dart';
import 'package:bondtime/widgets/ai_message_bubble.dart';
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
  final TextEditingController _textController = TextEditingController();

  // Scroll helper function to auto-scroll to the bottom.
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

  /// This widget holds all the welcome UI elements.
  Widget welcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Top Title
        SizedBox(height: 150),
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
              color: Colors.white, // Color is masked by the gradient
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

  /// The chat input area placed within the scrollable content.
  Widget chatInputSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white, // Background for the input
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
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "Ask me anything...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  sendMessage(value);
                  _textController.clear();
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              if (_textController.text.trim().isNotEmpty) {
                sendMessage(_textController.text);
                _textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Overall gradient background
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFCE4EC), // Very Light Pink
            Color(0xFFE3F2FD), // Very Light Blue
          ],
          stops: [0.3, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // To show the gradient
        // App bar removed; now only the welcome section, chat input and chat messages remain.
        body: Column(
          children: [
            // Expanded scrollable area for welcome, chat input and chat messages.
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(20),
                // Items: welcomeSection, chat input, and all dynamic messages.
                itemCount: messages.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // The welcome section.
                    return welcomeSection();
                  } else if (index == 1) {
                    // The integrated text input area.
                    return chatInputSection();
                  } else {
                    // Chat messages: adjust index since welcomeSection and text input are at indexes 0 and 1.
                    final message = messages[index - 2];
                    return AIMessageBubble(
                      text: message['text']!,
                      isUser: message['sender'] == 'user',
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
