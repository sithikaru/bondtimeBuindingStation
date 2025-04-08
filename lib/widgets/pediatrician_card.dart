import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:logger/logger.dart';
import '../providers/favorites_provider.dart';
import '../screens/pediatrician_detail_screen.dart';

var logger = Logger();

class PediatricianCard extends StatelessWidget {
  final String name;
  final String title;
  final String imagePath;
  final bool isFavoriteTab; // To identify if it's in Favorites Tab

  const PediatricianCard({
    super.key,
    required this.name,
    required this.title,
    required this.imagePath,
    this.isFavoriteTab = false,
  });

  // Method to launch the phone dialer using Android's DIAL action.
  Future<void> _launchPhone(String phoneNumber) async {
    if (Platform.isAndroid) {
      try {
        final AndroidIntent intent = AndroidIntent(
          // Use DIAL instead of CALL to let the user confirm the call.
          action: 'android.intent.action.DIAL',
          data: 'tel:$phoneNumber',
        );
        await intent.launch();
      } catch (e) {
        logger.e("Error launching phone dialer on Android: $e");
      }
    } else {
      // Fallback for non-Android platforms.
      final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri, mode: LaunchMode.externalApplication);
      } else {
        logger.e('Could not launch phone app using url_launcher');
      }
    }
  }

  // Method to launch the SMS app using Android's SENDTO action with "smsto:".
  Future<void> _launchSMS(String phoneNumber) async {
    if (Platform.isAndroid) {
      try {
        final AndroidIntent intent = AndroidIntent(
          action: 'android.intent.action.SENDTO',
          data: 'smsto:$phoneNumber',
        );
        await intent.launch();
      } catch (e) {
        logger.e("Error launching SMS intent on Android: $e");
      }
    } else {
      // Fallback for non-Android platforms.
      final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri, mode: LaunchMode.externalApplication);
      } else {
        logger.e('Could not launch SMS app using url_launcher');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access FavoritesProvider for managing favorites.
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF000000), width: 1),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: const Color(0xFFF5F5F5),
          margin: EdgeInsets.zero,
          elevation: 3,
          shadowColor: Colors.black.withAlpha(25),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor Details Row.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name, Title, and Rating.
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20.16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF212529),
                              fontFamily: 'InterTight',
                            ),
                          ),
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontFamily: 'InterTight',
                              fontSize: 16.15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: List.generate(
                              5,
                              (index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Profile Image.
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(imagePath),
                        radius: 35,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Action Buttons Row.
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Reserve Button (navigates to the detail screen).
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PediatricianDetailScreen(
                                      pediatricianDetails: {
                                        'name': name,
                                        'title': title,
                                        'imagePath': imagePath,
                                      },
                                    ),
                              ),
                            );
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 25,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        'Reserve',
                        style: TextStyle(
                          fontSize: 16.15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'InterTight',
                        ),
                      ),
                    ),
                    // SMS Button.
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: IconButton(
                        onPressed: () async {
                          await _launchSMS("1234567890");
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: SvgPicture.asset(
                          'assets/icons/sms.svg',
                          fit: BoxFit.contain,
                          width: 42,
                          height: 42,
                        ),
                      ),
                    ),
                    // Telephone Button.
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: IconButton(
                        onPressed: () async {
                          await _launchPhone("1234567890");
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: SvgPicture.asset(
                          'assets/icons/tel.svg',
                          fit: BoxFit.contain,
                          width: 42,
                          height: 42,
                        ),
                      ),
                    ),
                    // If in Favorites Tab, show Heart Icon for toggling favorite status.
                    if (isFavoriteTab) const SizedBox(width: 34),
                    if (isFavoriteTab)
                      IconButton(
                        icon: Icon(
                          favoritesProvider.isFavorite(name)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              favoritesProvider.isFavorite(name)
                                  ? Colors.red
                                  : Colors.grey,
                          size: 24,
                        ),
                        onPressed: () {
                          favoritesProvider.toggleFavorite(name, imagePath);
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
