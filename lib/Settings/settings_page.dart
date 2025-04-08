import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool activityReminders = true;
  bool pushNotifications = false;
  String userFirstName = "User";
  TextEditingController _nameController =
      TextEditingController(); // Controller for name editing

  @override
  void initState() {
    super.initState();
    _loadUserSettings();
  }

  Future<void> _loadUserSettings() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          userFirstName = data['firstName'] ?? "User";
          if (data.containsKey('settings')) {
            activityReminders = data['settings']['activityReminders'] ?? true;
            pushNotifications = data['settings']['pushNotifications'] ?? false;
          }
        });
      }
    } catch (e) {
      // print("Error loading user settings: $e");
    }
  }

  Future<void> _updateSettings() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'settings': {
          'activityReminders': activityReminders,
          'pushNotifications': pushNotifications,
        },
      }, SetOptions(merge: true));
    } catch (e) {
      // print("Error updating settings: $e");
    }
  }

  Future<void> _updateUserName() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'firstName': _nameController.text, // Update with the new name
      }, SetOptions(merge: true));

      // Update the UI with the new name
      setState(() {
        userFirstName = _nameController.text;
      });
    } catch (e) {
      // Handle any error that occurs while updating the name
      // print("Error updating name: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFDFD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Settings',
            style: TextStyle(
              fontFamily: 'InterTight',
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGeneralSettingsCard(),
            const SizedBox(height: 25),
            customListTile(
              icon: Icons.workspace_premium,
              title: 'Manage Subscription',
              onTap: () {
                Navigator.pushNamed(context, '/manage_subscription');
              },
            ),
            const SizedBox(height: 25),
            customListTile(
              icon: Icons.security,
              title: 'Security',
              onTap: () {
                Navigator.pushNamed(context, '/security');
              },
            ),
            const SizedBox(height: 25),
            customListTile(
              icon: Icons.message,
              title: 'Contact us',
              onTap: () {
                Navigator.pushNamed(context, '/contact_us');
              },
            ),
            const SizedBox(height: 30),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettingsCard() {
    return Container(
      width: 380,
      height: 328,
      decoration: BoxDecoration(
        color: const Color(0xFFFEFEFE),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'General Settings',
              style: TextStyle(
                fontFamily: 'InterTight',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const CircleAvatar(
                  radius: 49,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150',
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    userFirstName == "User"
                        ? Text(
                          userFirstName,
                          style: const TextStyle(
                            fontFamily: 'InterTight',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        : TextField(
                          controller: _nameController..text = userFirstName,
                          style: const TextStyle(
                            fontFamily: 'InterTight',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          onSubmitted: (_) => _updateUserName(),
                        ),
                    const Text(
                      'Edit Your Profile',
                      style: TextStyle(
                        fontFamily: 'InterTight',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      userFirstName = "User"; // Make the name field editable
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Account Settings',
              style: TextStyle(fontFamily: 'InterTight', fontSize: 18),
            ),
            const SizedBox(height: 10),
            _buildSwitchTile(
              label: 'Activity Reminders',
              value: activityReminders,
              onChanged: (value) {
                setState(() {
                  activityReminders = value;
                });
                _updateSettings();
              },
            ),
            _buildSwitchTile(
              label: 'Push Notifications',
              value: pushNotifications,
              onChanged: (value) {
                setState(() {
                  pushNotifications = value;
                });
                _updateSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'InterTight',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF111111),
          activeTrackColor: const Color(0xFFC1C1C1),
          inactiveThumbColor: const Color(0xFF888888),
          inactiveTrackColor: const Color(0xFFC1C1C1),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: GestureDetector(
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', false);
            await prefs.clear();

            if (!mounted) {
              return;
            }

            Navigator.pushNamedAndRemoveUntil(
              context,
              '/sign-in',
              (route) => false,
            );
          },
          child: Container(
            width: 380,
            height: 65,
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Log out',
              style: TextStyle(
                fontFamily: 'InterTight',
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 380,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFF111111), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.black),
                  const SizedBox(width: 15),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'InterTight',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
