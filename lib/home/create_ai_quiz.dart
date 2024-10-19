import 'package:datahack/home/ai_generated_quiz_input.dart';
import 'package:datahack/resources/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: Text('Create AI Quiz'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildQuizSetupCard(),
                SizedBox(height: 20),
                _buildGenerateQuizButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizSetupCard() {
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz Setup',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 20),
            _buildDropdown('Grade', grade, grades, (String? newValue) {
              setState(() {
                grade = newValue;
              });
            }),
            SizedBox(height: 10),
            _buildDropdown('Subject', subject, subjects, (String? newValue) {
              setState(() {
                subject = newValue;
              });
            }),
            SizedBox(height: 10),
            _buildTextField('Topic'),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items,
      Function(String?) onChanged) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
        SizedBox(width: 10),
        Expanded(
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
              dropdownColor: Colors.white,
              style: TextStyle(fontSize: 18, color: Colors.black87),
              icon: Icon(Icons.arrow_downward, color: Colors.deepPurpleAccent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 18, color: Colors.black54),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurpleAccent),
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

  Widget _buildGenerateQuizButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          createQuiz();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
            'Generate Quiz',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
