import 'package:datahack/core/utils/pickFile.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ModernAssignmentCreator extends StatefulWidget {
  @override
  _ModernAssignmentCreatorState createState() =>
      _ModernAssignmentCreatorState();
}

class _ModernAssignmentCreatorState extends State<ModernAssignmentCreator> {
  bool isPdfView = true;
  String? pdfPath;
  final questionController = TextEditingController();
  final answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple, Color(0xFF2575FC)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildToggleSwitch(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: isPdfView ? _buildPdfUpload() : _buildQAInput(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        "Assignment And Short Answer",
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Colors.black.withOpacity(0.3),
              offset: Offset(0, 5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSwitch() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton("PDF Upload", isPdfView),
          _buildToggleButton("Q&A Input", !isPdfView),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isPdfView = text == "PDF Upload";
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.deepPurple : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPdfUpload() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: pdfPath != null
                ? Icon(Icons.picture_as_pdf, size: 100, color: Colors.white)
                : SvgPicture.network(
                    'https://www.svgrepo.com/show/357902/file-upload.svg',
                  ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final file = await pickFile(
                  allowedExtensions: ['pdf'], type: FileType.custom);
              setState(() {
                pdfPath = file!.path;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text("Select PDF"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: pdfPath != null
                ? () {
                    // Send the selected PDF to your server or database
                    print("PDF sent: $pdfPath");
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text("Send PDF"),
          ),
        ],
      ),
    );
  }

  Widget _buildQAInput() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: questionController,
            decoration: InputDecoration(
              labelText: "Question",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 20),
          TextField(
            controller: answerController,
            decoration: InputDecoration(
              labelText: "Answer",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Send the question and answer to your server or database
              print("Question: ${questionController.text}");
              print("Answer: ${answerController.text}");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text("Send"),
          ),
        ],
      ),
    );
  }
}
