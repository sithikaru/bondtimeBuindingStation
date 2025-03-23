import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../data/pediatricians.dart';
import '../widgets/pediatrician_card.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/custom_app_bar.dart';

var logger = Logger();

class PediatricianListScreen extends StatefulWidget {
  const PediatricianListScreen({super.key});

  @override
  PediatricianListScreenState createState() => PediatricianListScreenState();
}

class PediatricianListScreenState extends State<PediatricianListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 🔥 Added FocusNode for Search Bar
  final FocusNode _searchFocusNode = FocusNode();

  // 🔥 Search Query State
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // 🔥 Prevent Search Bar from Auto-Focusing on Resume
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_searchFocusNode.hasFocus) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchFocusNode.dispose(); // 🔥 Dispose the FocusNode
    super.dispose();
  }

  // 🔥 Filtered Pediatricians List
  List<Map<String, String>> get _filteredPediatricians {
    if (_searchQuery.isEmpty) {
      return pediatricians;
    }
    return pediatricians
        .where(
          (pediatrician) => pediatrician['name']!.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 Wrapped with GestureDetector to unfocus when tapping outside
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFFFEFEFE),
        // AppBar with BondTime Logo
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: CustomAppBar(showBackButton: true),
        ),

        // Main Body with Tabs
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomSearchBar(
                searchFocusNode: _searchFocusNode,
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),
            ),

            // Tab Bar
            Transform.translate(
              offset: Offset(-30, 0),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Color(0xFFC9C9C9),
                indicator: BoxDecoration(),
                labelStyle: TextStyle(
                  fontFamily: 'InterTight',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                labelPadding: EdgeInsets.only(right: 15),
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                tabs: [Tab(text: 'Suggested'), Tab(text: 'Favorites')],
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Suggested
                  ListView.builder(
                    itemCount: _filteredPediatricians.length,
                    itemBuilder: (context, index) {
                      final pediatrician = _filteredPediatricians[index];
                      return PediatricianCard(
                        name: pediatrician['name']!,
                        title: pediatrician['title']!,
                        imagePath: pediatrician['image']!,
                      );
                    },
                  ),

                  // Favorites
                  Consumer<FavoritesProvider>(
                    builder: (context, favoritesProvider, child) {
                      final favorites = favoritesProvider.favorites;
                      if (favorites.isEmpty) {
                        return Center(child: Text('No Favorites Yet'));
                      }

                      return ListView.builder(
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          final favorite = favorites[index];
                          final name = favorite['name'] ?? 'Unknown';
                          final imagePath =
                              favorite['imagePath'] ??
                              'assets/images/doctor.jpg';

                          return PediatricianCard(
                            name: name,
                            title: 'Consultant Pediatrician',
                            imagePath: imagePath,
                            isFavoriteTab: true,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
