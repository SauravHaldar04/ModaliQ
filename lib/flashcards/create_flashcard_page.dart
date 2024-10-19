import 'package:datahack/core/theme/app_pallete.dart';
import 'package:datahack/core/widgets/project_button.dart';
import 'package:datahack/core/widgets/project_textfield.dart';
import 'package:flutter/material.dart';

class CreateFlashcardPage extends StatefulWidget {
  const CreateFlashcardPage({Key? key}) : super(key: key);

  @override
  State<CreateFlashcardPage> createState() => _CreateFlashcardPageState();
}

class _CreateFlashcardPageState extends State<CreateFlashcardPage> {
  TextEditingController topicController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  String selectedInputType = 'pdf'; // Default selected input type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create FlashCards",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProjectTextfield(
              text: "Enter Subject:",
              controller: subjectController,
            ),
            SizedBox(height: 20),
            ProjectTextfield(
              text: "Enter Topic :",
              controller: topicController,
            ),
            SizedBox(height: 20),
            ProjectButton(
              text: "Generate Flash Cards",
              onPressed: () {},
            ),
            SizedBox(height: 20),
            Text(
              "OR",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 20),
            Stack(
              children: [
                SizedBox(width: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      buildInputTypeButton('text'),
                      SizedBox(width: 10),
                      buildInputTypeButton('pdf'),
                      SizedBox(width: 10),
                      buildInputTypeButton('url'),
                      SizedBox(width: 10),
                      buildInputTypeButton('image'),
                      SizedBox(width: 10),
                      buildInputTypeButton('video'),
                      SizedBox(width: 10),
                      buildInputTypeButton('audio'),
                      SizedBox(width: 10),
                      buildInputTypeButton('ppt'),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 18, // Set the right property to 0
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: const Color.fromARGB(255, 9, 137, 130),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            buildInputTypeSection(),
          ],
        ),
      ),
    );
  }

  Widget buildInputTypeButton(String inputType) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedInputType = inputType;
              });
            },
            child: Text(inputType.toUpperCase()),
            style: ElevatedButton.styleFrom(
              elevation: 2,
              backgroundColor: selectedInputType == inputType
                  ? Pallete.primaryColor
                  : const Color.fromARGB(255, 231, 231, 231),
            ),
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget buildInputTypeSection() {
    switch (selectedInputType) {
      case 'pdf':
        return buildPdfInputSection();
      case 'url':
        return buildUrlInputSection();
      case 'image':
        return buildImageInputSection();
      case 'video':
        return buildVideoInputSection();
      case 'audio':
        return buildAudioInputSection();
      case 'ppt':
        return buildPptInputSection();
      case 'text':
        return buildTextInputSection();
      default:
        return Container();
    }
  }


  // ... existing code ...

  Widget buildPdfInputSection() {
    return Container(
      child: Column(
        children: [
          Text(
            'PDF Input Section',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: 'Enter PDF content',
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUrlInputSection() {
    return Container(
      child: Column(
        children: [
          Text(
            'URL Input Section',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: 'Enter URL',
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImageInputSection() {
    return Container(
      child: Column(
        children: [
          Text(
            'Image Input Section',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          // Add your custom image picker widget here
        ],
      ),
    );
  }

  Widget buildVideoInputSection() {
    return Container(
      child: Column(
        children: [
          Text(
            'Video Input Section',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          // Add your custom video player widget here
        ],
      ),
    );
  }

  Widget buildAudioInputSection() {
    return Container(
      child: Column(
        children: [
          Text(
            'Audio Input Section',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          // Add your custom audio recorder and waveform widget here
        ],
      ),
    );
  }

  Widget buildPptInputSection() {
    return Container(
      child: Column(
        children: [
          Text(
            'PPT Input Section',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          // Add your custom PPT viewer widget here
        ],
      ),
    );
  }

  Widget buildTextInputSection() {
    return Container(
      child: Column(
        children: [
          Text(
            'Text Input Section',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          // Add your custom text editor widget here
        ],
      ),
    );
  }

  // ... remaining code ...
}
