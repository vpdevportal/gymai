import 'package:dartz/dartz.dart';
import 'package:gymai/core/error/exceptions.dart';
import 'package:gymai/core/error/failures.dart';
import 'package:gymai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:gymai/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:gymai/features/auth/domain/entities/user.dart';
import 'package:gymai/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required FirebaseAuthDataSource firebaseDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _firebaseDataSource = firebaseDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final FirebaseAuthDataSource _firebaseDataSource;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(
        User(
          id: model.id,
          email: model.email,
          name: model.name,
          avatarUrl: model.avatarUrl,
        ),
      );
    } on AuthException catch (e) {
      return Left(Failure.authFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(Failure.networkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(
        Failure.serverFailure(message: e.message, statusCode: e.statusCode),
      );
    } on Exception catch (_) {
      return const Left(Failure.unknownFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final model = await _firebaseDataSource.signInWithGoogle();
      return Right(
        User(
          id: model.id,
          email: model.email,
          name: model.name,
          avatarUrl: model.avatarUrl,
        ),
      );
    } on AuthException catch (e) {
      return Left(Failure.authFailure(message: e.message));
    } on Exception catch (_) {
      return const Left(Failure.unknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _firebaseDataSource.signOut();
      return const Right(null);
    } on Exception catch (_) {
      return const Left(Failure.unknownFailure());
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final model = _firebaseDataSource.getCurrentUser();
      if (model == null) return const Right(null);
      return Right(
        User(
          id: model.id,
          email: model.email,
          name: model.name,
          avatarUrl: model.avatarUrl,
        ),
      );
    } on Exception catch (_) {
      return const Right(null);
    }
  }
}
