import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class YouTubePlayerWidget extends StatefulWidget {
  final String videoId;

  const YouTubePlayerWidget({Key? key, required this.videoId})
      : super(key: key);

  @override
  _YouTubePlayerWidgetState createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blueAccent,
    );
  }
}

Widget buildPlayfulFlashcard({
  required String imageUrl,
  required String frontText,
  required String backNote,
  required String youtubeVideoId,
  required String subject,
  required String topic,
}) {
  return GestureFlipCard(
    frontWidget: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 228, 247, 255).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue, width: 2),
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
          const SizedBox(height: 15),
          Text(
            frontText,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 58, 127, 183),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            backNote,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 58, 127, 183),
            ),
          ),
        ],
      ),
    ),
    backWidget: Container(
      padding: const EdgeInsets.all(20),
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
            const Text(
              "If you have more time to spend, watch this video!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            YouTubePlayerWidget(videoId: youtubeVideoId),
            const SizedBox(height: 20),
            const Text(
              'Watch the video to learn more!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Method to save flashcard to Firebase
Future<void> saveFlashcardToFirebase({
  required String subject,
  required String topic,
  required String frontText,
  required String backNote,
  required String youtubeVideoId,
  required String imageUrl,
}) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('flashcards')
        .add({
      'subject': subject,
      'topic': topic,
      'frontText': frontText,
      'backNote': backNote,
      'youtubeVideoId': youtubeVideoId,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });

    print('Flashcard saved successfully');
  } catch (e) {
    print('Error saving flashcard: $e');
  }
}
