import 'package:flutter/material.dart';
import '../bottom_main/bottom.dart';
import 'choose_level.dart';

class ChooseEquipmentScreen extends StatelessWidget {
  final String? goal;
  final String? image;
  const ChooseEquipmentScreen({super.key, this.goal, this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text(
          'Workout Equipment',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _EquipmentCard(
              title: 'BASIC EQUIPMENT',
              description: '- dumbbells, weights, barbell\n- ab wheel, resistance band, mat',
              image: 'assets/images/equipment1.png',
              onTap: () {
                if (goal == 'WEIGHT LOSS' || goal == 'TONED BODY') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChooseLevelScreen(
                        goal: goal,
                        image: image,
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            _EquipmentCard(
              title: 'NO EQUIPMENT',
              description: '- when you have no equipment and don\'t need any\n- mat',
              image: 'assets/images/equipment2.png',
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

class _EquipmentCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final VoidCallback? onTap;

  const _EquipmentCard({
    required this.title,
    required this.description,
    required this.image,
    this.onTap,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}