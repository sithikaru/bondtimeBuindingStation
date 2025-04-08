import 'package:bondtime/widgets/skillCard.dart';
import 'package:bondtime/widgets/statCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          const SizedBox(height: 20),

          // Avatar, name and age in a row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: SvgPicture.asset(
                    'assets/baby.svg',
                    fit: BoxFit.cover,
                    placeholderBuilder:
                        (_) => Container(color: Colors.grey[300]),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Juan Jr. ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '(Sara’s baby)',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "00y 7m 12d",
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Scrollable Stat Cards
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                StatCard(label: "Weight", value: "8kg"),
                SizedBox(width: 10),
                StatCard(label: "Height", value: "69.2 cm"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Skill Cards
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              SkillCard(
                title: "Fine\nMotor Skills",
                value: 3.5,
                color: Color(0xFFDFF8E5),
              ),
              SkillCard(
                title: "Gross\nMotor Skills",
                value: 3.5,
                color: Color(0xFFDDEAFE),
              ),
              SkillCard(
                title: "Sensory\nDevelopment",
                value: 3.5,
                color: Color(0xFFFFE5E5),
              ),
              SkillCard(
                title: "Communication\nSkills",
                value: 3.5,
                color: Color(0xFFFFF5CC),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
