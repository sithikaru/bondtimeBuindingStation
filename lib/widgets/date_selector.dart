import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DateSelector extends StatelessWidget {
  final List<String> days;
  final List<String> dates;
  final List<bool> completedDays;
  final int selectedIndex;
  final Function(int) onSelectDay;

  const DateSelector({
    super.key,
    required this.days,
    required this.dates,
    required this.completedDays,
    required this.selectedIndex,
    required this.onSelectDay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(days.length, (index) {
          return GestureDetector(
            onTap: () => onSelectDay(index),
            child: Column(
              children: [
                if (index != selectedIndex)
                  Column(
                    children: [
                      Text(
                        days[index],
                        style: TextStyle(
                          color:
                              index < selectedIndex
                                  ? Color(0xFF111111) // Past days black
                                  : Color(0xFFC1C1C1), // Future days grey
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (completedDays[index])
                        SvgPicture.asset(
                          "assets/icons/tick.svg",
                          width: 9,
                          height: 7.07,
                        )
                      else
                        Text(
                          dates[index],
                          style: TextStyle(
                            color: Color(0xFF111111),
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                if (index == selectedIndex)
                  Container(
                    width: 33,
                    height: 51,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Color(0xFF111111), width: 0.25),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          days[index],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111111),
                          ),
                        ),
                        SizedBox(height: 4),
                        if (completedDays[index])
                          SvgPicture.asset(
                            "assets/icons/tick.svg",
                            width: 9,
                            height: 7.07,
                          )
                        else
                          Text(
                            "0/3",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF111111),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
