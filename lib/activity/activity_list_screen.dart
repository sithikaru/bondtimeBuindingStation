import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bondtime/activity/activity_Listcard.dart';

class ActivityListScreen extends StatefulWidget {
  const ActivityListScreen({super.key});

  @override
  State<ActivityListScreen> createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  int selectedTabIndex = 0;
  String selectedFilter = 'All';

  List<Map<String, dynamic>> todayActivities = [];
  List<Map<String, dynamic>> completedActivities = [];
  List<Map<String, dynamic>> pastActivities = [];

  bool isLoading = true;
  String errorMessage = '';

  final List<Map<String, dynamic>> filterOptions = [
    {'label': 'All', 'color': Colors.black},
    {'label': 'Gross Motor Skills', 'color': Colors.blue},
    {'label': 'Fine Motor Skills', 'color': Colors.green},
    {'label': 'Communication Skills', 'color': Colors.amber},
    {'label': 'Sensory Skills', 'color': Colors.pink},
  ];

  @override
  void initState() {
    super.initState();
    fetchActivitiesFromFirestore();
  }

  Future<void> fetchActivitiesFromFirestore() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final now = DateTime.now();
      final todayKey = now.toIso8601String().split('T').first;

      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('activities')
              .get();

      List<Map<String, dynamic>> today = [];
      List<Map<String, dynamic>> completed = [];
      List<Map<String, dynamic>> past = [];

      for (var doc in snapshot.docs) {
        String dateKey = doc.id;
        final data = doc.data();

        if (data['activities'] == null || data['activities'] is! Map) continue;

        Map<String, dynamic> activities = Map<String, dynamic>.from(
          data['activities'],
        );

        activities.forEach((key, value) {
          final activity = Map<String, dynamic>.from(value);
          activity['activityId'] = key;
          activity['date'] = dateKey;

          final category =
              (activity['category'] ?? '').toString().toLowerCase();
          activity['category'] = category;

          final isCompleted = activity['completed'] == true;

          if (dateKey == todayKey) {
            today.add(activity);
          } else {
            if (isCompleted) {
              completed.add(activity);
            } else {
              past.add(activity);
            }
          }
        });
      }

      setState(() {
        todayActivities = today;
        completedActivities = completed;
        pastActivities = past;
        isLoading = false;
      });
    } catch (e) {
      // print("Error fetching activities: $e");
      setState(() {
        errorMessage = 'Failed to fetch activities.';
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get filteredList {
    List<Map<String, dynamic>> baseList;

    if (selectedTabIndex == 0) {
      baseList = todayActivities;
    } else if (selectedTabIndex == 1) {
      baseList = completedActivities;
    } else {
      baseList = pastActivities;
    }

    if (selectedFilter == 'All') return baseList;

    final key = selectedFilter.toLowerCase().replaceAll(' skills', '');

    return baseList.where((a) {
      return a['category'].toString().contains(key);
    }).toList();
  }

  String getTabTitle(int index) {
    switch (index) {
      case 0:
        return "Today";
      case 1:
        return "Completed";
      case 2:
        return "Past Activities";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              : Column(
                children: [
                  // Tabs and Filter Row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Tab Selector
                        Row(
                          children: List.generate(3, (index) {
                            return GestureDetector(
                              onTap:
                                  () =>
                                      setState(() => selectedTabIndex = index),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: Text(
                                  getTabTitle(index),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        selectedTabIndex == index
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                    color:
                                        selectedTabIndex == index
                                            ? Colors.black
                                            : Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        // Filter Dropdown
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            setState(() => selectedFilter = value);
                          },
                          itemBuilder: (context) {
                            return filterOptions.map((item) {
                              return PopupMenuItem<String>(
                                value: item['label'],
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item['label'],
                                      style: const TextStyle(fontSize: 13),
                                    ),
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
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAEAEA),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  selectedFilter,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Content
                  Expanded(
                    child:
                        filteredList.isEmpty
                            ? const Center(child: Text("No activities found"))
                            : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                final activity = filteredList[index];

                                String icon;
                                switch (activity['category']) {
                                  case 'fine motor':
                                    icon = 'assets/images/Asset1.svg';
                                    break;
                                  case 'gross motor':
                                    icon = 'assets/images/Asset2.svg';
                                    break;
                                  case 'communication':
                                    icon = 'assets/images/Asset3.svg';
                                    break;
                                  case 'sensory':
                                    icon = 'assets/images/Asset4.svg';
                                    break;
                                  default:
                                    icon = 'assets/images/Asset1.svg';
                                }

                                return Column(
                                  children: [
                                    Activity_Listcard(
                                      activity: activity,
                                      icon: icon,
                                      currentPage: index,
                                      index: index,
                                      totalPages: filteredList.length,
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}
