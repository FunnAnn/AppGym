import 'package:flutter/material.dart';
import '../../theme/app_colors.dart'; 
import '../bottom_main/bottom.dart';
import '../workout/workout_days_screen.dart';
import '../bottom_main/calendar.dart';

class PlanDetailScreen extends StatelessWidget {
  final String? goal;
  final String? level;
  final String? image;
  const PlanDetailScreen({super.key, this.goal, this.level, this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text(
          'Workout Plan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                image ?? 'assets/images/weightlosslevel1.png',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Muscular Physique',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '• 24 workout days (3 sessions per week)',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Detailed nutrition and meal guidance',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Recommended fitness supplements',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Type: ',
                          style: TextStyle(
                            color: Color.fromARGB(255, 4, 3, 3),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'for women, at home, no experience',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pinkTheme,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutDaysScreen(
                        planTitle: goal,
                        image: image,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'START WORKOUT',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Bad weather makes you not want to go to the gym, but you still want a beautiful and toned body. Don\'t worry, as long as you are diligent and disciplined, you can achieve great results at home with just a few pieces of equipment. All you need is the right workout method to get the best results.\n\nThis plan is designed for women with no workout experience. The program includes detailed instructions for effective exercises and helps you gradually get used to the training pace without injury or overload. To make the exercises even more effective, our experts have provided some recommendations on diet and sports supplements for you.\n\nIn addition, regular exercise also improves overall health, boosts energy, and enhances your mood. So, what are you waiting for? Start now!',
              style: TextStyle(color: Colors.black87, fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            // Already on this page
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/calendar');
          } else if (index == 2) {
            // Handle "Scan QR" button if needed
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