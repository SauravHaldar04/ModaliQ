import 'package:datahack/home/ai_generated_quiz_input.dart';
import 'package:datahack/resources/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';

class CreateAIQuiz extends StatefulWidget {
  @override
  _CreateAIQuizState createState() => _CreateAIQuizState();
}

class _CreateAIQuizState extends State<CreateAIQuiz> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String? grade;
  String? subject;
  String? topic;
  late DatabaseService databaseService;
  bool isLoading = false;
  String? quizId;

  @override
  void initState() {
    super.initState();
    databaseService = DatabaseService(uid: auth.currentUser!.uid);
  }

  // List of options
  List<String> grades = ['11th', '12th'];
  List<String> subjects = [
    'Maths',
    'Physics',
    'Chemistry',
    'Biology',
    'English'
  ];

  createQuiz() {
    quizId = Uuid().v1();
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> quizData = {
        "grade": grade!,
        "subject": subject!,
        "topic": topic!,
        "id": quizId!,
      };

      databaseService.addQuizData(quizData, quizId!).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AIQuizInputPage(
                  quizId: quizId!,
                  grade: grade!,
                  subject: subject!,
                  topic: topic!)),
        );
      }).catchError((error) {
        print('Error in createQuiz: $error');
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6448FE), Color(0xFF5FC6FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create AI Quiz',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Generate a personalized quiz with AI',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Student Grade',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 93,
                              child: _buildDropdown(
                                'Grade',
                                grade,
                                grades,
                                (String? newValue) {
                                  setState(() {
                                    grade = newValue;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Subject',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                                child: _buildDropdown(
                              'Subject',
                              subject,
                              subjects,
                              (String? newValue) {
                                setState(() {
                                  subject = newValue;
                                });
                              },
                            )),
                          ],
                        ),
                        SizedBox(height: 20),
                        _buildTextField('Topic'),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              createQuiz();
                            }
                          },
                          child: Text('Generate Quiz'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF6448FE),
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items,
      Function(String?) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white.withOpacity(0.2),
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          icon: SvgPicture.asset('assets/icons/arrow_down.svg', width: 20),
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 16,
          color: Colors.white70,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      validator: (val) => val!.isEmpty ? 'Enter $label' : null,
      onChanged: (val) {
        setState(() {
          topic = val;
        });
      },
    );
  }
}
