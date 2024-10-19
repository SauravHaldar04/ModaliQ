
import 'package:datahack/core/error/failure.dart';
import 'package:datahack/core/usecase/usecase.dart';
import 'package:datahack/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class IsUserEmailVerified implements Usecase<bool, NoParams> {
  final AuthRepository repository;

  IsUserEmailVerified(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isUserEmailVerified();
  }
}