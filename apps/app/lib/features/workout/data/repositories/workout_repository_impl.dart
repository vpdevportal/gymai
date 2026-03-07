import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:gymai/core/error/failures.dart';
import 'package:gymai/features/workout/domain/entities/workout_plan.dart';
import 'package:gymai/features/workout/domain/repositories/workout_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: WorkoutRepository)
class WorkoutRepositoryImpl implements WorkoutRepository {
  WorkoutRepositoryImpl();

  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  @override
  Future<Either<Failure, WorkoutPlanResponse>> generateWorkoutPlan({
    required int age,
    required double weight,
    required double height,
    required String gender,
    required String activityLevel,
    required String goal,
  }) async {
    try {
      final callable = _functions.httpsCallable('generateWorkoutPlan');
      
      final response = await callable.call({
        'age': age,
        'weight': weight,
        'height': height,
        'gender': gender,
        'activity_level': activityLevel,
        'goal': goal,
        'days_per_week': 4,
        'experience_level': 'Beginner', 
      });

      final responseData = 
          Map<String, dynamic>.from(response.data as Map);

      final plan = WorkoutPlanResponse.fromJson(responseData);
      return Right(plan);
    } on FirebaseFunctionsException catch (e) {
      return Left(ServerFailure(
        message: e.message ?? 'Failed to generate workout plan via Cloud Functions',
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: $e'));
    }
  }
}
