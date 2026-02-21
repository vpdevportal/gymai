import 'package:dartz/dartz.dart';
import 'package:gymai/core/error/exceptions.dart';
import 'package:gymai/core/error/failures.dart';
import 'package:gymai/core/network/auth_interceptor.dart';
import 'package:gymai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:gymai/features/auth/domain/entities/user.dart';
import 'package:gymai/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthInterceptor authInterceptor,
  })  : _remoteDataSource = remoteDataSource,
        _authInterceptor = authInterceptor;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthInterceptor _authInterceptor;

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
      final user = User(id: model.id, email: model.email, name: model.name, avatarUrl: model.avatarUrl);
      return Right(user);
    } on AuthException catch (e) {
      return Left(Failure.authFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(Failure.networkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(Failure.serverFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (_) {
      return const Left(Failure.unknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _authInterceptor.deleteToken();
      return const Right(null);
    } on Exception catch (_) {
      return const Left(Failure.unknownFailure());
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final token = await _authInterceptor.getToken();
      if (token == null) return const Right(null);
      final model = await _remoteDataSource.getCurrentUser();
      return Right(User(id: model.id, email: model.email, name: model.name, avatarUrl: model.avatarUrl));
    } on Exception catch (_) {
      return const Right(null);
    }
  }
}
