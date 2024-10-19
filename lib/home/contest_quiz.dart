import 'package:datahack/core/utils/list_of_contest_questions.dart';
import 'package:datahack/flashcards/view_quiz_flashcard_page.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, dynamic>> quizSets = List.generate(10, (index) {
    return {
      'setNumber': 'Quiz Set ${index + 1}',
      'questions': List.generate(10, (questionIndex) {
        return {
          'question': contestQuizzes[questionIndex]['question'],
          'correctOption': contestQuizzes[questionIndex]['correctOption'],
          'option1': contestQuizzes[questionIndex]['option1'],
          'option2': contestQuizzes[questionIndex]['option2'],
          'option4': contestQuizzes[questionIndex]['option4'],
          'explanation': contestQuizzes[questionIndex]['explanation'],
        };
      }),
    };
  });

  List<Map<String, dynamic>> selectedQuizzes = [];
  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _getRandomQuizzes();
  }

  void _getRandomQuizzes() {
    Random random = Random();
    Set<int> indices = {};

    while (indices.length < 10) {
      indices.add(random.nextInt(quizSets.length));
    }

    selectedQuizzes = indices.map((index) => quizSets[index]).toList();

    for (var quizSet in selectedQuizzes) {
      quizSet['questions'].shuffle();
    }
  }

  void _goToNextQuestion() {
    if (currentQuestionIndex < selectedQuizzes.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _showQuizCompletedDialog();
    }
  }

  void _showQuizCompletedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Completed!'),
        content: const Text('You have answered all the questions.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (selectedQuizzes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final questionData = selectedQuizzes[currentQuestionIndex]['questions'][0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('JEE/NEET Quiz Flashcards'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 100),
        child: QuizFlashcard(
          question: questionData['question'],
          option1: questionData['option1'],
          option2: questionData['option2'],
          option3: questionData['option4'],
          correctOption: questionData['correctOption'],
          explanation: questionData['explanation'],
          onSubmitted: _goToNextQuestion,
        ),
      ),
    );
  }
}
