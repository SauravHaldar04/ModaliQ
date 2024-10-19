import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'dart:math';

class QuizFlashcard extends StatefulWidget {
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String correctOption;
  final String explanation;
  final VoidCallback onSubmitted;

  const QuizFlashcard({
    Key? key,
    required this.onSubmitted,
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.correctOption,
    required this.explanation,
  }) : super(key: key);

  @override
  _QuizFlashcardState createState() => _QuizFlashcardState();
}

class _QuizFlashcardState extends State<QuizFlashcard> {
  String? selectedOption;
  late FlipCardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();

    // Make sure the card is always showing the front when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_controller.state!.isFront) {
        _controller.flipcard();
      }
    });
  }

  List<String> _getRandomizedOptions() {
    // Combine options into a list and randomize, ensuring no duplicates
    List<String> options = [
      widget.option1,
      widget.option2,
      widget.option3,
      widget.correctOption
    ];
    options.shuffle(Random());
    return options;
  }

  void _submitAnswer() {
    if (selectedOption != null) {
      _controller.flipcard();
      // Delay next question after flipping animation
      Future.delayed(Duration(milliseconds: 600), () {
        widget
            .onSubmitted(); // Call the parent-provided callback to go to the next question
        selectedOption =
            null; // Reset the selected option for the next question
        _controller.flipcard(); // Reset to front for the next question
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final options =
        _getRandomizedOptions(); // Get randomized options every time build is called

    return FlipCard(
      rotateSide: RotateSide.right,
      controller: _controller,
      frontWidget: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 228, 247, 255).withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 58, 127, 183),
              ),
            ),
            SizedBox(height: 15),
            ...options.map((option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 18,
                            color: const Color.fromARGB(255, 58, 127, 183),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                selectedOption != null ? _submitAnswer : null;
                widget.onSubmitted();
              },
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedOption != null
                    ? const Color.fromARGB(255, 61, 139, 255)
                    : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
      backWidget: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 247, 205).withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: const Color.fromARGB(255, 244, 172, 255), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Text(
                'Correct Answer: ${widget.correctOption}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Explanation:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 5),
            Text(
              widget.explanation,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Implement what happens when "Got It!" is pressed
                _controller.flipcard(); // Flip back to front
              },
              child: Text('Got It!', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 144, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
