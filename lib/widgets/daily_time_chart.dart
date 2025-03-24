import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyTimeChart extends StatefulWidget {
  final int selectedDayIndex;
  final Function(int) onDaySelected;

  const DailyTimeChart({
    super.key,
    required this.selectedDayIndex,
    required this.onDaySelected,
  });

  @override
  _DailyTimeChartState createState() => _DailyTimeChartState();
}

class _DailyTimeChartState extends State<DailyTimeChart> {
  late List<double> timeSpent;

  @override
  void initState() {
    super.initState();
    timeSpent = List.generate(7, (_) => 0.0);
    _fetchTimeSpentData(); // Fetch data when widget is initialized
  }

  // Function to fetch total time spent data for the last 7 days
  Future<void> _fetchTimeSpentData() async {
    final now = DateTime.now();
    final lastSevenDays = List.generate(
      7,
      (index) => now.subtract(Duration(days: index)),
    );

    List<double> fetchedTimeSpent = List.generate(7, (_) => 0.0);

    // Query completed activities for the last 7 days
    for (int i = 0; i < 7; i++) {
      final dayStart = DateTime(
        lastSevenDays[i].year,
        lastSevenDays[i].month,
        lastSevenDays[i].day,
      );
      final dayEnd = dayStart.add(Duration(days: 1));

      // Fetch completed activities for the specific day (no need for completedAt)
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('activities')
              .doc('completedActivities')
              .collection(
                lastSevenDays[i].toString().split(" ")[0],
              ) // Specific day collection
              .get();

      double totalDurationForDay = 0.0;

      // Loop through each completed activity and fetch its recommendedDuration
      for (var doc in querySnapshot.docs) {
        final activityId = doc.id;

        // Fetch the corresponding activity's recommendedDuration
        final activityDoc =
            await FirebaseFirestore.instance
                .collection('activities')
                .doc('activities')
                .collection(
                  'details',
                ) // Assuming activities are stored under details
                .doc(activityId) // Get activity using activityId
                .get();

        final recommendedDuration = activityDoc['recommendedDuration'] ?? 0;
        totalDurationForDay += recommendedDuration.toDouble();
      }

      // Convert total minutes to hours
      fetchedTimeSpent[i] =
          totalDurationForDay / 60; // Convert minutes to hours
    }

    // Update the state with the fetched data
    setState(() {
      timeSpent = fetchedTimeSpent;
    });
    print("Updated timeSpent: $timeSpent");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170, // ✅ Maintained height
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFF111111),
          width: 1,
        ), // ✅ Stroke color
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // **Selected Date and Time Spent**
          Text(
            "Thursday, 20 February", // Example static date, can be dynamic
            style: TextStyle(fontSize: 12, color: Color(0xFFC1C1C1)),
          ),
          SizedBox(height: 4),
          Text(
            _formatTime(
              timeSpent[widget.selectedDayIndex],
            ), // ✅ Formats time correctly
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 12),

          // **Bar Chart**
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 2.0, // Max 2 hours
                backgroundColor: Colors.transparent,
                gridData: FlGridData(
                  show: true, // ✅ Shows grid lines
                  drawHorizontalLine: true, // ✅ Horizontal lines only
                  horizontalInterval: 1, // ✅ Spaced every 1 hour
                  getDrawingHorizontalLine:
                      (value) => FlLine(
                        color: Colors.grey[300]!, // ✅ Light grey grid lines
                        strokeWidth: 1,
                      ),
                ),
                barTouchData: BarTouchData(
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    if (barTouchResponse != null &&
                        barTouchResponse.spot != null &&
                        event is FlTapUpEvent) {
                      int tappedIndex =
                          barTouchResponse.spot!.touchedBarGroupIndex;
                      widget.onDaySelected(tappedIndex);
                    }
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ), // ✅ Hide left labels
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        List<String> days = [
                          "Mo",
                          "Tu",
                          "We",
                          "Th",
                          "Fr",
                          "Sa",
                          "Su",
                        ];
                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            days[value.toInt()],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color:
                                  widget.selectedDayIndex == value.toInt()
                                      ? Colors.black
                                      : Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 22, // ✅ Adjusted spacing
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Text(
                            "${value.toInt()}h",
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: timeSpent[index],
                        color:
                            widget.selectedDayIndex == index
                                ? Colors.black
                                : Colors.grey[400],
                        width: 30, // ✅ Set bar width to 30px
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6), // ✅ Rounded only on top
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Formats time correctly (1h 30m instead of 0.5h)
  String _formatTime(double hours) {
    int h = hours.floor();
    int minutes = ((hours - h) * 60).round();
    if (h > 0 && minutes > 0) {
      return "$h h $minutes m";
    } else if (h > 0) {
      return "$h h";
    } else {
      return "$minutes m";
    }
  }
}
