import 'dart:typed_data';

import 'package:datahack/core/theme/app_pallete.dart';
import 'package:datahack/core/utils/pickFile.dart';
import 'package:datahack/features/auth/presentation/pages/landing_page.dart';
import 'package:datahack/flashcards/flashcard_list.dart';
import 'package:datahack/widgets/clock_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;

  String? syllabusUrl;

  @override
  void initState() {
    super.initState();
    _getSyllabusUrl();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _userStream() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .snapshots();
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LandingPage()),
      );
    } catch (e) {
      print("Error logging out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out.')),
      );
    }
  }

  Future<void> _uploadSyllabus() async {
    try {
      final file = await pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf'], // restrict to PDF files
      );

      if (file != null) {
        final fileName =
            'syllabus_${_auth.currentUser!.uid}.${file.path.split('.').last}';
        print(fileName);

        // Check if file has bytes
        if (file != null) {
          final ref = _storage.ref().child('syllabus/$fileName');

          // Upload file
          final uploadTask = ref.putFile(file);

          // Wait for the upload task to complete and get download URL
          final snapshot = await uploadTask;
          final downloadUrl = await snapshot.ref.getDownloadURL();

          // Save URL in Firestore
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .update({'syllabusUrl': downloadUrl});

          setState(() {
            syllabusUrl = downloadUrl;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Syllabus uploaded successfully!')),
          );
        } else {
          throw Exception('File bytes are null.');
        }
      } else {
        throw Exception('No file selected.');
      }
    } catch (e) {
      print("Error uploading file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload syllabus.')),
      );
    }
  }

  Future<void> _removeSyllabus() async {
    if (syllabusUrl != null) {
      try {
        final ref = _storage.refFromURL(syllabusUrl!);
        await ref.delete();

        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({'syllabusUrl': FieldValue.delete()});

        setState(() {
          syllabusUrl = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Syllabus removed successfully!')),
        );
      } catch (e) {
        print("Error removing file: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove syllabus.')),
        );
      }
    }
  }

  Future<void> _getSyllabusUrl() async {
    try {
      final userDoc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      setState(() {
        syllabusUrl = userDoc.data()?['syllabusUrl'];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Syllabus URL retrieved successfully!')),
      );
    } catch (e) {
      print("Error retrieving syllabus URL: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to retrieve syllabus URL.')),
      );
    }
  }

  Future<void> _scheduleSession(BuildContext context) async {
    final TextEditingController _titleController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    // Show a dialog to input session details
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Schedule Study Session'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Session Title'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Select date
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 30)),
                  );
                  if (date != null) {
                    selectedDate = date;
                  }
                },
                child: Text('Select Date'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Select time
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (time != null) {
                    selectedTime = time;
                  }
                },
                child: Text('Select Time'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Save session to Firestore
                String title = _titleController.text;
                DateTime scheduledDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                if (title.isNotEmpty) {
                  await _firestore
                      .collection('users')
                      .doc(_auth.currentUser!.uid)
                      .collection('sessions')
                      .add({
                    'title': title,
                    'scheduledDateTime': scheduledDateTime,
                    'createdAt': FieldValue.serverTimestamp(),
                  });

                  Navigator.pop(context); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Session scheduled!')),
                  );
                }
              },
              child: Text('Schedule'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _scheduledSessionsStream() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('sessions')
        .orderBy('scheduledDateTime', descending: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                _logout(context); // Call the logout method
              },
            ),
          ],
        ),
      ),
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

            String firstName = snapshot.data!.get('firstName');

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Banner
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.indigo[700]!, Colors.indigo[500]!],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo[300]!.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back,',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                firstName,
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Continue your learning journey!',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 38,
                              backgroundColor: Pallete.primaryColor,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Syllabus Upload Section
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue[100]!, Colors.blue[50]!],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.book,
                                  color: Colors.blue[700], size: 28),
                              SizedBox(width: 10),
                              Text(
                                'Your Syllabus',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          syllabusUrl != null
                              ? Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.blue[200]!),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.check_circle,
                                              color: Colors.green),
                                          SizedBox(width: 10),
                                          Text(
                                            'Syllabus uploaded',
                                            style: TextStyle(
                                              color: Colors.blue[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton.icon(
                                          icon: Icon(Icons.delete),
                                          label: Text(
                                            'Remove',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: _removeSyllabus,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red[400],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 12),
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          icon: Icon(Icons.download),
                                          label: Text(
                                            'Download',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            // Open the syllabus download link
                                            // _launchURL(syllabusUrl!);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green[400],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Center(
                                  child: ElevatedButton.icon(
                                    icon: Icon(Icons.upload_file),
                                    label: Text('Upload Syllabus'),
                                    onPressed: _uploadSyllabus,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[600],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Progress Overview
                  Text(
                    'Your Progress',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildStreakCard(context, 80),

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
                  _buildStudySessionCard(context),

                  SizedBox(height: 20),

                  // Performance Insights
                  Text(
                    'Performance Insights',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildPerformanceInsights(),

                  // Upcoming Scheduled Sessions
                  SizedBox(height: 20),
                  Text(
                    'Upcoming Scheduled Sessions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _scheduledSessionsStream(),
                    builder: (context, sessionSnapshot) {
                      if (sessionSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!sessionSnapshot.hasData ||
                          sessionSnapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No scheduled sessions.'));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: sessionSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final session = sessionSnapshot.data!.docs[index];
                          final title = session.get('title');
                          final scheduledDateTime =
                              (session.get('scheduledDateTime') as Timestamp)
                                  .toDate();

                          return ClockCard(
                              title: title,
                              scheduledDateTime: scheduledDateTime);
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

//   void _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }
  // Flashcard Recommendations Card
  Widget _buildFlashcardRecommendations() {
    return Container(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFlashcardItem('Math Flashcards', '20 cards', 'Math'),
          _buildFlashcardItem('Science Flashcards', '15 cards', 'Science'),
          _buildFlashcardItem('History Flashcards', '10 cards', 'History'),
        ],
      ),
    );
  }

  Widget _buildFlashcardItem(String title, String subtitle, String subject) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayfulFlashcardPage(
                      subject: subject,
                    )));
      },
      child: Container(
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
      ),
    );
  }

  // Streak Card
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

  // Study Session Card
  Widget _buildStudySessionCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.greenAccent, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Schedule Your Study Session',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Click to add a session for today!',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _scheduleSession(context); // Call the schedule session method
            },
            child: Text('Schedule Session'),
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
