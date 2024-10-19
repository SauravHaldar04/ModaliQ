import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ClockCard extends StatelessWidget {
  final String title;
  final DateTime scheduledDateTime;

  const ClockCard(
      {Key? key, required this.title, required this.scheduledDateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 6, // Adds a shadow effect to create depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      color: Colors.white, // Background color
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding inside the card
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Clock-like UI
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent, // Circle color
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${scheduledDateTime.hour}:${scheduledDateTime.minute.toString().padLeft(2, '0')}', // Displaying time
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            // Title and subtitle
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Bold title
                        fontSize: 18, // Increased font size
                      ),
                    ),
                    SizedBox(height: 4), // Space between title and subtitle
                    Text(
                      'Scheduled on: ${scheduledDateTime.toLocal()}',
                      style: TextStyle(
                        color: Colors.grey[600], // Subtle text color
                        fontSize: 14, // Smaller font size for subtitle
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Optional: Calendar icon
            Icon(
              Icons.calendar_today, // Add an icon for visual appeal
              color: Colors.blue, // Customize icon color
            ),
          ],
        ),
      ),
    );
  }
}
