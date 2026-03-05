import 'package:freezed_annotation/freezed_annotation.dart';

enum ActivityLevel {
  @JsonValue('sedentary')
  sedentary,
  
  @JsonValue('lightlyActive')
  lightlyActive,
  
  @JsonValue('moderatelyActive')
  moderatelyActive,
  
  @JsonValue('veryActive')
  veryActive,
  
  @JsonValue('extraActive')
  extraActive;

  /// Returns the multiplier to calculate maintenance calories
  double get multiplier {
    switch (this) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.lightlyActive:
        return 1.375;
      case ActivityLevel.moderatelyActive:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
      case ActivityLevel.extraActive:
        return 1.9;
    }
  }

  /// Returns a display string for the UI
  String get displayName {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Sedentary (little to no exercise)';
      case ActivityLevel.lightlyActive:
        return 'Lightly Active (1-3 days/week)';
      case ActivityLevel.moderatelyActive:
        return 'Moderately Active (3-5 days/week)';
      case ActivityLevel.veryActive:
        return 'Very Active (6-7 days/week)';
      case ActivityLevel.extraActive:
        return 'Extra Active (very hard exercise/job)';
    }
  }
}
