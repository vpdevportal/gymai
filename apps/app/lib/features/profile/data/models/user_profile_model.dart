import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gymai/features/profile/domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

// Custom converters: store dateOfBirth as milliseconds since epoch in Firestore
DateTime? _dateFromJson(dynamic value) {
  if (value == null) return null;
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is String) return DateTime.tryParse(value);
  return null;
}

int? _dateToJson(DateTime? date) => date?.millisecondsSinceEpoch;

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String userId,
    double? height,
    double? weight,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? dateOfBirth,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  factory UserProfileModel.fromDomain(UserProfile profile) => UserProfileModel(
        userId: profile.userId,
        height: profile.height,
        weight: profile.weight,
        dateOfBirth: profile.dateOfBirth,
      );

  const UserProfileModel._();

  UserProfile toDomain() => UserProfile(
        userId: userId,
        height: height,
        weight: weight,
        dateOfBirth: dateOfBirth,
      );
}
