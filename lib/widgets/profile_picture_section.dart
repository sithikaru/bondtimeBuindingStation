import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

class ProfilePictureSection extends StatelessWidget {
  final String imagePath;
  final String pediatricianName;

  const ProfilePictureSection({
    super.key,
    required this.imagePath,
    required this.pediatricianName,
  });

  @override
  Widget build(BuildContext context) {
    // Debug print to check the image path
    return Container(
      width: double.infinity,
      height: 323,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Stack(
        children: [
          // Online Status Badge
          Positioned(
            left: 20,
            bottom: 40,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 10),
                  SizedBox(width: 5),
                  Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontFamily: 'InterTight',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Rating Badge
          Positioned(
            left: 100,
            bottom: 40,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14),
                  SizedBox(width: 5),
                  Text(
                    '5.0',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontFamily: 'InterTight',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Favorite Button using Consumer<FavoritesProvider>
          Positioned(
            right: 20,
            bottom: 40,
            child: Consumer<FavoritesProvider>(
              builder: (context, favoritesProvider, child) {
                bool isFavorite = favoritesProvider.isFavorite(
                  pediatricianName,
                );

                return IconButton(
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border, // Toggle Icon
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    favoritesProvider.toggleFavorite(
                      pediatricianName,
                      imagePath,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
