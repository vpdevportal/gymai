import 'package:dartz/dartz.dart';
import 'package:gymai/core/error/failures.dart';
import 'package:gymai/features/auth/domain/entities/user.dart';
import 'package:gymai/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  const SignInWithGoogleUseCase({required AuthRepository repository})
      : _repository = repository;

  final AuthRepository _repository;

  Future<Either<Failure, User>> call() => _repository.signInWithGoogle();
}
