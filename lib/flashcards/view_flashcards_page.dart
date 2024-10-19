import 'package:datahack/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

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
          SizedBox(height: 10),
          Text(
            "The hydroxyl group (-OH) is the functional group of alcohols, which is attached to a carbon atom",
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
