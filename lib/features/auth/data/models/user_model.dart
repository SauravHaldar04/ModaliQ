// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:datahack/core/entities/user_entity.dart';

class UserModel extends User {
  final String? studentGrade;
  final List<String>? studentSubjects;

  UserModel({
    required super.uid,
    required super.email,
    required super.firstName,
    required super.middleName,
    required super.lastName,
    required super.emailVerified,
    required this.studentGrade,
    required this.studentSubjects,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? middleName,
    String? lastName,
    bool? emailVerified,
    String? studentGrade,
    List<String>? studentSubjects,
  }) {
    return UserModel(
      emailVerified: emailVerified ?? this.emailVerified,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      studentGrade: studentGrade ?? this.studentGrade,
      studentSubjects: studentSubjects ?? this.studentSubjects,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'emailVerified': emailVerified,
      'studentGrade': studentGrade,
      'studentSubjects': studentSubjects,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      emailVerified: map['emailVerified'] ?? false,
      uid: map['uid'] as String,
      email: map['email'] as String,
      firstName: map['firstName'] as String,
      middleName: map['middleName'] as String,
      lastName: map['lastName'] as String,
      studentGrade: map['studentGrade'] as String?,
      studentSubjects: map['studentSubjects'] != null
          ? List<String>.from(map['studentSubjects'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, firstName: $firstName, middleName: $middleName, lastName: $lastName, emailVerified: $emailVerified, studentGrade: $studentGrade, studentSubjects: $studentSubjects)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.email == email &&
        other.firstName == firstName &&
        other.middleName == middleName &&
        other.lastName == lastName &&
        other.emailVerified == emailVerified &&
        other.studentGrade == studentGrade &&
        listEquals(other.studentSubjects, studentSubjects);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        firstName.hashCode ^
        middleName.hashCode ^
        lastName.hashCode ^
        emailVerified.hashCode ^
        studentGrade.hashCode ^
        studentSubjects.hashCode;
  }
}

bool listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
