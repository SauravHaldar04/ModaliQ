import 'package:datahack/global/global_var.dart';
import 'package:datahack/home/ai_generated_page.dart';
import 'package:datahack/resources/database.dart';
import 'package:datahack/widgets/blue_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:uuid/uuid.dart';

class AIQuizInputPage extends StatefulWidget {
  String quizId;
  String grade;
  String subject;
  String topic;

  AIQuizInputPage({
    super.key,
    required this.quizId,
    required this.grade,
    required this.subject,
    required this.topic,
  });

  @override
  State<AIQuizInputPage> createState() => _AIQuizInputPageState();
}

class _AIQuizInputPageState extends State<AIQuizInputPage> {
  List<Map<String, dynamic>> topics = [];
  DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    uploadQuizData(String question, String option1, String option2,
        String option3, String option4) async {
      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4
      };

      print("${widget.quizId}");
      databaseService.addQuestionData(questionMap, widget.quizId).then((value) {
        question = "";
        option1 = "";
        option2 = "";
        option3 = "";
        option4 = "";
        setState(() {});
      }).catchError((e) {
        print(e);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter Quiz Details',
          style: TextStyle(
              color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration:
              const BoxDecoration(gradient: GlobalVariables.primaryGradient),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16.0),
                BlueButton(
                  onTap: () async {
                    final response = await http.post(
                      Uri.parse('${GlobalVariables.Url}/quiz'),
                      body: json.encode(<String, dynamic>{
                        'grade': widget.grade,
                        'subject': widget.subject,
                        'topic': widget.topic,
                      }),
                      headers: <String, String>{
                        'Content-Type': 'application/json'
                      },
                    );
                    if (response.statusCode == 200) {
                      print(jsonDecode(response.body));
                      // Process the received data
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
                  text: 'Generate Quiz',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
