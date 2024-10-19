import 'package:datahack/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentHomePage extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> _userStream() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _userStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No user data found.'));
            }

            // Retrieving the firstName from Firestore
            String firstName = snapshot.data!.get('firstName');

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Banner
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Pallete.primaryColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Welcome text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back, $firstName!',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Let\'s continue your learning journey!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Profile icon or initials
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: Pallete.primaryColor,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                            // You can replace the icon with initials or a profile image
                            // Example: Show initials if no image
                            // backgroundImage: userProfileImage != null ? NetworkImage(userProfileImage) : null,
                            // child: userProfileImage == null ? Text(
                            //   firstName[0], // Display first letter of the name
                            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                            // ) : null,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Progress Overview
                  Text(
                    'Your Progress',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildStreakCard(context, 15),

                  SizedBox(height: 20),

                  // Flashcard Recommendations
                  Text(
                    'Recommended Flashcards',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildFlashcardRecommendations(),

                  SizedBox(height: 20),

                  // Study Session Scheduling
                  Text(
                    'Next Study Session',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildStudySessionCard(),

                  SizedBox(height: 20),

                  // Performance Insights
                  Text(
                    'Performance Insights',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildPerformanceInsights(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Progress Overview Card
  Widget _buildStreakCard(BuildContext context, int streakDays) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blueAccent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.local_fire_department,
                      color: Colors.orangeAccent, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Streak: $streakDays days',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              // Badge or indicator for long streaks
              if (streakDays >= 10) ...[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '🔥 Hot Streak!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 20),
          // Add more motivational text or details below the streak
          Text(
            streakDays >= 10
                ? 'You are on fire! Keep the momentum going!'
                : 'Stay consistent and build a longer streak!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 10),
          // Optionally, add an image or icon related to streaks for motivation
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.emoji_events, color: Colors.orangeAccent, size: 30),
              SizedBox(width: 5),
              Text(
                'Reach 10 days for a badge!',
                style: TextStyle(fontSize: 14, color: Colors.black45),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Flashcard Recommendations Section
  Widget _buildFlashcardRecommendations() {
    return Container(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFlashcardItem('Math Flashcards', '20 cards'),
          _buildFlashcardItem('Science Flashcards', '15 cards'),
          _buildFlashcardItem('History Flashcards', '10 cards'),
        ],
      ),
    );
  }

  Widget _buildFlashcardItem(String title, String subtitle) {
    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.lightBlueAccent, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey)),
          Spacer(),
          Icon(Icons.flash_on, color: Colors.lightBlueAccent, size: 40),
        ],
      ),
    );
  }

  // Study Session Card
  Widget _buildStudySessionCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orangeAccent, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule, color: Colors.orangeAccent, size: 30),
          SizedBox(width: 10),
          Text(
            'Next session in 2 hours',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Performance Insights Section
  Widget _buildPerformanceInsights() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purpleAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.purpleAccent, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: Colors.purpleAccent, size: 30),
              SizedBox(width: 10),
              Text(
                'Improvement in last quiz: +10%',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Focus on these topics to improve:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 5),
          Text('- Algebra\n- Physics\n- World History'),
        ],
      ),
    );
  }
}
