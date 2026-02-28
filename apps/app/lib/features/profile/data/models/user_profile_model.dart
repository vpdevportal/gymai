import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gymai/features/profile/domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String userId,
    double? height,
    double? weight,
    int? age,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  factory UserProfileModel.fromDomain(UserProfile profile) => UserProfileModel(
        userId: profile.userId,
        height: profile.height,
        weight: profile.weight,
        age: profile.age,
      );

  const UserProfileModel._();

  UserProfile toDomain() => UserProfile(
        userId: userId,
        height: height,
        weight: weight,
        age: age,
      );
}
