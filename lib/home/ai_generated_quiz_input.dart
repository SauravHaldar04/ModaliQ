import 'package:datahack/global/global_var.dart';
import 'package:datahack/home/ai_generated_page.dart';
import 'package:datahack/resources/database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AIQuizInputPage extends StatefulWidget {
  final String quizId;
  final String grade;
  final String subject;
  final String topic;

  AIQuizInputPage({
    Key? key,
    required this.quizId,
    required this.grade,
    required this.subject,
    required this.topic,
  }) : super(key: key);

  @override
  State<AIQuizInputPage> createState() => _AIQuizInputPageState();
}

class _AIQuizInputPageState extends State<AIQuizInputPage> {
  DatabaseService databaseService = DatabaseService();

  Future<void> uploadQuizData(String question, String option1, String option2,
      String option3, String option4) async {
    Map<String, String> questionMap = {
      "question": question,
      "option1": option1,
      "option2": option2,
      "option3": option3,
      "option4": option4
    };

    try {
      await databaseService.addQuestionData(questionMap, widget.quizId);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Quiz Generator'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildQuizInfoCard(),
              SizedBox(height: 20),
              _buildPlayQuizButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizInfoCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.deepPurpleAccent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quiz Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(height: 20),
          _buildInfoRow(Icons.school, 'Grade', widget.grade),
          SizedBox(height: 10),
          _buildInfoRow(Icons.subject, 'Subject', widget.subject),
          SizedBox(height: 10),
          _buildInfoRow(Icons.topic, 'Topic', widget.topic),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurpleAccent, size: 24),
        SizedBox(width: 10),
        Text(
          '$label:',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
        SizedBox(width: 10),
        Text(
          value,
          style: TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildPlayQuizButton() {
    return ElevatedButton(
      onPressed: () async {
        final response = await http.post(
          Uri.parse('${GlobalVariables.Url}/quiz'),
          body: json.encode(<String, dynamic>{
            'grade': widget.grade,
            'subject': widget.subject,
            'topic': widget.topic,
          }),
          headers: <String, String>{'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) {
          print(jsonDecode(response.body));
          uploadQuizData(
            jsonDecode(response.body)[0]['question'],
            jsonDecode(response.body)[0]['correct_answer'],
            jsonDecode(response.body)[0]["incorrect_answers"][0],
            jsonDecode(response.body)[0]["incorrect_answers"][1],
            jsonDecode(response.body)[0]["incorrect_answers"][2],
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AIQuizPlay()),
          );
        } else {
          print("Error");
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.play_arrow, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Play Quiz',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
