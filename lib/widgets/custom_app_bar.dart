import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(45); // 🔥 Adjusted height for logo

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            top: 35,
            left: 20,
            child: SvgPicture.asset(
              'assets/icons/bondtime-logo.svg',
              width: 112,
              height: 22,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
