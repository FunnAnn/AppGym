import 'dart:convert';
import 'package:flutter/material.dart';
import 'bottom.dart';
import '../../theme/app_colors.dart';
import '../../api_service/auth_service.dart';
import '../../api_service/training_plan_service.dart';
import '../../model/training_plan.dart';
import '../workout/choose_location_screen.dart';

class WorkoutPlanScreen extends StatefulWidget {
  const WorkoutPlanScreen({super.key});

  @override
  State<WorkoutPlanScreen> createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {
  bool? isForFemale;
  bool _initialized = false;
  bool showGenderSelector = false;
  bool isLoading = true;

  List<Data> allPlans = [];
  bool isApiLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey('isFemale')) {
        isForFemale = args['isFemale'] as bool;
        isLoading = false;
        print('[WorkoutPlan] Got isFemale from args: $isForFemale');
      } else {
        fetchGenderFromProfile();
      }
      _initialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    // Only fetch after gender is known
    if (isForFemale != null) {
      fetchPlans();
    }
  }

  Future<void> fetchGenderFromProfile() async {
    try {
      final profileJson = await AuthService.getUserProfile();
      if (profileJson != null) {
        final profileMap = jsonDecode(profileJson);
        if (profileMap is Map && profileMap['data'] != null) {
          final data = profileMap['data'];
          bool? apiGender;
          if (data is Map && data.containsKey('gender')) {
            final g = data['gender'];
            if (g is bool) {
              apiGender = g; // API gender: false = female, true = male
            } else if (g is int) {
              apiGender = g == 1; // Convert int: 0 = female, 1 = male
            }
          }
          setState(() {
            isForFemale = apiGender == false; // API false means female, so isForFemale = true
            isLoading = false;
          });
          return;
        }
      }
    } catch (e) {
      print('Error fetching gender from profile: $e');
    }
    setState(() {
      isForFemale = false; // Default to male (API true)
      isLoading = false;
    });
  }

  Future<void> fetchPlans() async {
    setState(() => isApiLoading = true);
    try {
      final result = await PlanService.fetchAllPlans();
      allPlans = result.data ?? [];
    } catch (e) {
      // Handle error
      allPlans = [];
    }
    setState(() => isApiLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || isForFemale == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final List<Map<String, String>> plans = isForFemale!
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
        backgroundColor: AppColors.pinkTheme,
        elevation: 0,
        title: const Text(
          'WORKOUT PLANS',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status line and arrow button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  "FOR ${isForFemale! ? "FEMALE" : "MALE"}",
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    showGenderSelector
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.pinkTheme,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      showGenderSelector = !showGenderSelector;
                    });
                  },
                ),
              ],
            ),
          ),
          // Gender radio buttons
          if (showGenderSelector)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Row(
                children: [
                  _CustomRadio(
                    label: "MALE",
                    value: false,
                    groupValue: isForFemale!,
                    onChanged: (value) {
                      setState(() {
                        isForFemale = value!;
                      });
                    },
                    color: AppColors.pinkTheme,
                  ),
                  const SizedBox(width: 24),
                  _CustomRadio(
                    label: "FEMALE",
                    value: true,
                    groupValue: isForFemale!,
                    onChanged: (value) {
                      setState(() {
                        isForFemale = value!;
                      });
                    },
                    color: AppColors.pinkTheme,
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
                        builder: (_) => ChooseLocationScreen(
                          goal: plan['title'],
                          image: plan['image'],
                        ),
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

// Custom radio button widget
class _CustomRadio extends StatelessWidget {
  final String label;
  final bool value;
  final bool groupValue;
  final ValueChanged<bool?> onChanged;
  final Color color;

  const _CustomRadio({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

