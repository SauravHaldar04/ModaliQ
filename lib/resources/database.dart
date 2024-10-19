import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseService {
  final String uid;
  final auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  DatabaseService({this.uid = ''});

  Future<void> addData(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addQuizData(Map<String, String> quizData, String quizId) async {
    try {
      if (uid.isEmpty) {
        print('Error: UID is null or empty.');
        return;
      }

      DocumentReference userDocRef = _firestore.collection('users').doc(uid);
      CollectionReference quizCollectionRef = userDocRef.collection('Quiz');

      await quizCollectionRef.doc(quizId).set(quizData);
      print('Quiz data added successfully');
    } catch (e) {
      print('Error adding quiz data: $e');
      throw e;
    }
  }

  Future<void> addQuestionData(quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .add(quizData)
        .catchError((e) {
      print(e);
    });
  }

  getQuizData() async {
    return await FirebaseFirestore.instance.collection("Quiz").snapshots();
  }

  getQuestionData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .get();
  }
}
