import 'package:dartz/dartz.dart';
import 'package:gymai/core/error/failures.dart';
import 'package:gymai/features/workout/domain/entities/workout_plan.dart';

abstract class WorkoutRepository {
  Future<Either<Failure, WorkoutPlanResponse>> generateWorkoutPlan({
    required int age,
    required double weight,
    required double height,
    required String gender,
    required String activityLevel,
    required String goal,
  });
}
