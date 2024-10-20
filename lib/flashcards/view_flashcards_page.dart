import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerWidget extends StatefulWidget {
  final String videoId;

  const YouTubePlayerWidget({Key? key, required this.videoId})
      : super(key: key);

  @override
  _YouTubePlayerWidgetState createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  late YoutubePlayerController _controller;
  String? getYouTubeVideoId(String url) {
    // List of regular expressions to match various YouTube URL formats
    final List<RegExp> regExps = [
      // Standard YouTube URL
      RegExp(r'^https?:\/\/(?:www\.)?youtube\.com\/watch\?v=([^&]+)'),
      // Short YouTube URL
      RegExp(r'^https?:\/\/youtu\.be\/([^?]+)'),
      // Embedded YouTube URL
      RegExp(r'^https?:\/\/(?:www\.)?youtube\.com\/embed\/([^?]+)'),
      // YouTube short URL
      RegExp(r'^https?:\/\/(?:www\.)?youtube\.com\/shorts\/([^?]+)'),
      // YouTube URL with 'v' parameter anywhere in the query string
      RegExp(r'[?&]v=([^&]+)'),
      // Direct video ID input (11 characters)
      RegExp(r'^[a-zA-Z0-9_-]{11}$'),
    ];

    for (final regex in regExps) {
      final match = regex.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }

    // If no match is found, return null
    return null;
  }

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: getYouTubeVideoId(widget.videoId)!,
      flags: YoutubePlayerFlags(
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
}) {
  return GestureFlipCard(
    frontWidget: Container(
      padding: EdgeInsets.all(20),
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
          SizedBox(height: 10),
          Text(
            backNote,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: const Color.fromARGB(255, 58, 127, 183),
            ),
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
              "If you have more time to spend, watch this video!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            YouTubePlayerWidget(videoId: youtubeVideoId),
            SizedBox(height: 20),
            Text(
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
