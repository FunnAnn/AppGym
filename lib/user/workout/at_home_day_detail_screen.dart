import 'package:flutter/material.dart';
import '../../model/plan_exercise.dart';
import '../bottom_main/bottom.dart';
import '../../theme/app_colors.dart';
import 'exercise_video_screen.dart';
import '../../api_service/plan_exercise_service.dart';

class AtHomeDayDetailScreen extends StatelessWidget {
  final int dayNumber;
  final List<Data> exercises;
  const AtHomeDayDetailScreen({super.key, required this.dayNumber, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Day $dayNumber Exercises'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final ex = exercises[idx].exercise;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.pinkTheme,
              child: Text(
                '${idx + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(ex?.name ?? ''),
            subtitle: Text(ex?.description ?? ''),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Sets: ${exercises[idx].sets ?? '-'}'),
                Text('Reps: ${exercises[idx].reps ?? '-'}'),
                if ((exercises[idx].weight ?? 0) != 0)
                  Text('Weight: ${exercises[idx].weight}'),
              ],
            ),
            onTap: () {
              if (ex?.videoUrl != null && ex!.videoUrl!.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExerciseVideoScreen(
                      videoUrl: ex.videoUrl!,
                      title: ex.name,
                      planExerciseId: exercises[idx].planExerciseId!, 
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No valid video available for this exercise')),
                );
              }
            },
          );
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/workout');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/calendar');
          } else if (index == 2) {
            showQRDialog(context);
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/package');
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/account');
          }
        },
      ),
    );
  }
}