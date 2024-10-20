import 'package:datahack/global/global_var.dart';
import 'package:datahack/home/ai_generated_page.dart';
import 'package:datahack/resources/database.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
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
  late WebSocketChannel channel;
  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    connectWebSocket();
  }

  void connectWebSocket() {
    channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8765'));
    channel.stream.listen((message) {
      final data = json.decode(message);
      handleServerMessage(data);
    });
  }

  void handleServerMessage(Map<String, dynamic> data) {
    if (data.containsKey('question')) {
      setState(() {
        questions.add(data);
      });
      uploadQuizData(data);
    } else if (data.containsKey('message')) {
      // Handle other messages (e.g., "Quiz finished!")
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(data['message'])));
    }
  }

  Future<void> uploadQuizData(Map<String, dynamic> questionData) async {
    Map<String, String> questionMap = {
      "question": questionData['question'],
      "option1": questionData['options'][0],
      "option2": questionData['options'][1],
      "option3": questionData['options'][2],
      "option4": questionData['options'][3],
    };

    try {
      await databaseService.addQuestionData(questionMap, widget.quizId);
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
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
      onPressed: () {
        // Send quiz parameters to the server
        channel.sink.add(json.encode({
          'grade': widget.grade,
          'subject': widget.subject,
          'topic': widget.topic,
        }));

        // Navigate to the quiz page
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => AIQuizPlay(channel: channel, questions: questions)),
        // );
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
