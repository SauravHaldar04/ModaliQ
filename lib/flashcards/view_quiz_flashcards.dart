import 'package:datahack/flashcards/view_contest_quiz_flashcard_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'dart:async';

class QuizTestPage extends StatefulWidget {
  final List<QuizFlashcard> quizFlashcards;

  const QuizTestPage({Key? key, required this.quizFlashcards})
      : super(key: key);

  @override
  _QuizTestPageState createState() => _QuizTestPageState();
}

class _QuizTestPageState extends State<QuizTestPage> {
  int currentQuestionIndex = 0;
  late Timer _timer;
  int _remainingTime = 600; // 10 minutes = 600 seconds
  String? selectedOption;
  late FlipCardController _controller;
  bool isAnswerSubmitted = false;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
        _submitAnswer();
      }
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  void _submitAnswer() {
    if (selectedOption != null) {
      _stopTimer();
      _calculatePerformance();
      _controller.flipcard();
      setState(() {
        isAnswerSubmitted = true;
      });
    }
  }

  void _calculatePerformance() async {
    try {
      // Get the current user's ID
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // Fetch the user's first name and last name
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Check if user data exists and extract firstName and lastName
      if (userDoc.exists) {
        final userData = userDoc.data();
        final firstName = userData?['firstName'] ?? 'Unknown';
        final lastName = userData?['lastName'] ?? 'Unknown';
        final quizFlashcard = widget.quizFlashcards[currentQuestionIndex];

        // Save the quiz result to the users collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('quizResults')
            .add({
          'firstName': firstName,
          'lastName': lastName,
          'userId': userId,
          'question': quizFlashcard.question,
          'selectedOption': selectedOption,
          'correctOption': quizFlashcard.correctOption,
          'timeTaken': 600 - _remainingTime,
          'isCorrect': selectedOption == quizFlashcard.correctOption,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error saving quiz result: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _nextQuestion() {
    setState(() {
      if (currentQuestionIndex < widget.quizFlashcards.length - 1) {
        currentQuestionIndex++;
        selectedOption = null;
        isAnswerSubmitted = false;
        _remainingTime = 600; // Reset timer for next question
        _controller.flipcard(); // Flip back to front for the new question
        _startTimer(); // Restart timer for next question
      } else {
        // Optionally handle the end of the quiz
        print('Quiz Completed!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentFlashcard = widget.quizFlashcards[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Quiz Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                frontWidget: _buildFrontCard(currentFlashcard),
                backWidget: _buildBackCard(currentFlashcard),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isAnswerSubmitted ? _nextQuestion : null,
              child: Text('Next Question'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Widget _buildFrontCard(QuizFlashcard flashcard) {
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
            flashcard.question,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 58, 127, 183),
            ),
          ),
          SizedBox(height: 15),
          _buildOptions(flashcard),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              _submitAnswer();
            },
            child: Text('Submit', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedOption != null
                  ? const Color.fromARGB(255, 61, 139, 255)
                  : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          if (isAnswerSubmitted)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Answer Submitted!',
                style: TextStyle(color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOptions(QuizFlashcard flashcard) {
    final options = [
      flashcard.option1,
      flashcard.option2,
      flashcard.option3,
      flashcard.correctOption,
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

  Widget _buildBackCard(QuizFlashcard flashcard) {
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
              'Correct Answer: ${flashcard.correctOption}',
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
            flashcard.explanation ?? 'No explanation provided.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _controller.flipcard(); // Flip back to front for next question
            },
            child: Text('Back to Question'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
