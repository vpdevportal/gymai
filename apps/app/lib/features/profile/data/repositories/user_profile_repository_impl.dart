import 'package:dartz/dartz.dart';
import 'package:gymai/core/error/exceptions.dart';
import 'package:gymai/core/error/failures.dart';
import 'package:gymai/features/profile/data/datasources/firestore_profile_datasource.dart';
import 'package:gymai/features/profile/data/models/user_profile_model.dart';
import 'package:gymai/features/profile/domain/entities/user_profile.dart';
import 'package:gymai/features/profile/domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  const UserProfileRepositoryImpl({
    required FirestoreProfileDataSource dataSource,
  }) : _dataSource = dataSource;

  final FirestoreProfileDataSource _dataSource;

  @override
  Future<Either<Failure, UserProfile?>> getProfile({
    required String userId,
  }) async {
    try {
      final model = await _dataSource.getProfile(userId: userId);
      return Right(model?.toDomain());
    } on ServerException catch (e) {
      return Left(Failure.serverFailure(message: e.message));
    } on Exception catch (_) {
      return const Left(Failure.unknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveProfile(UserProfile profile) async {
    try {
      await _dataSource.saveProfile(UserProfileModel.fromDomain(profile));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure.serverFailure(message: e.message));
    } on Exception catch (_) {
      return const Left(Failure.unknownFailure());
    }
  }
}
