import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'bottom.dart';
import '../../theme/app_colors.dart'; 
import '../workout/plan_detail_screen.dart';
import '../../api_service/schedule_service.dart';

Future<List<Map<String, dynamic>>> fetchSchedules() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final url = Uri.parse('YOUR_BASE_URL/schedules/get-schedules');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    return List<Map<String, dynamic>>.from(jsonData['data']);
  }
  return [];
}

class WorkoutCalendarPage extends StatefulWidget {
  final List<DateTime>? workoutDays;
  const WorkoutCalendarPage({Key? key, this.workoutDays}) : super(key: key);

  @override
  State<WorkoutCalendarPage> createState() => _WorkoutCalendarPageState();
}

class _WorkoutCalendarPageState extends State<WorkoutCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now(); 

  final Map<DateTime, List<Map<String, String>>> _workoutSchedule = {
    DateTime.utc(2025, 5, 1): [
      {'type': 'Upper Body', 'coach': 'With Coach'},
    ],
    DateTime.utc(2025, 5, 3): [
      {'type': 'Cardio'},
    ],
    DateTime.utc(2025, 5, 5): [
      {'type': 'Lower Body', 'coach': 'With Coach'},
    ],
    DateTime.utc(2025, 5, 7): [
      {'type': 'Yoga'},
    ],
    DateTime.utc(2025, 5, 10): [
      {'type': 'Full Body', 'coach': 'With Coach'},
    ],
    DateTime.utc(2025, 5, 15): [
      {'type': 'Cardio'},
      {'type': 'Upper Body', 'coach': 'With Coach'},
    ],
    DateTime.utc(2025, 5, 20): [
      {'type': 'Lower Body'},
    ],
    DateTime.utc(2025, 5, 25): [
      {'type': 'Stretching', 'coach': 'With Coach'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  Future<void> _fetchSchedules() async {
    final service = ScheduleService();
    final schedule = await service.fetchSchedules();
    if (schedule != null && schedule.data != null) {
      setState(() {
        _workoutSchedule.clear();
        for (final item in schedule.data!) {
          if (item.startDate != null) {
            final date = DateTime.tryParse(item.startDate!);
            if (date != null) {
              final key = DateTime.utc(date.year, date.month, date.day);
              final workout = {
                'type': item.title ?? '',
                'coach': item.description ?? '',
              };
              if (_workoutSchedule.containsKey(key)) {
                _workoutSchedule[key]!.add(workout);
              } else {
                _workoutSchedule[key] = [workout];
              }
            }
          }
        }
      });
    }
  }

  List<Map<String, String>> _getWorkoutsForDay(DateTime day) {
    return _workoutSchedule[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  void _addWorkout(DateTime day, Map<String, String> workout) {
    final key = DateTime.utc(day.year, day.month, day.day);
    setState(() {
      if (_workoutSchedule.containsKey(key)) {
        _workoutSchedule[key]!.add(workout);
      } else {
        _workoutSchedule[key] = [workout];
      }
    });
  }

  void _showAddWorkoutDialog() {
    final _typeController = TextEditingController();
    bool _withCoach = false;
    TimeOfDay? _selectedTime;
    final _timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Workout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Workout Title'),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime ?? TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedTime = picked;
                      _timeController.text = picked.format(context);
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _timeController,
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      suffixIcon: Icon(Icons.access_time),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: _withCoach,
                    onChanged: (value) {
                      setState(() {
                        _withCoach = value ?? false;
                      });
                    },
                  ),
                  const Text('With Coach'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final userMe = json.decode(prefs.getString('user_me') ?? '{}');
                final customerId = userMe['data']['user_id'];
                final coachId = userMe['data']['coach_customers'][0]['coach_id'];

                final selectedDay = _selectedDay ?? DateTime.now();
                final startDate = DateTime(
                  selectedDay.year,
                  selectedDay.month,
                  selectedDay.day,
                  _selectedTime?.hour ?? 8,
                  _selectedTime?.minute ?? 0,
                );
                final endDate = startDate.add(const Duration(hours: 1));

                final success = await ScheduleService().createSchedule(
                  customerId: customerId,
                  coachId: coachId,
                  title: _typeController.text.trim(),
                  startDate: startDate.toIso8601String(),
                  endDate: endDate.toIso8601String(),
                  description: _withCoach ? 'With Coach' : '',
                );
                if (success) {
                  await _fetchSchedules();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to create schedule')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddWorkoutDialog, // <-- luôn cho phép bấm
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1), 
            lastDay: DateTime.utc(2100, 12, 31), 
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: (day) => _getWorkoutsForDay(day),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.pinkTheme.withOpacity(0.15), 
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppColors.pinkTheme,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: AppColors.pinkTheme,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _selectedDay == null
                ? const Center(child: Text('Select a day to view workouts'))
                : ListView(
                    children: _getWorkoutsForDay(_selectedDay!).map((workout) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.fitness_center),
                          title: Text(workout['type'] ?? ''),
                          subtitle: workout['coach'] != null
                              ? Text('Coach: ${workout['coach']}')
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 1, // "Workout Calendar" tab
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/workout');
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
