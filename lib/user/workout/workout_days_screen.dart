import 'package:flutter/material.dart';
import '../bottom_main/bottom.dart';
import '../../theme/app_colors.dart';
import 'workout_detail_screen.dart';

class WorkoutDaysScreen extends StatefulWidget {
  final String? planTitle;
  final String? image;
  const WorkoutDaysScreen({super.key, this.planTitle, this.image});

  @override
  State<WorkoutDaysScreen> createState() => _WorkoutDaysScreenState();
}

class _WorkoutDaysScreenState extends State<WorkoutDaysScreen> {
  int workoutsCompleted = 0;
  List<Map<String, dynamic>> days = [];

  @override
  void initState() {
    super.initState();
    final titles = ['Upper Body', 'Legs + Shoulders', 'Full Body'];
    days = List.generate(24, (index) {
      return {
        'title': titles[index % 3], // Lặp theo chu kỳ 3 ngày
        'unlocked': index == 0,
        'percent': 0,
      };
    });
  }

  void _openDetail(int index) async {
    // Danh sách bài tập cho từng ngày
    List<List<Map<String, String>>> allExercises = [
      // Ngày 1
      [
        {
          'title': 'Jump rope',
          'title-en': 'Jump rope',
          'set': '3x30',
        },
        {
          'title': 'Incline dumbbell bench press (30 degrees)',
          'title-en': 'Incline dumbbell bench press (30 degrees)',
          'set': '2x10x4 kg',
        },
        {
          'title': 'TRX row',
          'title-en': 'TRX row',
          'set': '2x10',
        },
        {
          'title': 'Bench triceps dips',
          'title-en': 'Bench triceps dips',
          'set': '2x10',
        },
        {
          'title': 'Biceps curl with resistance band',
          'title-en': 'Biceps curl with resistance band',
          'set': '2x10',
        },
        {
          'title': 'Flutter kicks',
          'title-en': 'Flutter kicks',
          'set': '2x10',
        },
        {
          'title': 'Push-ups',
          'title-en': 'Push-ups',
          'set': '3x10',
        },
        {
          'title': 'Chest Stretch',
          'title-en': 'Chest Stretch',
          'set': '1x20 seconds',
        },
        {
          'title': 'Shoulder Stretch',
          'title-en': 'Shoulder Stretch',
          'set': '1x20 seconds',
        },
        {
          'title': 'Triceps Stretch',
          'title-en': 'Triceps Stretch',
          'set': '1x20 seconds',
        },
        {
          'title': 'Abdominal and Lower Back Stretch',
          'title-en': 'Abdominal and Lower Back Stretch',
          'set': '1x20 seconds',
        },
      ],
      // Ngày 2
      [
        {
          'title': 'Mountain Climber',
          'title-en': 'Mountain Climber',
          'set': '3x15',
        },
        {
          'title': 'Squats',
          'title-en': 'Squats',
          'set': '3x10',
        },
        {
          'title': 'Glute Bridge',
          'title-en': 'Glute Bridge',
          'set': '3x10',
        },
        {
          'title': 'Lunges',
          'title-en': 'Lunges',
          'set': '3x10 each leg',
        },
        {
          'title': 'Standing Dumbbell Shoulder Press',
          'title-en': 'Standing Dumbbell Shoulder Press',
          'set': '3x10x4 kg',
        },
        {
          'title': 'Plank Shoulder Taps',
          'title-en': 'Plank Shoulder Taps',
          'set': '3x10 each side',
        },
        {
          'title': 'Kneeling Glute Kickback',
          'title-en': 'Kneeling Glute Kickback',
          'set': '3x10 each leg',
        },
        {
          'title': 'Leg Swings',
          'title-en': 'Leg Swings',
          'set': '3x10 each leg',
        },
        {
          'title': 'Glute Bridge',
          'title-en': 'Glute Bridge',
          'set': '3x15',
        },
        {
          'title': 'Calf Raises',
          'title-en': 'Calf Raises',
          'set': '3x15',
        },
        {
          'title': 'Leg Raises',
          'title-en': 'Leg Raises',
          'set': '3x12',
        },
        {
          'title': 'Seated Dumbbell Shoulder Lateral Raise',
          'title-en': 'Seated Dumbbell Shoulder Lateral Raise',
          'set': '3x10x3 kg',
        },
        {
          'title': 'Hamstring Stretch',
          'title-en': 'Hamstring Stretch',
          'set': '1x20 seconds each side',
        },
      ],
      // ... tiếp tục cho các ngày tiếp theo ...
    ];

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutDetailScreen(
          dayTitle: days[index]['title'],
          duration: '~ 38min', // hoặc days[index]['duration'] nếu bạn có
          exercises: allExercises.length > index
              ? allExercises[index]
              : allExercises[0], // fallback nếu chưa khai báo đủ
          percent: days[index]['percent'] ?? 0, // <-- Pass the current percent
        ),
      ),
    );
    if (result == true) {
      setState(() {
        days[index]['percent'] = 100;
        if (index + 1 < days.length) {
          days[index + 1]['unlocked'] = true;
        }
        workoutsCompleted += 1;
      });
    }
  }

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Image.asset(
                  widget.image ?? 'assets/images/weightlosslevel1.png',
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
                Positioned(
                  left: 20,
                  top: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MUSCULAR PHYSIQUE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.home, color: Colors.white, size: 18),
                          const SizedBox(width: 6),
                          const Text(
                            'At home',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: List.generate(
                              4,
                              (index) => Icon(
                                Icons.star,
                                color: index == 0 ? Colors.white24 : Colors.white24,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'No experience',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '24 workout days (3 sessions per week)', // duration here
                        style: TextStyle(color: Color(0xFF1CCFC9), fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Workouts completed: $workoutsCompleted',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Workout Days',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(days.length, (index) {
            final day = days[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: day['unlocked'] == true
                      ? AppColors.pinkTheme
                      : AppColors.pinkTheme.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pinkTheme.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (day['unlocked'] == true)
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.pinkTheme, width: 2),
                      ),
                      child: Text(
                        '${day['percent'] ?? 0}%',
                        style: TextStyle(
                          color: AppColors.pinkTheme,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Icon(Icons.lock, color: AppColors.pinkTheme, size: 32),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Day ${index + 1}',
                        style: TextStyle(
                          color: AppColors.pinkTheme,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        (day['title'] as String?) ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      if (day['unlocked'] == true) {
                        _openDetail(index);
                      }
                    },
                    child: Text(
                      'Details',
                      style: TextStyle(
                        color: AppColors.pinkTheme,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
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