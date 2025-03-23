import 'package:flutter/material.dart';

class AITextInput extends StatefulWidget {
  final Function(String) onSend;

  const AITextInput({super.key, required this.onSend});

  @override
  _AITextInputState createState() => _AITextInputState();
}

class _AITextInputState extends State<AITextInput> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSend(_controller.text.trim());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Ask me anything...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
