import 'admin_layout.dart';
import 'package:flutter/material.dart';
import '../model/plan_exercise.dart';
import '../api_service/plan_exercise_service.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plans Exercises',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<PlanExcercise>(
                future: PlanService.fetchAllPlans(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.data == null || snapshot.data!.data!.isEmpty) {
                    return const Center(child: Text('No training plans found.'));
                  }
                  final exercises = snapshot.data!.data!;
                  print('Number of exercises: ${exercises.length}');
                  print('First exercise: ${exercises.isNotEmpty ? exercises[0].toJson() : "No data"}');
                  return ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final ex = exercises[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.fitness_center),
                          title: Text(
                            '${ex.trainingPlans?.description ?? 'No Description'} - Day ${ex.dayNumber}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Exercise: ${ex.exercise?.name ?? 'Unknown'}'),
                              Text('Coach: ${ex.coaches?.fullName ?? 'Unknown'}'),
                              Text('Customer: ${ex.customer?.fullName ?? 'Unknown'}'),
                              Text('Sets: ${ex.sets}, Reps: ${ex.reps}, Weight: ${ex.weight}kg'),
                              Text('Rest: ${ex.restTime}s'),
                              Text('Diet Plan: ${ex.trainingPlans?.dietPlan ?? 'N/A'}'),
                            ],
                          ),
                          trailing: Text('ID: ${ex.planExerciseId}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}