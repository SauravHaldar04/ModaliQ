import 'dart:io';

import 'package:datahack/core/theme/app_pallete.dart';
import 'package:datahack/core/utils/pickFile.dart';
import 'package:datahack/core/utils/view_pdf.dart';
import 'package:datahack/core/widgets/project_button.dart';
import 'package:datahack/core/widgets/project_textfield.dart';
import 'package:datahack/flashcards/view_flashcards_page.dart';
import 'package:datahack/flashcards/view_quiz_flashcard_page.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CreateFlashcardPage extends StatefulWidget {
  const CreateFlashcardPage({Key? key}) : super(key: key);

  @override
  State<CreateFlashcardPage> createState() => _CreateFlashcardPageState();
}

class _CreateFlashcardPageState extends State<CreateFlashcardPage> {
  TextEditingController topicController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  String selectedInputType = 'pdf';

  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _videoController;
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  quill.QuillController _quillController = quill.QuillController.basic();

  bool isFileUploaded = false;

  @override
  void dispose() {
    _videoController?.dispose();
    _audioRecorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create FlashCards",
          style: TextStyle(color: Colors.white),
        ),
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
                _buildInputCard(),
                SizedBox(height: 20),
                _buildInputTypeSection(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Flashcard Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 16),
            ProjectTextfield(
              text: "Enter Subject:",
              controller: subjectController,
            ),
            SizedBox(height: 16),
            ProjectTextfield(
              text: "Enter Topic:",
              controller: topicController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isFileUploaded
                  ? null
                  : () {
                      // Add your generation logic here
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text("Generate Flash Cards"),
            ),
            SizedBox(height: 20),
            Text(
              "OR",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  buildInputTypeButton('text'),
                  buildInputTypeButton('pdf'),
                  buildInputTypeButton('url'),
                  buildInputTypeButton('image'),
                  buildInputTypeButton('video'),
                  buildInputTypeButton('audio'),
                  buildInputTypeButton('ppt'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputTypeButton(String inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedInputType = inputType;
            isFileUploaded = false;
          });
        },
        child: Text(inputType.toUpperCase()),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          backgroundColor: selectedInputType == inputType
              ? Colors.deepPurpleAccent
              : Colors.grey[300],
          foregroundColor:
              selectedInputType == inputType ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInputTypeSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Input Section',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 16),
            buildInputTypeContent(),
          ],
        ),
      ),
    );
  }

  Widget buildInputTypeContent() {
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

  Widget buildFileUploadSection(
      String sectionTitle, String buttonText, VoidCallback onUpload) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: isFileUploaded ? null : onUpload,
          child: Text(buttonText),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            foregroundColor: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: isFileUploaded ? () {} : null,
          child: Text('Generate Flashcards'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildPdfInputSection() {
    return buildFileUploadSection(
      'PDF Input',
      'Upload PDF',
      () async {
        if (!isFileUploaded) {
          await pickFile(type: FileType.custom, allowedExtensions: ['pdf'])
              .then((file) {
            if (file != null) {
              setState(() {
                isFileUploaded = true;
              });
              viewPdf(file, context);
            }
          });
        }
      },
    );
  }

  Widget buildUrlInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'URL Input',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Enter URL',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (url) async {
            if (await canLaunch(url)) {
              await launch(url);
              setState(() {
                isFileUploaded = true;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Could not launch $url')),
              );
            }
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: isFileUploaded ? () {} : null,
          child: Text('Generate Flashcards'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildImageInputSection() {
    return buildFileUploadSection(
      'Image Input',
      'Upload Image',
      () async {
        if (!isFileUploaded) {
          final pickedFile =
              await _picker.pickImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            setState(() {
              isFileUploaded = true;
            });
          }
        }
      },
    );
  }

  Widget buildVideoInputSection() {
    return buildFileUploadSection(
      'Video Input',
      'Upload Video',
      () async {
        if (!isFileUploaded) {
          final pickedFile =
              await _picker.pickVideo(source: ImageSource.gallery);
          if (pickedFile != null) {
            _videoController = VideoPlayerController.file(File(pickedFile.path))
              ..initialize().then((_) {
                setState(() {
                  isFileUploaded = true;
                });
                _videoController?.play();
              });
          }
        }
      },
    );
  }

  Widget buildAudioInputSection() {
    return buildFileUploadSection(
      'Audio Input',
      isFileUploaded ? 'Stop Recording' : 'Start Recording',
      () async {
        if (!isFileUploaded) {
          await _audioRecorder.startRecorder(toFile: 'audio.aac');
          setState(() {
            isFileUploaded = true;
          });
        } else {
          await _audioRecorder.stopRecorder();
          setState(() {
            isFileUploaded = false;
          });
        }
      },
    );
  }

  Widget buildPptInputSection() {
    return buildFileUploadSection(
      'PPT Input',
      'Upload PPT',
      () async {
        if (!isFileUploaded) {
          final pickedFile = await pickFile(
            type: FileType.custom,
            allowedExtensions: ['ppt', 'pptx'],
          );
          if (pickedFile != null) {
            setState(() {
              isFileUploaded = true;
            });
          }
        }
      },
    );
  }

  Widget buildTextInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Text Input',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: quill.QuillEditor.basic(
            controller: _quillController,
            configurations: quill.QuillEditorConfigurations(
              checkBoxReadOnly: true,
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Add text generation logic here
          },
          child: Text('Generate Flashcards'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

//   Widget _buildFlashcardExamples() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Flashcard Examples',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.deepPurple,
//               ),
//             ),
//             SizedBox(height: 16),
//             Center(
//               child: SizedBox(
//                 height: 200,
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 child: buildPlayfulFlashcard(
//                   imageUrl: 'https://via.placeholder.com/150',
//                   frontText: 'What is the functional group of alcohols?',
//                   backNote:
//                       'The functional group of alcohols is -OH (hydroxyl group).',
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Center(
//               child: SizedBox(
//                 height: 200,
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 child: QuizFlashcard(
//                   question: 'What is the color of the sky?',
//                   option1: "Red",
//                   option2: "Green",
//                   option3: "Yellow",
//                   correctOption: "Blue",
//                   explanation:
//                       "The sky appears blue due to Rayleigh scattering of sunlight in the atmosphere.",
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

  Widget buildPlayfulFlashcard({
    required String imageUrl,
    required String frontText,
    required String backNote,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(imageUrl, height: 80),
          SizedBox(height: 10),
          Text(
            frontText,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            backNote,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
