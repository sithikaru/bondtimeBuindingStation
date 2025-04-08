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
  // Combined list of all activities instead of separate today/ completed/ past lists.
  List<Map<String, dynamic>> allActivities = [];

  bool isLoading = true;
  String errorMessage = '';

  // Filter dropdown
  String selectedFilter = 'All';
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
      // Get all "activities" documents (each document represents a date key).
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('activities')
              .get();

      List<Map<String, dynamic>> tempActivities = [];

      // Iterate over each date document.
      for (var doc in snapshot.docs) {
        final String dateKey = doc.id;
        final data = doc.data();

        // 1. Process general activities stored in a field (if available).
        if (data.containsKey('activities') && data['activities'] is Map) {
          Map<String, dynamic> activitiesMap = Map<String, dynamic>.from(
            data['activities'],
          );
          activitiesMap.forEach((key, value) {
            final activity = Map<String, dynamic>.from(value);
            activity['activityId'] = key;
            activity['date'] = dateKey;

            // Normalize and set defaults.
            final category =
                (activity['category'] ?? '').toString().toLowerCase();
            activity['category'] = category;
            activity['title'] =
                activity.containsKey('title')
                    ? activity['title']
                    : 'Untitled Activity';
            activity['description'] =
                activity.containsKey('description')
                    ? activity['description']
                    : 'No description available';
            // If not specified, mark as not completed.
            activity['completed'] = activity['completed'] == true;

            tempActivities.add(activity);
          });
        }

        // 2. Process activities from the "completedActivities" subcollection.
        final completedSnapshot =
            await doc.reference.collection('completedActivities').get();
        for (var compDoc in completedSnapshot.docs) {
          final compData = compDoc.data();
          final activity = Map<String, dynamic>.from(compData);
          activity['activityId'] = compDoc.id;
          activity['date'] = dateKey;

          // Normalize and mark as completed.
          final category =
              (activity['category'] ?? '').toString().toLowerCase();
          activity['category'] = category;
          activity['completed'] = true;
          activity['title'] =
              activity.containsKey('title')
                  ? activity['title']
                  : 'Untitled Activity';
          activity['description'] =
              activity.containsKey('description')
                  ? activity['description']
                  : 'No description available';

          tempActivities.add(activity);
        }
      }

      setState(() {
        allActivities = tempActivities;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch activities.';
        isLoading = false;
      });
    }
  }

  // Apply category filtering.
  List<Map<String, dynamic>> get filteredList {
    if (selectedFilter == 'All') return allActivities;
    final key = selectedFilter.toLowerCase().replaceAll(' skills', '');
    return allActivities.where((activity) {
      return activity['category'].toString().contains(key);
    }).toList();
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
                  // Filter Dropdown (top-right aligned)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                  // List of all activities
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
