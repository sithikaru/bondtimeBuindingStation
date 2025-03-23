import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final bool showBackButton;

  const CustomAppBar({this.showBackButton = false, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          showBackButton
              ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )
              : null,
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
