import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {
  // 🔥 Updated to store both name and imagePath
  final List<Map<String, String>> _favorites = [];

  // 🔥 Getter to access the favorites
  List<Map<String, String>> get favorites => List.unmodifiable(_favorites);

  // 🔥 Add to Favorites (Ensures no duplicates)
  void addFavorite(String name, String imagePath) {
    // Check if already favorited by name
    if (_favorites.every((fav) => fav['name'] != name)) {
      _favorites.add({'name': name, 'imagePath': imagePath});
      notifyListeners();
    }
  }

  // 🔥 Remove from Favorites (If exists in list)
  void removeFavorite(String name) {
    _favorites.removeWhere((fav) => fav['name'] == name);
    notifyListeners();
  }

  // 🔥 Toggle Favorite Status (Uses add and remove methods)
  void toggleFavorite(String name, String imagePath) {
    if (isFavorite(name)) {
      removeFavorite(name);
    } else {
      addFavorite(name, imagePath);
    }
  }

  // 🔥 Check if a pediatrician is favorited
  bool isFavorite(String name) {
    return _favorites.any((fav) => fav['name'] == name);
  }

  // 🔥 Clear All Favorites (Optional Utility)
  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
