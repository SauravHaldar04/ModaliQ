import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class QuizFlashcard extends StatefulWidget {
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String correctOption;
  final String explanation;
  final VoidCallback onSubmitted;
// User's last name

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
  late Timer _timer;
  int _remainingTime = 600; // 10 minutes = 600 seconds
  int _elapsedSeconds = 0;
  Stopwatch _stopwatch = Stopwatch();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();
    _startTimer();
    _startStopwatch();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
        _stopwatch.stop();
        _submitAnswer();
      }
    });
  }

  void _startStopwatch() {
    _stopwatch.start();
  }

  void _stopTimer() {
    _timer.cancel();
    _stopwatch.stop();
    _elapsedSeconds = _stopwatch.elapsed.inSeconds;
  }

  void _submitAnswer() {
    if (selectedOption != null) {
      _stopTimer();
      _controller.flipcard();
      _calculatePointsAndSave();
      widget.onSubmitted();
    }
  }

  void _calculatePointsAndSave() async {
    int points = _calculatePoints(
        selectedOption == widget.correctOption, _elapsedSeconds);
    final firstName = await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) => value.data()!['firstName']);
    final lastName = await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) => value.data()!['lastName']);
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'points': FieldValue.increment(points),
    });
    // Save to Firestore
    await FirebaseFirestore.instance.collection('contestTime').add({
      'firstName': firstName,
      'lastName': lastName,
      'question': widget.question,
      'timeTaken': _elapsedSeconds,
      'points': points,
      'correct': selectedOption == widget.correctOption,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  int _calculatePoints(bool isCorrect, int timeTaken) {
    if (!isCorrect) {
      return 1; // Minimum points if the answer is wrong
    }

    if (timeTaken < 10) {
      return 10;
    } else if (timeTaken < 20) {
      return 9;
    } else if (timeTaken < 30) {
      return 8;
    } else if (timeTaken < 45) {
      return 7;
    } else if (timeTaken < 60) {
      return 6;
    } else if (timeTaken < 90) {
      return 5;
    } else if (timeTaken < 120) {
      return 4;
    } else if (timeTaken < 180) {
      return 3;
    } else if (timeTaken < 240) {
      return 2;
    } else {
      return 1; // Minimum points for taking too long
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Time Remaining: ${_formatTime(_remainingTime)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
        Expanded(
          child: FlipCard(
            rotateSide: RotateSide.right,
            controller: _controller,
            frontWidget: _buildFrontCard(),
            backWidget: _buildBackCard(),
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Widget _buildFrontCard() {
    return Container(
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
          _buildOptions(),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              widget.onSubmitted();
              selectedOption != null ? _submitAnswer : null;
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
    );
  }

  Widget _buildOptions() {
    final options = [
      widget.option1,
      widget.option2,
      widget.option3,
      widget.correctOption
    ];
    return Column(
      children: options.map((option) {
        return Padding(
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
        );
      }).toList(),
    );
  }

  Widget _buildBackCard() {
    return Container(
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
              _controller.flipcard(); // Flip back to front
            },
            child: Text('Got It!', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
