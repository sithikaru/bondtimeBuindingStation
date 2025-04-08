import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool activityReminders = true;
  bool pushNotifications = false;
  String userFirstName = "User";
  bool editingName = false; // Controls whether the name is in edit mode
  String? _profilePictureUrl; // Null if no profile picture is present

  final TextEditingController _nameController = TextEditingController();

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
          _nameController.text = userFirstName;
          if (data.containsKey('settings')) {
            activityReminders = data['settings']['activityReminders'] ?? true;
            pushNotifications = data['settings']['pushNotifications'] ?? false;
          }
          // Set the profile picture URL if it exists; otherwise, remain null.
          _profilePictureUrl =
              (data.containsKey('profilePicture') &&
                      data['profilePicture'] != null)
                  ? data['profilePicture']
                  : null;
        });
      }
    } catch (e) {
      print("Error loading user settings: $e");
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
      print("Error updating settings: $e");
    }
  }

  Future<void> _updateUserName() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      String updatedName = _nameController.text.trim();
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'firstName': updatedName,
      }, SetOptions(merge: true));

      setState(() {
        userFirstName = updatedName;
        editingName = false;
      });
    } catch (e) {
      print("Error updating name: $e");
    }
  }

  Future<void> _pickProfileImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await _uploadProfileImage(imageFile);
    }
  }

  Future<void> _uploadProfileImage(File imageFile) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final ref = FirebaseStorage.instance.ref().child(
        'profilePictures/$userId.jpg',
      );
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profilePicture': downloadUrl,
      });
      setState(() {
        _profilePictureUrl = downloadUrl;
      });
    } catch (e) {
      print("Error uploading profile picture: $e");
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
            IgnorePointer(
              ignoring: true,
              child: Opacity(
                opacity: 0.5,
                child: customListTile(
                  icon: Icons.workspace_premium,
                  title: 'Manage Subscription (coming soon)',
                  onTap: () {
                    Navigator.pushNamed(context, '/manage_subscription');
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),
            customListTile(
              icon: Icons.message,
              title: 'Contact us',
              onTap: () async {
                final Uri url = Uri.parse('https://linktr.ee/bondtime');
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
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
                _buildProfilePicture(),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      editingName
                          ? TextField(
                            controller: _nameController,
                            style: const TextStyle(
                              fontFamily: 'InterTight',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            onSubmitted: (_) => _updateUserName(),
                          )
                          : Text(
                            userFirstName,
                            style: const TextStyle(
                              fontFamily: 'InterTight',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      const SizedBox(height: 3),
                      const Text(
                        'Edit Your Profile',
                        style: TextStyle(
                          fontFamily: 'InterTight',
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      editingName = true;
                      _nameController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _nameController.text.length),
                      );
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

  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: _pickProfileImage,
      child: CircleAvatar(
        radius: 49,
        // If _profilePictureUrl is set, display it; otherwise, show a solid background color and an icon.
        backgroundImage:
            _profilePictureUrl != null
                ? NetworkImage(_profilePictureUrl!)
                : null,
        backgroundColor: _profilePictureUrl == null ? Colors.grey : null,
        child:
            _profilePictureUrl == null
                ? const Icon(Icons.person, size: 50, color: Colors.white)
                : null,
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

            if (!mounted) return;

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
