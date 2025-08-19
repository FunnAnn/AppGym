import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'bottom.dart';
import '../../theme/app_colors.dart'; 
import '../../api_service/schedule_service.dart';
import '../../api_service/auth_service.dart';

Future<List<Map<String, dynamic>>> fetchSchedules() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final url = Uri.parse('https://splendid-wallaby-ethical.ngrok-free.app/schedules/get-schedules');
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

  final Map<DateTime, List<Map<String, String>>> _workoutSchedule = {};

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  Future<void> _fetchSchedules() async {
    final schedule = await ScheduleService().fetchSchedules();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pinkTheme,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'SCHEDULE WORKOUTS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [], // Remove the add button from actions
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
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/workout');
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
