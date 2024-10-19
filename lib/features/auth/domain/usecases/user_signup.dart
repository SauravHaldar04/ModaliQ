import 'package:datahack/core/entities/user_entity.dart';
import 'package:datahack/core/error/failure.dart';
import 'package:datahack/core/usecase/usecase.dart';
import 'package:datahack/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignup implements Usecase<User, UserSignupParams> {
  final AuthRepository authRepository;
  const UserSignup(this.authRepository);
  @override
  Future<Either<Failure, User>> call(UserSignupParams params) async {
    return await authRepository.signInWithEmailAndPassword(
        middleName: params.middleName,
        lastName: params.lastName,
        firstName: params.firstName,
        email: params.email,
        password: params.password,
        studentGrade: params.studentGrade,
        studentSubjects: params.studentSubjects);
  }
}

class UserSignupParams {
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String password;
  final String studentGrade;
  final List<String> studentSubjects;

  UserSignupParams(
      {required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.studentGrade,
      required this.studentSubjects});
}
