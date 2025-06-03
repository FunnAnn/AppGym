import 'package:flutter/material.dart';
import 'bottom.dart';
import '../choose_location.dart';
import '../../theme/app_colors.dart';

class WorkoutPlanScreen extends StatefulWidget {
  const WorkoutPlanScreen({super.key});

  @override
  State<WorkoutPlanScreen> createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {
  bool showFilter = false;
  bool isForFemale = true;
  bool groupByGoal = true;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> plans = isForFemale
        ? [
            {
              'title': 'WEIGHT LOSS',
              'image': 'assets/images/plan_weight_loss.jpg',
            },
            {
              'title': 'TONED BODY',
              'image': 'assets/images/plan_sharp_body.jpg',
            },
            {
              'title': 'PERFECT GLUTES',
              'image': 'assets/images/plan_perfect_butt.jpg',
            },
            {
              'title': 'SIX PACK ABS',
              'image': 'assets/images/plan_six_packs.jpg',
            },
          ]
        : [
            {
              'title': 'MUSCLE GAIN',
              'image': 'assets/images/plan_muscle_gain.jpg',
            },
            {
              'title': 'BIG ARMS',
              'image': 'assets/images/plan_big_arms.jpg',
            },
            {
              'title': 'STRONG CHEST',
              'image': 'assets/images/plan_strong_chest.jpg',
            },
            {
              'title': 'WIDE BACK',
              'image': 'assets/images/plan_wide_back.jpg',
            },
          ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Choose your workout plan',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showFilter = !showFilter;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isForFemale ? 'FEMALE' : 'MALE',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    showFilter ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.blueGrey,
                  ),
                ],
              ),
            ),
          ),
          if (showFilter)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isForFemale = false;
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              'FOR MALE',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              isForFemale
                                  ? Icons.radio_button_off
                                  : Icons.radio_button_checked,
                              color: isForFemale ? AppColors.pinkTheme : AppColors.pinkTheme,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isForFemale = true;
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              'FOR FEMALE',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              isForFemale
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: isForFemale ? AppColors.pinkTheme : AppColors.pinkTheme,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: plans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final plan = plans[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChooseLocationScreen(),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          plan['image']!,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                        Text(
                          plan['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            // Already on this page, do nothing
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/calendar');
          } else if (index == 2) {
            // Handle "Scan QR" button tap
            // Example: showDialog(context: context, builder: (_) => ...);
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
