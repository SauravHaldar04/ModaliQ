import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahack/home/contest_quiz.dart';

class ContestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contest of the Day'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contest Quiz Card
            _buildContestQuizCard(context),
            SizedBox(height: 30),
            // Leaderboard Section
            _buildLeaderboardSection(),
          ],
        ),
      ),
    );
  }

  // Contest Quiz Card
  Widget _buildContestQuizCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return QuizPage();
        }));
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.deepPurpleAccent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Icon(Icons.quiz, color: Colors.deepPurple, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Today\'s Contest: \nGeneral Knowledge Quiz',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Test your knowledge and compete with others!',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.timer, color: Colors.orangeAccent, size: 24),
                    SizedBox(width: 5),
                    Text(
                      '5 mins',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellowAccent, size: 24),
                    SizedBox(width: 5),
                    Text(
                      '10 Points',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return QuizPage();
                }));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Start Quiz',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Leaderboard Section
  Widget _buildLeaderboardSection() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blueAccent, width: 2),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.leaderboard, color: Colors.blueAccent, size: 30),
                SizedBox(width: 10),
                Text(
                  'Leaderboard',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Fetch and display leaderboard data from Firestore
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('points', isGreaterThan: 0)
                    .orderBy('points', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Text('No leaderboard data available.'));
                  }

                  final users = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final name = "${user['firstName']} ${user["lastName"]}" ??
                          'Anonymous';
                      final points = user['points'] ?? 0;
                      final isTopper = index == 0;

                      return _buildLeaderboardTile(name, points, isTopper);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Leaderboard Tile
  Widget _buildLeaderboardTile(String name, int score, bool isTopper) {
    return ListTile(
      leading: Icon(
        isTopper ? Icons.emoji_events : Icons.person,
        color: isTopper ? Colors.orangeAccent : Colors.blueAccent,
        size: 30,
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 18,
          fontWeight: isTopper ? FontWeight.bold : FontWeight.normal,
          color: Colors.black87,
        ),
      ),
      trailing: Text(
        '$score pts',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 10),
    );
  }
}
