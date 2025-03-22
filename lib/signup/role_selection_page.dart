import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  _RoleSelectionPageState createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? selectedRole;

  void selectRole(String role) {
    setState(() {
      selectedRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF111111)),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Text(
              "What’s your special role to this little one",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111111),
                fontFamily: 'InterTight',
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Every detail helps us support your baby’s journey.",
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey,
                fontFamily: 'InterTight',
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 20),
            RoleCard(
              title: "Mother",
              iconPath: "assets/images/mother.svg",
              isSelected: selectedRole == "Mother",
              onTap: () => selectRole("Mother"),
            ),
            RoleCard(
              title: "Father",
              iconPath: "assets/images/father.svg",
              isSelected: selectedRole == "Father",
              onTap: () => selectRole("Father"),
            ),
            RoleCard(
              title: "Grand Parent",
              iconPath: "assets/images/grand.svg",
              isSelected: selectedRole == "Grand Parent",
              onTap: () => selectRole("Grand Parent"),
            ),
            RoleCard(
              title: "Care Giver",
              iconPath: "assets/images/caregiver.svg",
              isSelected: selectedRole == "Care Giver",
              onTap: () => selectRole("Care Giver"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size(double.infinity, 58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed:
                  selectedRole != null
                      ? () async {
                        try {
                          final userId = FirebaseAuth.instance.currentUser?.uid;
                          if (userId == null) {
                            throw Exception("User not logged in");
                          }
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .update({'role': selectedRole});
                          Navigator.pushNamed(context, '/baby-registration');
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to save role: $e")),
                          );
                        }
                      }
                      : null,
              child: Text(
                "Next",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'InterTight',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isSelected ? 1.0 : 0.4,
        child: Container(
          width: 345,
          height: 110,
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Color(0xFF111111),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111111),
                    fontFamily: 'InterTight',
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: SvgPicture.asset(iconPath, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
