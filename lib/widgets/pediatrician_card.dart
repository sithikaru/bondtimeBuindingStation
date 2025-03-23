import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/favorites_provider.dart';
import '../screens/pediatrician_detail_screen.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class PediatricianCard extends StatelessWidget {
  final String name;
  final String title;
  final String imagePath;
  final bool isFavoriteTab; // 🔥 To identify if it's in Favorites Tab

  const PediatricianCard({
    super.key,
    required this.name,
    required this.title,
    required this.imagePath,
    this.isFavoriteTab = false,
  });

  @override
  Widget build(BuildContext context) {
    // Access FavoritesProvider for managing favorites
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFF000000), width: 1),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Color(0xFFF5F5F5),
          margin: EdgeInsets.zero,
          elevation: 3,
          shadowColor: Colors.black.withAlpha(25),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 20.16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF212529),
                              fontFamily: 'InterTight',
                            ),
                          ),
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'InterTight',
                              fontSize: 16.15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
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
                            offset: Offset(0, 4),
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
                SizedBox(height: 15),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Reserve Button
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        Future.delayed(Duration(milliseconds: 100), () {
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
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 25,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        'Reserve',
                        style: TextStyle(
                          fontSize: 16.15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'InterTight',
                        ),
                      ),
                    ),

                    // SMS Button
                    SizedBox(width: 6),
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: IconButton(
                        onPressed: () async {
                          final Uri smsUri = Uri(
                            scheme: 'sms',
                            path: '1234567890',
                          );
                          if (await canLaunchUrl(smsUri)) {
                            await launchUrl(smsUri);
                          } else {
                            logger.e('Could not launch SMS app');
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: SvgPicture.asset(
                          'assets/icons/sms.svg',
                          fit: BoxFit.contain,
                          width: 42,
                          height: 42,
                        ),
                      ),
                    ),

                    // Tel Button
                    SizedBox(width: 6),
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: IconButton(
                        onPressed: () async {
                          final Uri telUri = Uri(
                            scheme: 'tel',
                            path: '1234567890',
                          );
                          if (await canLaunchUrl(telUri)) {
                            await launchUrl(telUri);
                          } else {
                            logger.e('Could not launch Phone app');
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: SvgPicture.asset(
                          'assets/icons/tel.svg',
                          fit: BoxFit.contain,
                          width: 42,
                          height: 42,
                        ),
                      ),
                    ),

                    // If in Favorites Tab, show Heart
                    if (isFavoriteTab) SizedBox(width: 34),
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
