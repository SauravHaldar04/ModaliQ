import 'dart:io';
import 'package:datahack/core/theme/app_pallete.dart';
import 'package:datahack/core/utils/pickFile.dart';
import 'package:datahack/core/utils/view_pdf.dart';
import 'package:datahack/core/widgets/project_button.dart';
import 'package:datahack/core/widgets/project_textfield.dart';
import 'package:datahack/flashcards/view_flashcards_page.dart';
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                onPressed: isFileUploaded
                    ? null
                    : () {
                        // Add your generation logic here
                      },
              ),
              SizedBox(height: 20),
              Text(
                "OR",
                style: TextStyle(
                  fontSize: 30,
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
              SizedBox(height: 20),
              buildInputTypeSection(),
              Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      height: 400,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: buildPlayfulFlashcard(
                        imageUrl: 'https://via.placeholder.com/150',
                        frontText: 'What is the functional group of alcohols',
                        backNote:
                            'This is the note on the back of the flashcard.',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputTypeButton(String inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          backgroundColor: selectedInputType == inputType
              ? Pallete.primaryColor
              : const Color.fromARGB(255, 231, 231, 231),
        ),
      ),
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

  Widget buildFileUploadSection(
      String sectiontitle, String buttonText, VoidCallback onUpload) {
    return Container(
      width: double.infinity,
      height: 250,
      padding: const EdgeInsets.all(16.0),
      decoration: inputSectionDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(sectiontitle),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: isFileUploaded ? null : onUpload,
            child: Text(buttonText),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isFileUploaded ? () {} : null,
            child: Text('Generate Flashcards'),
          ),
        ],
      ),
    );
  }

  Widget buildPdfInputSection() {
    return buildFileUploadSection(
      'PDF Input Section',
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
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(16.0),
      decoration: inputSectionDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('URL Input Section'),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(labelText: 'Enter URL'),
            onSubmitted: (url) async {
              if (await canLaunch(url)) {
                await launch(url);
                setState(() {
                  isFileUploaded = true;
                });
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isFileUploaded ? () {} : null,
            child: Text('Generate Flashcards'),
          ),
        ],
      ),
    );
  }

  Widget buildImageInputSection() {
    return buildFileUploadSection(
      'Image Input Section',
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
      'Video Input Section',
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
    'Audio Input Section',
    isFileUploaded ? 'Stop Recording' : 'Start Recording',
    () async {
      if (!isFileUploaded) {
        // Start recording
        await _audioRecorder.startRecorder(toFile: 'audio.aac');
        setState(() {
          isFileUploaded = true;
        });
      } else {
        // Stop recording
        await _audioRecorder.stopRecorder();
        setState(() {
          isFileUploaded = false;
        });
      }
    },
  );
}

FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();

Widget buildAudioPlaybackButton() {
  return ElevatedButton(
    onPressed: () async {
      if (_audioPlayer.isPlaying) {
        await _audioPlayer.stopPlayer();
      } else {
        await _audioPlayer.startPlayer(fromURI: 'audio.aac');
      }
      setState(() {}); // Update UI based on player state
    },
    child: Text(_audioPlayer.isPlaying ? 'Stop Audio' : 'Play Audio'),
  );
}

Widget buildPptInputSection() {
  return buildFileUploadSection(
    'PPT Input Section',
    'Upload PPT',
    () async {
      if (!isFileUploaded) {
        final pickedFile = await pickFile(
          type: FileType.custom,
          allowedExtensions: ['ppt', 'pptx'],
        );
        if (pickedFile != null) {
          // Handle the picked PPT file here (e.g., display filename)
          setState(() {
            isFileUploaded = true;
          });
        }
      }
    },
  );
}



  Widget buildTextInputSection() {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(16.0),
      decoration: inputSectionDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('Text Input Section'),
          SizedBox(height: 10),
          quill.QuillEditor.basic(
            controller: _quillController,
            configurations: quill.QuillEditorConfigurations(
              checkBoxReadOnly: true,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add text generation logic here
            },
            child: Text('Generate Flashcards'),
          ),
        ],
      ),
    );
  }

  BoxDecoration inputSectionDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.grey.withOpacity(0.5),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 6,
          spreadRadius: 2,
        ),
      ],
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Pallete.primaryColor,
      ),
    );
  }
}
