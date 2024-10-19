import 'package:flutter/material.dart';

class FlashcardList extends StatefulWidget {
  final String subject;
  const FlashcardList({super.key, required this.subject});

  @override
  State<FlashcardList> createState() => _FlashcardListState();
}

class _FlashcardListState extends State<FlashcardList> {
  // Hardcoded list of flashcards
  final List<Map<String, String>> flashcards = [
    {
      "question": "What is Flutter?",
      "answer":
          "Flutter is an open-source UI software development toolkit by Google."
    },
    {
      "question": "What is a StatefulWidget?",
      "answer": "A widget that has mutable state."
    },
    {
      "question": "What is Dart?",
      "answer": "Dart is the programming language used to write Flutter apps."
    },
    {
      "question": "What is the purpose of the setState() method?",
      "answer": "It notifies the framework to rebuild the widget."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards - ${widget.subject}'),
      ),
      body: ListView.builder(
        itemCount: flashcards.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(flashcards[index]["question"]!),
              subtitle: Text('Tap to see the answer'),
              onTap: () {
                // Show a dialog with the answer
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(flashcards[index]["question"]!),
                      content: Text(flashcards[index]["answer"]!),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
