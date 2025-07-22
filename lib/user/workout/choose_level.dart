import 'package:flutter/material.dart';
import '../bottom_main/bottom.dart';
import 'plan_detail_screen.dart';

class ChooseLevelScreen extends StatelessWidget {
  final String? goal;
  final String? image;
  const ChooseLevelScreen({super.key, this.goal, this.image});

  List<String> getLevelImages(String? goal) {
    switch (goal) {
      case 'WEIGHT LOSS':
        return [
          'assets/images/weightlosslevel1.png',
          'assets/images/weightlosslevel2.png',
          'assets/images/weightlosslevel3.png',
          'assets/images/weightlosslevel4.png',
        ];
      case 'TONED BODY':
        return [
          'assets/images/tonedbodylevel1.png',
          'assets/images/tonedbodylevel2.png',
          'assets/images/tonedbodylevel3.png',
          'assets/images/tonedbodylevel4.png',
        ];
      // Add other goals if needed
      default:
        return [
          'assets/images/level1.png',
          'assets/images/level2.png',
          'assets/images/level3.png',
          'assets/images/level4.png',
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelImages = getLevelImages(goal);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text(
          'Difficulty Level',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                goal ?? '',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _LevelCard(
                    stars: 1,
                    title: 'NO EXPERIENCE',
                    description: '- for those who have never worked out before',
                    image: levelImages[0],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlanDetailScreen(
                            goal: goal,
                            level: 'NO EXPERIENCE',
                            image: levelImages[0],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _LevelCard(
                    stars: 2,
                    title: 'BEGINNER',
                    description: '- less than 1 year of training experience\n- irregular training',
                    image: levelImages[1],
                  ),
                  const SizedBox(height: 16),
                  _LevelCard(
                    stars: 3,
                    title: 'ADVANCED',
                    description: '- more than 1 year of training experience\n- regular training',
                    image: levelImages[2],
                  ),
                  const SizedBox(height: 16),
                  _LevelCard(
                    stars: 4,
                    title: 'EXPERT',
                    description: '- more than 2 years of training experience\n- regular training',
                    image: levelImages[3],
                  ),
                ],
              ),
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

class _LevelCard extends StatelessWidget {
  final int stars;
  final String title;
  final String description;
  final String image;
  final VoidCallback? onTap;

  const _LevelCard({
    required this.stars,
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
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                      4,
                      (index) => Icon(
                        Icons.star,
                        color: index < stars ? Colors.cyanAccent : Colors.white24,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
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