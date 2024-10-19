import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, dynamic>> quizSets = List.generate(10, (index) {
    return {
      'setNumber': 'Quiz Set ${index + 1}',
      'questions': List.generate(10, (questionIndex) {
        return {
          'question': 'Question ${questionIndex + 1} for Quiz Set ${index + 1}',
          'correctOption': 'Option ${questionIndex + 1}A',
          'options': [
            'Option ${questionIndex + 1}A',
            'Option ${questionIndex + 1}B',
            'Option ${questionIndex + 1}C',
            'Option ${questionIndex + 1}D',
          ],
          'details':
              'Detail about the answer for question ${questionIndex + 1} in Quiz Set ${index + 1}.'
        };
      }),
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JEE/NEET Quiz Sets'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: quizSets.length,
          itemBuilder: (context, index) {
            return _buildQuizSetCard(context, quizSets[index]);
          },
        ),
      ),
    );
  }

  // Build Quiz Set Card
  Widget _buildQuizSetCard(BuildContext context, Map<String, dynamic> quizSet) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quizSet['setNumber'],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: quizSet['questions'].length,
              itemBuilder: (context, questionIndex) {
                final questionData = quizSet['questions'][questionIndex];
                return _buildQuestionCard(questionData);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Build Question Card
  Widget _buildQuestionCard(Map<String, dynamic> questionData) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionData['question'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...questionData['options'].map((option) {
              return ListTile(
                title: Text(option),
                leading: Radio(
                  value: option,
                  groupValue: questionData['correctOption'],
                  onChanged: (value) {
                    // Handle option selection (if needed)
                  },
                ),
              );
            }).toList(),
            SizedBox(height: 10),
            Text(
              'Answer Detail: ${questionData['details']}',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
