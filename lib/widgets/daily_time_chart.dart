import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyTimeChart extends StatelessWidget {
  final List<double> timeSpent;
  final int selectedDayIndex;
  final Function(int) onDaySelected;

  const DailyTimeChart({
    super.key,
    required this.timeSpent,
    required this.selectedDayIndex,
    required this.onDaySelected,
  });

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
              timeSpent[selectedDayIndex],
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
                      onDaySelected(tappedIndex);
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
                                  selectedDayIndex == value.toInt()
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
                            selectedDayIndex == index
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
