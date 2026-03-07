import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:gymai/core/router/app_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.fitness_center),
                  title: const Text('AI Workout Plans'),
                  subtitle: const Text('Generate a custom workout plan using AI'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => context.goNamed(AppRoutes.workoutName),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
