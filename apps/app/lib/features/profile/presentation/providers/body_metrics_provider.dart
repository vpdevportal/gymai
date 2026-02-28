import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:gymai/core/di/injection.dart';
import 'package:gymai/features/profile/domain/entities/user_profile.dart';
import 'package:gymai/features/profile/domain/repositories/user_profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'body_metrics_provider.g.dart';

/// Local view of the user's body metrics, synced with Firestore.
class BodyMetrics {
  const BodyMetrics({this.height, this.weight, this.age, this.loading = false});

  final double? height; // cm
  final double? weight; // kg
  final int? age; // years
  final bool loading;

  BodyMetrics copyWith({
    double? height,
    double? weight,
    int? age,
    bool? loading,
  }) =>
      BodyMetrics(
        height: height ?? this.height,
        weight: weight ?? this.weight,
        age: age ?? this.age,
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

  String? get _userId =>
      firebase.FirebaseAuth.instance.currentUser?.uid;

  Future<void> _load() async {
    final uid = _userId;
    if (uid == null) {
      state = const BodyMetrics();
      return;
    }
    final result = await getIt<UserProfileRepository>().getProfile(userId: uid);
    result.fold(
      (_) => state = const BodyMetrics(),
      (profile) {
        if (profile != null) {
          state = BodyMetrics(
            height: profile.height,
            weight: profile.weight,
            age: profile.age,
          );
        } else {
          state = const BodyMetrics();
        }
      },
    );
  }

  Future<void> update({double? height, double? weight, int? age}) async {
    final uid = _userId;
    if (uid == null) return;

    // Optimistic update
    state = state.copyWith(height: height, weight: weight, age: age);

    final profile = UserProfile(
      userId: uid,
      height: height ?? state.height,
      weight: weight ?? state.weight,
      age: age ?? state.age,
    );

    await getIt<UserProfileRepository>().saveProfile(profile);
  }
}
