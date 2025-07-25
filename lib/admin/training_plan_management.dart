import 'package:flutter/material.dart';
import 'admin_layout.dart';
import '../api_service/training_plan_service.dart';
import '../model/training_plan.dart';

class TrainingPlanManagementPage extends StatelessWidget {
  const TrainingPlanManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Training Plans',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<TrainingPlan>(
                future: PlanService.fetchAllPlans(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.data == null || snapshot.data!.data!.isEmpty) {
                    return const Center(child: Text('No training plans found.'));
                  }
                  final plans = snapshot.data!.data!;
                  return ListView.builder(
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.fitness_center),
                          title: Text(plan.description ?? 'No Description'),
                          subtitle: Text('Diet Plan: ${plan.dietPlan ?? 'N/A'}'),
                          trailing: Text('ID: ${plan.planId}'),
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