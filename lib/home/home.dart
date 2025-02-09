import 'package:datahack/flashcards/create_flashcard_page.dart';
import 'package:datahack/home/assignments_short.dart';
import 'package:datahack/home/chat_help1.dart';
import 'package:datahack/home/chat_help2.dart';
import 'package:datahack/home/contest_page.dart';
import 'package:datahack/home/create_ai_quiz.dart';
import 'package:datahack/home/student_homepage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    StudentHomePage(),
    CreateFlashcardPage(),
    CreateAIQuiz(),
    ContestPage(),
    ModernAssignmentCreator(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 28,
          elevation: 0,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flash_on_outlined),
              activeIcon: Icon(Icons.flash_on),
              label: 'Flashcards',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz_outlined),
              activeIcon: Icon(Icons.quiz),
              label: 'Quiz',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined),
              activeIcon: Icon(Icons.emoji_events),
              label: 'Contest',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.picture_as_pdf_outlined),
              activeIcon: Icon(Icons.picture_as_pdf),
              label: 'Assignment & Short',
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder classes for the pages
class UserDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('User Dashboard'));
}

class FlashCardAnalysis extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Center(child: Text('Flashcard Analysis'));
}

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Quiz Page'));
}

class ChatHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Center(child: Text('Assignment & Short'));
}
