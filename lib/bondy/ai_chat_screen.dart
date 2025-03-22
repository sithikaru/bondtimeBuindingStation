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

  void sendMessage(String text) {
    setState(() {
      messages.add({'sender': 'user', 'text': text});
      messages.add({'sender': 'ai', 'text': 'Thinking...'});
    });

    // Simulate AI thinking
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        messages.removeLast();
        messages.add({'sender': 'ai', 'text': 'Here is a helpful response!'});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'BondTime',
          style: TextStyle(color: Colors.black),
        ),
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
