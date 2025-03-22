import 'package:bondtime/utils/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/ai_text_input.dart';
import '../widgets/ai_message_bubble.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  _AIChatScreenState createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  List<Map<String, String>> messages = [];

  void sendMessage(String text) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    setState(() {
      messages.add({'sender': 'user', 'text': text});
      messages.add({'sender': 'ai', 'text': 'Thinking...'});
    });

    try {
      final aiReply = await ApiService.sendChatMessage(userId, text);
      setState(() {
        messages.removeLast();
        messages.add({'sender': 'ai', 'text': aiReply});
      });
    } catch (e) {
      setState(() {
        messages.removeLast();
        messages.add({'sender': 'ai', 'text': 'Oops! Something went wrong.'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text('BondTime', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return AIMessageBubble(
                  text: message['text']!,
                  isUser: message['sender'] == 'user',
                );
              },
            ),
          ),
          AITextInput(onSend: sendMessage),
        ],
      ),
    );
  }
}
