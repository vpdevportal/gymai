// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    _UserProfileModel(
      userId: json['userId'] as String,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      dateOfBirth: _dateFromJson(json['dateOfBirth']),
      gender: json['gender'] as String?,
      activityLevel: $enumDecodeNullable(
        _$ActivityLevelEnumMap,
        json['activityLevel'],
      ),
    );

Map<String, dynamic> _$UserProfileModelToJson(_UserProfileModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'height': instance.height,
      'weight': instance.weight,
      'dateOfBirth': _dateToJson(instance.dateOfBirth),
      'gender': instance.gender,
      'activityLevel': _$ActivityLevelEnumMap[instance.activityLevel],
    };

const _$ActivityLevelEnumMap = {
  ActivityLevel.sedentary: 'sedentary',
  ActivityLevel.lightlyActive: 'lightlyActive',
  ActivityLevel.moderatelyActive: 'moderatelyActive',
  ActivityLevel.veryActive: 'veryActive',
  ActivityLevel.extraActive: 'extraActive',
};
