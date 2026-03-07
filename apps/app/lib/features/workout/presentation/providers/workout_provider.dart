import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymai/core/di/injection.dart';
import 'package:gymai/features/profile/presentation/providers/body_metrics_provider.dart';
import 'package:gymai/features/workout/domain/entities/workout_plan.dart';
import 'package:gymai/features/workout/domain/repositories/workout_repository.dart';

final workoutNotifierProvider = AsyncNotifierProvider<WorkoutNotifier, WorkoutPlanResponse?>(() {
  return WorkoutNotifier();
});

class WorkoutNotifier extends AsyncNotifier<WorkoutPlanResponse?> {
  late final WorkoutRepository _repository;

  @override
  FutureOr<WorkoutPlanResponse?> build() {
    _repository = getIt<WorkoutRepository>();
    return null;
  }

  Future<void> generatePlan() async {
    state = const AsyncValue.loading();
    
    // Read the body metrics state directly
    final metrics = ref.read(bodyMetricsProvider);
    
    if (metrics.loading) {
      state = AsyncValue.error('Still loading profile data...', StackTrace.current);
      return;
    }

    if (metrics.age == null || metrics.weight == null || metrics.height == null || metrics.gender == null || metrics.activityLevel == null) {
      state = AsyncValue.error('Please complete your profile metrics (age, weight, height, gender, activity) first.', StackTrace.current);
      return;
    }

    final result = await _repository.generateWorkoutPlan(
      age: metrics.age!,
      weight: metrics.weight!,
      height: metrics.height!,
      gender: metrics.gender!,
      activityLevel: metrics.activityLevel!.name,
      goal: 'General Fitness', // Placeholder
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (plan) {
        state = AsyncValue.data(plan);
      },
    );
  }
}
