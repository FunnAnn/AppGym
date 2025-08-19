import 'package:flutter/material.dart';
import '../bottom_main/bottom.dart';
import 'at_home_plan_screen.dart'; 
import 'at_gym_plan_screen.dart';

class ChooseLocationScreen extends StatelessWidget {
  final String? goal;
  final String? image;
  const ChooseLocationScreen({super.key, this.goal, this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text(
          'Workout Location',
          style: TextStyle(color: Colors.black), 
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _LocationCard(
              title: 'AT GYM',
              image: 'assets/images/gym.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AtGymPlanScreen(goal: goal, image: image),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _LocationCard(
              title: 'AT HOME',
              image: 'assets/images/home.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AtHomePlanScreen(goal: goal), // truyền goal
                  ),
                );
              },
            ),
          ],
        ),
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

class _LocationCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const _LocationCard({
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Image.asset(
              image,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}