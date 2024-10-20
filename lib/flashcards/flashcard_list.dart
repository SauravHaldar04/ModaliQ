import 'package:datahack/flashcards/view_flashcards_page.dart';
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
      "imageUrl":
          "https://images.unsplash.com/photo-1728985630341-075aa9277eda?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw3fHx8ZW58MHx8fHx8",
      "youtubeVideoId": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    },
    {
      "question": "What is a StatefulWidget?",
      "answer": "A widget that has mutable state.",
      "imageUrl": "https://link.to/statefulwidget/image.png",
      "youtubeVideoId": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    },
    {
      "question": "What is Dart?",
      "answer": "Dart is the programming language used to write Flutter apps.",
      "imageUrl": "https://link.to/dart/image.png",
      "youtubeVideoId": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    },
    {
      "question": "What is the purpose of the setState() method?",
      "answer": "It notifies the framework to rebuild the widget.",
      "imageUrl": "https://link.to/setstate/image.png",
      "youtubeVideoId": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
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
                  subject: widget.subject,
                  topic: 'Flutter',
                  youtubeVideoId: flashcards[currentIndex]["youtubeVideoId"]!,
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
}
