import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymai/features/workout/domain/entities/workout_plan.dart';
import 'package:gymai/features/workout/presentation/providers/workout_provider.dart';

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(workoutNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Workout Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(workoutNotifierProvider.notifier).generatePlan(),
            tooltip: 'Regenerate Plan',
          ),
        ],
      ),
      body: SafeArea(
        child: workoutState.when(
          data: (plan) {
            if (plan == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.fitness_center, size: 64, color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      'Ready to get fit?',
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Generate a custom AI workout plan based on your profile, goals, and experience level.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => ref.read(workoutNotifierProvider.notifier).generatePlan(),
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Generate My Plan'),
                    ),
                  ],
                ),
              );
            }
            return _buildWorkoutPlan(context, plan);
          },
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text('Failed to generate plan', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(error.toString(), textAlign: TextAlign.center, style: TextStyle(color: theme.colorScheme.error)),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => ref.read(workoutNotifierProvider.notifier).generatePlan(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ),
          loading: () => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Analyzing your profile and generating an optimal plan...'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutPlan(BuildContext context, WorkoutPlanResponse plan) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          plan.planName,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          plan.description,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        ...plan.days.map((dayPlan) => _buildDayCard(context, dayPlan)),
      ],
    );
  }

  Widget _buildDayCard(BuildContext context, WorkoutDayPlan dayPlan) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          dayPlan.day,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          dayPlan.focus,
          style: TextStyle(color: theme.colorScheme.secondary),
        ),
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dayPlan.exercises.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final exercise = dayPlan.exercises[index];
              return ListTile(
                title: Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _Badge(text: '${exercise.sets} sets'),
                        const SizedBox(width: 8),
                        _Badge(text: exercise.reps),
                        const SizedBox(width: 8),
                        _Badge(text: '${exercise.rest} rest'),
                      ],
                    ),
                    if (exercise.notes != null && exercise.notes!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(exercise.notes!, style: const TextStyle(fontStyle: FontStyle.italic)),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {

  const _Badge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
