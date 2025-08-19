import 'package:flutter/material.dart';
import '../../api_service/plan_exercise_service.dart';
import '../../model/plan_exercise.dart';
import 'at_home_day_detail_screen.dart'; 
import '../bottom_main/bottom.dart';
import '../../theme/app_colors.dart';

class AtHomePlanScreen extends StatefulWidget {
  final String? goal;
  final String? image;
  const AtHomePlanScreen({super.key, this.goal, this.image});

  @override
  State<AtHomePlanScreen> createState() => _AtHomePlanScreenState();
}

class _AtHomePlanScreenState extends State<AtHomePlanScreen> {
  late Future<List<Data>> _futurePlans;

  @override
  void initState() {
    super.initState();
    _futurePlans = PlanService.fetchAtHomePlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Text(
          widget.goal ?? 'AT HOME Workout Plans',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Data>>(
        future: _futurePlans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final plans = snapshot.data ?? [];
          final filteredPlans = widget.goal == null
              ? plans
              : plans.where((plan) =>
                  plan.trainingPlans?.description?.toUpperCase() == widget.goal?.toUpperCase()
                ).toList();
          if (filteredPlans.isEmpty) {
            return const Center(child: Text('No AT HOME plans found.'));
          }
          // Group by dayNumber
          final groupedByDay = <int, List<Data>>{};
          for (var plan in filteredPlans) {
            final day = plan.dayNumber ?? 0;
            groupedByDay.putIfAbsent(day, () => []).add(plan);
          }
          final sortedDays = groupedByDay.keys.toList()..sort();

          return ListView(
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
                          Text(
                            widget.goal ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${sortedDays.length} workout days',
                            style: const TextStyle(
                                color: Color(0xFF1CCFC9),
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
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
              ...sortedDays.map((dayNumber) {
                final dayPlans = groupedByDay[dayNumber]!;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.pinkTheme, // Sử dụng màu chủ đạo
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.pinkThemeLight.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.pinkTheme, width: 2), // Sử dụng màu chủ đạo
                        ),
                        child: const Text(
                          '0%', // Add progress if you track it
                          style: TextStyle(
                            color: AppColors.pinkTheme, // Sử dụng màu chủ đạo
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Day $dayNumber',
                            style: TextStyle(
                              color: AppColors.pinkTheme,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            dayPlans.first.exercise?.muscleGroup ?? '',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AtHomeDayDetailScreen(
                                dayNumber: dayNumber,
                                exercises: dayPlans,
                              ),
                            ),
                          );
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
              }).toList(),
            ],
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