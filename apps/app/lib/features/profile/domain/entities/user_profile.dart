import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:gymai/features/profile/domain/entities/activity_level.dart';

part 'user_profile.freezed.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String userId,
    double? height,
    double? weight,
    DateTime? dateOfBirth,
    String? gender,
    ActivityLevel? activityLevel,
  }) = _UserProfile;
}
