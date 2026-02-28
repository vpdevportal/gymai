import 'package:dartz/dartz.dart';
import 'package:gymai/core/error/failures.dart';
import 'package:gymai/features/profile/domain/entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserProfile?>> getProfile({required String userId});
  Future<Either<Failure, void>> saveProfile(UserProfile profile);
}
