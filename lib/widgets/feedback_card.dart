import 'package:flutter/material.dart';

class FeedbackCard extends StatefulWidget {
  final String question;
  final VoidCallback onNext;
  final bool isLast;

  const FeedbackCard({
    required this.question,
    required this.onNext,
    this.isLast = false,
    super.key,
  });

  @override
  State<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  int selectedRating = 0; // Store selected rating

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 368, // Set width
        height: 484, // Set height
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.65), // Updated corner radius
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.question,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRating = index + 1;
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          selectedRating == index + 1
                              ? Colors.black
                              : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Text(
                      "${index + 1}",
                      style: TextStyle(
                        color:
                            selectedRating == index + 1
                                ? Colors.white
                                : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("it was challenging"), Text("they loved it")],
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "your thoughts?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedRating == 0 ? Colors.grey : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed:
                    selectedRating == 0
                        ? null
                        : widget.onNext, // Disabled if no rating selected
                child: Text(
                  widget.isLast ? "Done" : "Next",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
