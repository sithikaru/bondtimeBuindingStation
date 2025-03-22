import 'dart:async';
import 'package:bondtime/activity/voice_assistance_screen.dart';
import 'package:bondtime/feedback/feedback_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityScreenTwo extends StatefulWidget {
  final int currentPage;
  final Map<String, dynamic> activity;

  const ActivityScreenTwo({
    super.key,
    this.currentPage = 2,
    required this.activity,
  });

  @override
  _ActivityScreenTwoState createState() => _ActivityScreenTwoState();
}

class _ActivityScreenTwoState extends State<ActivityScreenTwo> {
  late int minutes;
  int seconds =
      0; // Start with 0 seconds since we'll set minutes from recommendedDuration
  Timer? timer;
  double progressWidth = 0.0;
  double maxWidth = 344;
  String timerText = '';
  bool isPaused = false;
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    // Initialize minutes using the recommendedDuration from activity.
    // Fallback to 10 if recommendedDuration is not provided.
    minutes = widget.activity["recommendedDuration"] ?? 10;
    timerText = getFormattedTime();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    int totalTimeInSeconds = (minutes * 60) + seconds;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
            isDone = true;
            progressWidth = maxWidth;
            int totalDurationSpent =
                (widget.activity["recommendedDuration"] ?? 10);
            // You can use real tracking later if user pauses/skips

            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => FeedbackScreen(
                      activityId:
                          widget.activity['activityId'] ?? 'activity123',
                      durationSpent: totalDurationSpent,
                    ),
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
        leadingWidth: 30,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: SvgPicture.asset('assets/icons/bondtime_logo.svg', height: 18),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/notifications.svg',
              height: 24,
              width: 24,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
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
            const SizedBox(height: 20),
            SvgPicture.asset(
              'assets/icons/engagement.svg',
              height: 261,
              width: 196,
            ),
            const SizedBox(height: 35),
            Text(
              widget.activity['title'] ??
                  'Engage with your child for ${widget.activity["recommendedDuration"] ?? 10} minutes',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Text(
              widget.activity['description'] ??
                  'Follow the activity instructions for the recommended duration.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              width: 344,
              height: 58,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              VoiceAssistanceScreen(activity: widget.activity),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Audio Guidance',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: togglePauseResume,
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
                      offset: const Offset(0, 10),
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
                      duration: const Duration(seconds: 1),
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
                        style: const TextStyle(
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
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.only(top: 20),
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
                  const SizedBox(width: 5),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
