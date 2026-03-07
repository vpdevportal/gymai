class WorkoutExercise {
  final String name;
  final int sets;
  final String reps;
  final String rest;
  final String? notes;

  WorkoutExercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.rest,
    this.notes,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      name: json['name'] as String,
      sets: json['sets'] as int,
      reps: json['reps'] as String,
      rest: json['rest'] as String,
      notes: json['notes'] as String?,
    );
  }
}

class WorkoutDayPlan {
  final String day;
  final String focus;
  final List<WorkoutExercise> exercises;

  WorkoutDayPlan({
    required this.day,
    required this.focus,
    required this.exercises,
  });

  factory WorkoutDayPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutDayPlan(
      day: json['day'] as String,
      focus: json['focus'] as String,
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class WorkoutPlanResponse {
  final String planName;
  final String description;
  final List<WorkoutDayPlan> days;

  WorkoutPlanResponse({
    required this.planName,
    required this.description,
    required this.days,
  });

  factory WorkoutPlanResponse.fromJson(Map<String, dynamic> json) {
    return WorkoutPlanResponse(
      planName: json['planName'] ?? 'Workout Plan',
      description: json['description'] ?? '',
      days: (json['days'] as List<dynamic>?)
              ?.map((e) => WorkoutDayPlan.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
