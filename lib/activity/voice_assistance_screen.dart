import 'package:bondtime/activity/activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceAssistanceScreen extends StatefulWidget {
  const VoiceAssistanceScreen({super.key});

  @override
  _VoiceAssistanceScreenState createState() => _VoiceAssistanceScreenState();
}

class _VoiceAssistanceScreenState extends State<VoiceAssistanceScreen> {
  FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;
  bool hasCompleted = false;
  bool showPopup = false;

  String guidanceText =
      "Let’s have fun building a tower together! Get ready with some colorful blocks. Don’t worry if they are of different shapes or sizes";

  @override
  void initState() {
    super.initState();

    // Set TTS completion handler
    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
        hasCompleted = true;
      });
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> togglePlayPause() async {
    if (hasCompleted) {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setPitch(1.0);
      await flutterTts.speak(guidanceText);
      setState(() {
        isPlaying = true;
        hasCompleted = false;
      });
    } else if (isPlaying) {
      await flutterTts.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setPitch(1.0);
      await flutterTts.speak(guidanceText);
      setState(() {
        isPlaying = true;
      });
    }
  }

  void togglePopup() {
    setState(() {
      showPopup = !showPopup;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (showPopup) {
          setState(() {
            showPopup = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 30, // Reduced gap between back icon and logo
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              flutterTts.stop();
              Navigator.pop(context);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // SVG Logo
              SvgPicture.asset('assets/icons/bondtime_logo.svg', height: 18),
              // Voice Assistance Text
              Text(
                'Voice Assistance',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            IgnorePointer(
              ignoring: showPopup,
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Center(
                    child: SvgPicture.asset(
                      'assets/icons/voice_assistance.svg',
                      width: 159,
                      height: 106,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      guidanceText,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.skip_previous,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Previous step',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 40),
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              hasCompleted
                                  ? Icons.replay
                                  : (isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow),
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: togglePlayPause,
                          ),
                        ),
                        SizedBox(width: 40),
                        Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.skip_next,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Next step',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: togglePopup,
                    child: Container(
                      width: double.infinity,
                      height: 58,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          'Completed',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
            if (showPopup) ...[
              Container(color: Colors.black.withOpacity(0.5)),
              Center(
                child: Container(
                  width: 344,
                  height: 207,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Complete Activity',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Are you sure you have completed this activity?'),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: togglePopup,
                            style: OutlinedButton.styleFrom(
                              fixedSize: Size(134, 48),
                              side: BorderSide(color: Color(0xFF111111)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'No, Continue',
                              style: TextStyle(color: Color(0xFF111111)),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ActivityScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(134, 48),
                              backgroundColor: Color(0xFF111111),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Yes',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
