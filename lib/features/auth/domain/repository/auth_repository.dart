import 'package:datahack/core/entities/user_entity.dart';
import 'package:datahack/core/error/failure.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signInWithEmailAndPassword(
      {required String firstName,
      required String middleName,
      required String lastName,
      required String email,
      required String password,
      required String studentGrade,
      required List<String> studentSubjects});
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, bool>> verifyEmail();
  Future<Either<Failure, void>> updateEmailVerification();
  Future<Either<Failure, auth.FirebaseAuth>> getFirebaseAuth();
  Future<Either<Failure, bool>> isUserEmailVerified();
}
