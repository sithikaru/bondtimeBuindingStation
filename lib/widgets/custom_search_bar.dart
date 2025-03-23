import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final FocusNode searchFocusNode;
  final String hintText;
  final ValueChanged<String> onChanged; // 🔥 Callback for search input

  const CustomSearchBar({
    super.key,
    required this.searchFocusNode,
    required this.onChanged,
    this.hintText = 'Search Pediatricians',
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.searchFocusNode,
      onChanged: widget.onChanged,
      style: TextStyle(
        color:
            widget.searchFocusNode.hasFocus ? Colors.black : Color(0xFFC9C9C9),
      ),
      cursorColor: Color(0xFF212529),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color:
              widget.searchFocusNode.hasFocus
                  ? Colors.black
                  : Color(0xFFC9C9C9),
        ),
        suffixIcon: Icon(
          Icons.search,
          color:
              widget.searchFocusNode.hasFocus
                  ? Colors.black
                  : Color(0xFFC9C9C9),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Color(0xFFC9C9C9), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Color(0xFFC9C9C9), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
        filled: true,
        fillColor: Color(0xFFF5F5F5),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }
}
