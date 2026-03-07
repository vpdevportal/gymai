import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:gymai/core/di/injection.dart';
import 'package:gymai/features/profile/domain/entities/activity_level.dart';
import 'package:gymai/features/profile/domain/entities/user_profile.dart';
import 'package:gymai/features/profile/domain/repositories/user_profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'body_metrics_provider.g.dart';

/// Local view of the user's body metrics, synced with Firestore.
class BodyMetrics {
  const BodyMetrics({
    this.height,
    this.weight,
    this.dateOfBirth,
    this.gender,
    this.activityLevel,
    this.loading = false,
  });

  final double? height; // cm
  final double? weight; // kg
  final DateTime? dateOfBirth;
  final String? gender;
  final ActivityLevel? activityLevel;
  final bool loading;

  /// Calculated age from DOB (null if DOB not set).
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    var years = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      years--;
    }
    return years;
  }

  /// Calculated BMR (Basal Metabolic Rate) using Mifflin-St Jeor Equation
  int? get bmr {
    if (weight == null || height == null || age == null || gender == null) return null;
    final base = (10 * weight!) + (6.25 * height!) - (5 * age!);
    if (gender == 'Male') {
      return (base + 5).round();
    } else {
      return (base - 161).round();
    }
  }

  /// Calculated TDEE (Total Daily Energy Expenditure)
  int? get tdee {
    final currentBmr = bmr;
    final actLevel = activityLevel;
    if (currentBmr == null || actLevel == null) return null;
    return (currentBmr * actLevel.multiplier).round();
  }

  BodyMetrics copyWith({
    double? height,
    double? weight,
    DateTime? dateOfBirth,
    String? gender,
    ActivityLevel? activityLevel,
    bool? loading,
  }) => BodyMetrics(
    height: height ?? this.height,
    weight: weight ?? this.weight,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    gender: gender ?? this.gender,
    activityLevel: activityLevel ?? this.activityLevel,
    loading: loading ?? this.loading,
  );
}

@riverpod
class BodyMetricsNotifier extends _$BodyMetricsNotifier {
  @override
  BodyMetrics build() {
    _load();
    return const BodyMetrics(loading: true);
  }

  String? get _userId => firebase.FirebaseAuth.instance.currentUser?.uid;

  Future<void> _load() async {
    final uid = _userId;
    if (uid == null) {
      state = const BodyMetrics();
      return;
    }
    final result = await getIt<UserProfileRepository>().getProfile(userId: uid);
    result.fold((_) => state = const BodyMetrics(), (profile) {
      if (profile != null) {
        state = BodyMetrics(
          height: profile.height,
          weight: profile.weight,
          dateOfBirth: profile.dateOfBirth,
          gender: profile.gender,
          activityLevel: profile.activityLevel,
        );
      } else {
        state = const BodyMetrics();
      }
    });
  }

  Future<void> update({
    double? height,
    double? weight,
    DateTime? dateOfBirth,
    String? gender,
    ActivityLevel? activityLevel,
  }) async {
    final uid = _userId;
    if (uid == null) return;

    // Optimistic update
    state = state.copyWith(
      height: height,
      weight: weight,
      dateOfBirth: dateOfBirth,
      gender: gender,
      activityLevel: activityLevel,
    );

    final profile = UserProfile(
      userId: uid,
      height: state.height,
      weight: state.weight,
      dateOfBirth: state.dateOfBirth,
      gender: state.gender,
      activityLevel: state.activityLevel,
    );

    await getIt<UserProfileRepository>().saveProfile(profile);
  }
}
