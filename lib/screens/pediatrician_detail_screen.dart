import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/info_card.dart';
import '../widgets/profile_picture_section.dart';
import '../widgets/action_buttons.dart';

class PediatricianDetailScreen extends StatefulWidget {
  final Map<String, String> pediatricianDetails; // Accept details dynamically

  const PediatricianDetailScreen({Key? key, required this.pediatricianDetails})
    : super(key: key);

  @override
  State<PediatricianDetailScreen> createState() =>
      _PediatricianDetailScreenState();
}

class _PediatricianDetailScreenState extends State<PediatricianDetailScreen> {
  // State variable tracking the scroll for AppBar opacity
  final ScrollController _scrollController = ScrollController();
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      setState(() {
        _opacity = (offset / 200).clamp(0.0, 1.0);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Extract pediatrician details from the provided Map
    final String name = widget.pediatricianDetails['name'] ?? 'Unknown';
    final String title = widget.pediatricianDetails['title'] ?? '';
    final String imagePath =
        widget.pediatricianDetails['imagePath'] ?? 'assets/images/doctor.jpg';

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: Colors.white.withAlpha((_opacity * 255).toInt()),
          child: Stack(
            children: [
              // Dynamic Shadow based on opacity
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(
                          (_opacity * 0.2 * 255).toInt(),
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              // BondTime Logo (SVG)
              Positioned(
                top: 35,
                left: 20,
                child: SvgPicture.asset(
                  'assets/icons/bondtime-logo.svg',
                  width: 112,
                  height: 22,
                  fit: BoxFit.contain,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF212529),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              // Arrow Back Button (SVG)
              Positioned(
                top: 58,
                left: 3,
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/arrow-back.svg',
                    width: 34,
                    height: 34,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF212529),
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
      body: SingleChildScrollView(
        controller: _scrollController, // Attach ScrollController
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Picture Section with the doctor’s image and name
            ProfilePictureSection(imagePath: imagePath, pediatricianName: name),
            // Overlapping container below the profile section
            Transform.translate(
              offset: const Offset(0, -38),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEFEFE),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Doctor name and title
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20.16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF212529),
                              fontFamily: 'InterTight',
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              title,
                              style: const TextStyle(
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
                    const SizedBox(height: 20),
                    // Info Cards in a grid layout
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
                            physics: const NeverScrollableScrollPhysics(),
                            children: const [
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
                    const SizedBox(height: 20),
                    // Action Buttons (e.g., call, SMS)
                    const ActionButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
