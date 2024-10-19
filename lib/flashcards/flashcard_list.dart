import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:datahack/core/theme/app_pallete.dart';

class PlayfulFlashcardPage extends StatefulWidget {
  final String subject;

  const PlayfulFlashcardPage({super.key, required this.subject});

  @override
  State<PlayfulFlashcardPage> createState() => _PlayfulFlashcardPageState();
}

class _PlayfulFlashcardPageState extends State<PlayfulFlashcardPage> {
  // Hardcoded list of flashcards
  final List<Map<String, String>> flashcards = [
    {
      "question": "What is Flutter?",
      "answer":
          "Flutter is an open-source UI software development toolkit by Google.",
      "imageUrl": "https://link.to/flutter/image.png"
    },
    {
      "question": "What is a StatefulWidget?",
      "answer": "A widget that has mutable state.",
      "imageUrl": "https://link.to/statefulwidget/image.png"
    },
    {
      "question": "What is Dart?",
      "answer": "Dart is the programming language used to write Flutter apps.",
      "imageUrl": "https://link.to/dart/image.png"
    },
    {
      "question": "What is the purpose of the setState() method?",
      "answer": "It notifies the framework to rebuild the widget.",
      "imageUrl": "https://link.to/setstate/image.png"
    },
  ];

  int currentIndex = 0;

  void goToPreviousCard() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      }
    });
  }

  void goToNextCard() {
    setState(() {
      if (currentIndex < flashcards.length - 1) {
        currentIndex++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playful Flashcards - ${widget.subject}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Flashcard ${currentIndex + 1} / ${flashcards.length}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Center(
                child: buildPlayfulFlashcard(
                  imageUrl: flashcards[currentIndex]["imageUrl"]!,
                  frontText: flashcards[currentIndex]["question"]!,
                  backNote: flashcards[currentIndex]["answer"]!,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: goToPreviousCard,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Previous',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: goToNextCard,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Build playful flashcard UI with gesture flip and playful colors
  Widget buildPlayfulFlashcard({
    required String imageUrl,
    required String frontText,
    required String backNote,
  }) {
    return GestureFlipCard(
      frontWidget: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 228, 247, 255).withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Pallete.primaryColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(
                imageUrl,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 15),
            Text(
              frontText,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 58, 127, 183),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      backWidget: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 233, 205, 255).withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: const Color.fromARGB(255, 244, 172, 255), width: 2),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                backNote,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add your button action here
                },
                child: Text('Got It!'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
