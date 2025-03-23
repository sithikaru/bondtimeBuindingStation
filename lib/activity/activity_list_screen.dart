import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bondtime/activity/activity_card.dart';

class ActivityListScreen extends StatefulWidget {
  const ActivityListScreen({super.key});

  @override
  State<ActivityListScreen> createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  int selectedTabIndex = 0; // 0 = Completed, 1 = Today
  String selectedFilter = 'All';

  // Firestore data
  List<Map<String, dynamic>> allActivities = [];
  Set<String> completedActivityIds = {}; // store just the IDs of completed

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAllActivities();
  }

  Future<void> _fetchAllActivities() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // 1. Fetch *all* user activities from Firestore.
      //    Suppose your schema is:
      //    users -> userId -> collection("allActivities") -> doc(activityId)
      //    This might differ if you're storing them differently.
      final allSnapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection("allActivities")
              .get();

      final List<Map<String, dynamic>> fetchedAll =
          allSnapshot.docs.map((doc) {
            final data = doc.data();
            return {
              "activityId": doc.id,
              "title": data["title"] ?? "No Title",
              "description": data["description"] ?? "No description",
              "category": data["category"] ?? "N/A",
              "timestamp":
                  data["timestamp"] ?? DateTime.now().millisecondsSinceEpoch,
            };
          }).toList();

      // 2. Fetch *completed* activities for the user. You mentioned “past” ones,
      //    but often we store completions by date. E.g.:
      //    users -> userId -> collection("activities") -> doc(dateKey) -> collection("completedActivities")
      //    If you want *all* completed, you might store them differently. For example:
      //    users -> userId -> collection("completedActivities") -> doc(activityId)
      final completedSnapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection("completedActivities")
              .get();

      // We’ll store the IDs so we can easily check if each activity is done
      final Set<String> completedIds =
          completedSnapshot.docs.map((doc) => doc.id).toSet();

      setState(() {
        allActivities = fetchedAll;
        completedActivityIds = completedIds;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch activities: $e';
        isLoading = false;
      });
    }
  }

  // Filter logic
  List<Map<String, dynamic>> get filteredActivities {
    // If no filter, show all
    if (selectedFilter == 'All') {
      return allActivities;
    } else {
      // e.g. filter by "Gross Motor Skills", "Fine Motor Skills", etc.
      return allActivities.where((act) {
        return act["category"]?.toLowerCase().contains(
          selectedFilter.toLowerCase(),
        );
      }).toList();
    }
  }

  // Completed or Today logic
  List<Map<String, dynamic>> get completedList {
    return filteredActivities.where((act) {
      return completedActivityIds.contains(act["activityId"]);
    }).toList();
  }

  List<Map<String, dynamic>> get todayList {
    // For “Today,” you might filter by date or show just those not completed.
    // This is just an example that everything not in “completed” is “today.”
    return filteredActivities.where((act) {
      return !completedActivityIds.contains(act["activityId"]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BondTime', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 12),
          Icon(Icons.settings_outlined, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Column(
                children: [
                  // ------------- Tab row -------------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Tabs
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => selectedTabIndex = 0),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: Text(
                                  "Completed",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        selectedTabIndex == 0
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                    color:
                                        selectedTabIndex == 0
                                            ? Colors.black
                                            : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => selectedTabIndex = 1),
                              child: Text(
                                "Today",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      selectedTabIndex == 1
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  color:
                                      selectedTabIndex == 1
                                          ? Colors.black
                                          : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Filter
                        _buildFilterDropdown(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // ------------- Tab content -------------
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child:
                          selectedTabIndex == 0
                              ? _buildActivityList(completedList)
                              : _buildActivityList(todayList),
                    ),
                  ),
                ],
              ),
    );
  }

  // A reusable widget for the filter button
  Widget _buildFilterDropdown() {
    final List<Map<String, dynamic>> filterOptions = [
      {'label': 'All', 'color': Colors.black},
      {'label': 'Gross Motor Skills', 'color': Colors.blue},
      {'label': 'Fine Motor Skills', 'color': Colors.green},
      {'label': 'Communication Skills', 'color': Colors.amber},
      {'label': 'Sensory Skills', 'color': Colors.pink},
    ];

    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() => selectedFilter = value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFEAEAEA),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedFilter,
              style: const TextStyle(fontSize: 13, color: Colors.black),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: Colors.black,
            ),
          ],
        ),
      ),
      itemBuilder: (BuildContext context) {
        return filterOptions.map((item) {
          return PopupMenuItem<String>(
            value: item['label'],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item['label'], style: const TextStyle(fontSize: 13)),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: item['color'],
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  // A widget that builds out the list of activities. Reuses ActivityCard with your data.
  Widget _buildActivityList(List<Map<String, dynamic>> listData) {
    if (listData.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Text("No activities found"),
        ),
      );
    }

    return Column(
      children: List.generate(listData.length, (index) {
        final activity = listData[index];
        // pick icon based on category, etc.
        String category = activity['category'].toString().toLowerCase();
        String icon;
        switch (category) {
          case 'fine motor':
            icon = 'assets/icons/Asset 1.svg';
            break;
          case 'gross motor':
            icon = 'assets/icons/Asset 2.svg';
            break;
          case 'communication':
            icon = 'assets/icons/Asset 3.svg';
            break;
          case 'sensory':
            icon = 'assets/icons/Asset 4.svg';
            break;
          default:
            icon = 'assets/icons/activity1.svg';
        }

        return Column(
          children: [
            ActivityCard(
              // Notice we pass the entire activity
              activity: activity,
              icon: icon,
              currentPage: index, // or 0 if you have no “pagination”
              index: index,
              totalPages: listData.length,
            ),
            const SizedBox(height: 16),
          ],
        );
      }),
    );
  }
}
