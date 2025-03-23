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
  // Toggle states and user data
  bool activityReminders = true;
  bool pushNotifications = false;
  String userFirstName = "User";

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
      // // print("Error loading user settings: $e");
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
      // // print("Error updating settings: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Color(0xFFFDFDFD),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Align(
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
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Settings Card with User Profile Section
            Container(
              width: 380,
              height: 328,
              decoration: BoxDecoration(
                color: Color(0xFFFEFEFE),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'General Settings',
                      style: TextStyle(
                        fontFamily: 'InterTight',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    // Profile Section
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 49,
                          backgroundImage: NetworkImage(
                            'https://via.placeholder.com/150',
                          ),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userFirstName, // Fetched user name
                              style: TextStyle(
                                fontFamily: 'InterTight',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Edit Your Profile',
                              style: TextStyle(
                                fontFamily: 'InterTight',
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.edit, color: Colors.black),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Account Settings Section with Toggles
                    Text(
                      'Account Settings',
                      style: TextStyle(fontFamily: 'InterTight', fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Activity Reminders',
                          style: TextStyle(
                            fontFamily: 'InterTight',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Switch(
                          value: activityReminders,
                          onChanged: (value) {
                            setState(() {
                              activityReminders = value;
                            });
                            _updateSettings();
                          },
                          activeColor: Color(0xFF111111),
                          activeTrackColor: Color(0xFFC1C1C1),
                          inactiveThumbColor: Color(0xFF888888),
                          inactiveTrackColor: Color(0xFFC1C1C1),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Push Notifications',
                          style: TextStyle(
                            fontFamily: 'InterTight',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Switch(
                          value: pushNotifications,
                          onChanged: (value) {
                            setState(() {
                              pushNotifications = value;
                            });
                            _updateSettings();
                          },
                          activeColor: Color(0xFF111111),
                          activeTrackColor: Color(0xFFC1C1C1),
                          inactiveThumbColor: Color(0xFF888888),
                          inactiveTrackColor: Color(0xFFC1C1C1),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            // Custom List Tiles for Navigation
            customListTile(
              icon: Icons.workspace_premium,
              title: 'Manage Subscription',
              onTap: () {
                Navigator.pushNamed(context, '/manage_subscription');
              },
            ),
            SizedBox(height: 25),
            customListTile(
              icon: Icons.security,
              title: 'Security',
              onTap: () {
                Navigator.pushNamed(context, '/security');
              },
            ),
            SizedBox(height: 25),
            customListTile(
              icon: Icons.message,
              title: 'Contact us',
              onTap: () {
                Navigator.pushNamed(context, '/contact_us');
              },
            ),
            SizedBox(height: 30),
            // Logout Button
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);
                    await prefs.clear();

                    if (!mounted)
                      return; // ✅ ensures context is still safe to use

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
                      color: Color(0xFF111111),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
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
            ),
          ],
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
          border: Border.all(color: Color(0xFF111111), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.black),
                  SizedBox(width: 15),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'InterTight',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
