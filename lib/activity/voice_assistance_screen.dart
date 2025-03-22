import 'package:bondtime/feedback/feedback_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceAssistanceScreen extends StatefulWidget {
  final Map<String, dynamic> activity;

  const VoiceAssistanceScreen({super.key, required this.activity});

  @override
  _VoiceAssistanceScreenState createState() => _VoiceAssistanceScreenState();
}

class _VoiceAssistanceScreenState extends State<VoiceAssistanceScreen> {
  FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;
  bool hasCompleted = false;
  bool showPopup = false;

  late String guidanceText;

  @override
  void initState() {
    super.initState();
    guidanceText = widget.activity['description'] ?? '';
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
      await flutterTts.speak(widget.activity['description']);
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
          leadingWidth: 30,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              flutterTts.stop();
              Navigator.pop(context);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset('assets/icons/bondtime_logo.svg', height: 18),
              const Text(
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
                  const SizedBox(height: 100),
                  Center(
                    child: SvgPicture.asset(
                      'assets/icons/voice_assistance.svg',
                      width: 159,
                      height: 106,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      widget.activity['description'] ?? guidanceText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
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
                              child: const Icon(
                                Icons.skip_previous,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Previous step',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 40),
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
                                offset: const Offset(0, 10),
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
                        const SizedBox(width: 40),
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
                              child: const Icon(
                                Icons.skip_next,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
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
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: const Center(
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
            if (showPopup) ...[
              Container(color: Colors.black.withOpacity(0.5)),
              Center(
                child: Container(
                  width: 344,
                  height: 207,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Complete Activity',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Are you sure you have completed this activity?',
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: togglePopup,
                            style: OutlinedButton.styleFrom(
                              fixedSize: const Size(134, 48),
                              side: const BorderSide(color: Color(0xFF111111)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'No, Continue',
                              style: TextStyle(color: Color(0xFF111111)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => FeedbackScreen(
                                        activityId:
                                            widget.activity['activityId'] ??
                                            'activity123',
                                        durationSpent: 0,
                                      ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(134, 48),
                              backgroundColor: const Color(0xFF111111),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
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
