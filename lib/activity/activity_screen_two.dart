import 'dart:async';
import 'package:bondtime/activity/voice_assistance_screen.dart';
import 'package:bondtime/feedback/feedback_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityScreenTwo extends StatefulWidget {
  final int currentPage;

  const ActivityScreenTwo({
    super.key,
    this.currentPage = 2,
    required Map<String, dynamic> activity,
  }); // Default to page 2

  @override
  _ActivityScreenTwoState createState() => _ActivityScreenTwoState();
}

class _ActivityScreenTwoState extends State<ActivityScreenTwo> {
  int minutes = 0;
  int seconds = 10;
  Timer? timer;
  double progressWidth = 0.0;
  double maxWidth = 344;
  String timerText = '0:10';
  bool isPaused = false;
  bool isDone = false; // New flag to track if the timer is done

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    int totalTimeInSeconds = (minutes * 60) + seconds;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          if (minutes > 0) {
            minutes--;
            seconds = 59;
          } else {
            timer.cancel();
            timerText = "Done";
            isDone = true; // Set the flag to true when done
            progressWidth = maxWidth;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FeedbackScreen(activityId: "activity123"),
              ),
            );
          }
        }

        if (timerText != "Done") {
          timerText = getFormattedTime();
        }

        int remainingTime = (minutes * 60) + seconds;
        progressWidth = maxWidth * (1 - (remainingTime / totalTimeInSeconds));
      });
    });
  }

  void togglePauseResume() {
    // Only allow pause/resume if the timer is not done
    if (!isDone) {
      setState(() {
        if (isPaused) {
          startTimer();
          isPaused = false;
        } else {
          timer?.cancel();
          isPaused = true;
          timerText = "Paused";
        }
      });
    }
  }

  String getFormattedTime() {
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = seconds.toString().padLeft(2, '0');
    return '$formattedMinutes:$formattedSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 30, // Reduced padding between back arrow and logo
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: SvgPicture.asset(
          'assets/icons/bondtime_logo.svg', // Path to your SVG logo
          height: 18, // Set height to 22px
        ),
        actions: [
          // Notifications Icon - Same as ActivityScreen
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/notifications.svg',
              height: 24,
              width: 24,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          // Settings Icon - Same as ActivityScreen
          Padding(
            padding: const EdgeInsets.only(
              right: 10.0,
            ), // Same padding as ActivityScreen
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/settings.svg',
                height: 24,
                width: 24,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            SvgPicture.asset(
              'assets/icons/engagement.svg',
              height: 261,
              width: 196,
            ),
            SizedBox(height: 35),
            Text(
              'Spend 10 minutes engaging with your child',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),

            // Audio Guidance Button
            SizedBox(
              width: 344,
              height: 58,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VoiceAssistanceScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Audio Guidance',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 15),

            // Timer Button with Animated Progress Bar
            GestureDetector(
              onTap: togglePauseResume, // Toggle pause and resume on tap
              child: Container(
                width: maxWidth,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(seconds: 1),
                      width: progressWidth,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    Center(
                      child: Text(
                        timerText,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // Page Indicator
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: widget.currentPage == 1 ? 20 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color:
                          widget.currentPage == 1
                              ? Colors.black
                              : Colors.grey[400],
                      borderRadius: BorderRadius.circular(
                        widget.currentPage == 1 ? 20 : 10,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: widget.currentPage == 2 ? 20 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color:
                          widget.currentPage == 2
                              ? Colors.black
                              : Colors.grey[400],
                      borderRadius: BorderRadius.circular(
                        widget.currentPage == 2 ? 20 : 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
