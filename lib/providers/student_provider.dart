import 'package:datahack/models/student_model.dart';
import 'package:datahack/resources/auth_methods.dart';
import 'package:flutter/material.dart';

class StudentProvider with ChangeNotifier {
  Student? _student;
  final AuthMethods _authMethods = AuthMethods();

  Student getUser() {
    return _student!;
  }

  Future<void> refreshStudent() async {
    Student student = await _authMethods.getStudentDetails();
    _student = student;
    print(_student!.studentname);
    notifyListeners();
  }
}
