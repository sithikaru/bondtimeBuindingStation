import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class PediatricianCard extends StatelessWidget {
  final String name;
  final String title;
  final String imagePath;
  final bool isFavoriteTab;

  const PediatricianCard({
    super.key,
    required this.name,
    required this.title,
    required this.imagePath,
    this.isFavoriteTab = false,
  });

  /// Request Phone permission and launch dialer
  Future<void> _makePhoneCall(BuildContext context, String number) async {
    // 1) Request phone permission at runtime
    final status = await Permission.phone.request();
    if (status.isGranted) {
      // 2) If granted, attempt to launch the dialer
      final telUri = Uri(scheme: 'tel', path: number);
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No dialer app found or not set as default.'),
          ),
        );
      }
    } else if (status.isDenied) {
      // The user denied permission (but not permanently)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Phone permission denied.')));
    } else if (status.isPermanentlyDenied) {
      // The user permanently denied permission. Direct them to settings.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Phone permission permanently denied. Please enable it in settings.',
          ),
        ),
      );
      await openAppSettings();
    }
  }

  /// Request SMS permission and launch SMS app
  Future<void> _sendSms(BuildContext context, String number) async {
    // 1) Request SMS permission at runtime
    final status = await Permission.sms.request();
    if (status.isGranted) {
      // 2) If granted, attempt to launch the SMS app
      final smsUri = Uri(scheme: 'sms', path: number);
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No SMS app found or not set as default.'),
          ),
        );
      }
    } else if (status.isDenied) {
      // The user denied permission (but not permanently)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('SMS permission denied.')));
    } else if (status.isPermanentlyDenied) {
      // The user permanently denied permission. Direct them to settings.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'SMS permission permanently denied. Please enable it in settings.',
          ),
        ),
      );
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                // Name/Title Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Title
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

                    // Profile Image
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

                // Action Buttons (Reserve, SMS, Tel, etc.)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Reserve Button
                    ElevatedButton(
                      onPressed: () {
                        // ... possibly navigate somewhere
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
                    const SizedBox(width: 6),

                    // SMS Button
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: IconButton(
                        onPressed: () {
                          // Request SMS permission, then open SMS
                          _sendSms(context, '1234567890');
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
                    const SizedBox(width: 6),

                    // Tel Button
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: IconButton(
                        onPressed: () {
                          // Request Phone permission, then open dialer
                          _makePhoneCall(context, '1234567890');
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

                    // If in Favorites Tab, display extra button, etc.
                    if (isFavoriteTab) const SizedBox(width: 34),
                    if (isFavoriteTab)
                      IconButton(
                        onPressed: () {
                          // handle favorite logic
                        },
                        icon: const Icon(Icons.favorite_border),
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
