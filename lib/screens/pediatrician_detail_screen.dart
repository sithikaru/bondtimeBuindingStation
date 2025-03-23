import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/info_card.dart';
import '../widgets/profile_picture_section.dart';
import '../widgets/action_buttons.dart';

// Changed from StatelessWidget to StatefulWidget
class PediatricianDetailScreen extends StatefulWidget {
  final Map<String, String> pediatricianDetails; // 🔥 Updated to accept details

  const PediatricianDetailScreen({
    super.key,
    required this.pediatricianDetails,
  });

  @override
  State<PediatricianDetailScreen> createState() =>
      _PediatricianDetailScreenState();
}

// Created State Class
class _PediatricianDetailScreenState extends State<PediatricianDetailScreen> {
  // Added State Variable to Track Favorite Status
  bool isFavorite = false;

  // 🔥 NEW: ScrollController and Variables for Opacity and Elevation
  final ScrollController _scrollController = ScrollController();
  double _opacity = 0.0; // Controls AppBar Opacity

  @override
  void initState() {
    super.initState();
    // 🔥 NEW: Listener for Scroll Position
    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      setState(() {
        // 🔥 UPDATED: Gradually increase opacity
        _opacity = (offset / 200).clamp(0, 1);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // 🔥 NEW: Dispose ScrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Extracting pediatrician details from the Map
    final String name = widget.pediatricianDetails['name'] ?? 'Unknown';
    final String title = widget.pediatricianDetails['title'] ?? '';
    final String imagePath =
        widget.pediatricianDetails['imagePath'] ?? 'assets/images/doctor.jpg';

    return Scaffold(
      backgroundColor: Color(0xFFFEFEFE), // Off-White Background
      // Use this to allow body to go behind the AppBar
      extendBodyBehindAppBar: true,

      // 🔥 UPDATED: Transparent AppBar with Dynamic Opacity
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Custom Height
        child: Container(
          color: Colors.white.withAlpha(
            (_opacity * 255).toInt(),
          ), // 🔥 Dynamic Opacity
          child: Stack(
            children: [
              // 🔥 Dynamic Shadow
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(
                          (_opacity * 0.2 * 255).toInt(),
                        ), // Dynamic Shadow
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              // BondTime Logo at Top-Left
              Positioned(
                top: 35,
                left: 20,
                child: SvgPicture.asset(
                  'assets/icons/bondtime-logo.svg',
                  width: 112,
                  height: 22,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(
                    Color(0xFF212529),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              // 🔥 Arrow-Back Button Below the Logo
              Positioned(
                top: 58,
                left: 3,
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/arrow-back.svg',
                    width: 34,
                    height: 34,
                    colorFilter: ColorFilter.mode(
                      Color(0xFF212529), // 🔥 Always Dark Neutral
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),

      // Main Body
      body: SingleChildScrollView(
        controller: _scrollController, // 🔥 NEW: Attach ScrollController
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔥 Profile Picture Section with Dynamic Data
            ProfilePictureSection(imagePath: imagePath, pediatricianName: name),

            // Overlapping Container
            Transform.translate(
              offset: Offset(0, -38), // Cleaner Overlap
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFFEFEFE), // Consistent Background Color
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 🔥 Dynamic Name and Title (Aligned to the Left)
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 20.16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF212529),
                              fontFamily: 'InterTight',
                              height: 1.0,
                            ),
                          ),
                          SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16.15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF5A87FE),
                                fontFamily: 'InterTight',
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20), // Gap
                    // Info Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount =
                              constraints.maxWidth > 600 ? 3 : 2;
                          return GridView.count(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 0,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              InfoCard(
                                title: '200+',
                                subtitle: 'Online Patients',
                                iconPath: 'assets/icons/online-patients.svg',
                              ),
                              InfoCard(
                                title: '30+',
                                subtitle: 'Home Visits',
                                iconPath: 'assets/icons/home-visits.svg',
                              ),
                              InfoCard(
                                title: '2+',
                                subtitle: 'Years Experience',
                                iconPath: 'assets/icons/years-experience.svg',
                              ),
                              InfoCard(
                                title: '12+',
                                subtitle: 'Locations to meet',
                                iconPath: 'assets/icons/locations-to-meat.svg',
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 20),
                    // Action Buttons
                    ActionButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // // Bottom Navigation Bar (Fixed at the Bottom)
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 3,
      //   onTap: (index) {}, items: [],
      // ),
    );
  }
}
