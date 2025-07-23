import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'layout_coach.dart';
import '../theme/app_colors.dart';
import '../api_service/auth_service.dart';


class DashboardCoachPage extends StatefulWidget {
  const DashboardCoachPage({Key? key}) : super(key: key);

  @override
  State<DashboardCoachPage> createState() => _DashboardCoachPageState();
}

class _DashboardCoachPageState extends State<DashboardCoachPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now(); // Mặc định chọn ngày hiện tại

  // Events không giới hạn trong tháng 5
  final Map<DateTime, List<Map<String, String>>> _events = {
    // Tháng 1/2025
    DateTime.utc(2025, 1, 15): [
      {'type': 'Gym Maintenance', 'time': '09:00', 'location': 'Main Gym'},
      {'type': 'Staff Meeting', 'time': '14:00', 'location': 'Conference Room'},
    ],
    DateTime.utc(2025, 1, 20): [
      {'type': 'New Member Orientation', 'time': '10:00', 'location': 'Reception'},
    ],
    
    // Tháng 2/2025
    DateTime.utc(2025, 2, 14): [
      {'type': 'Valentine Workout Event', 'time': '18:00', 'location': 'Main Gym'},
    ],
    DateTime.utc(2025, 2, 28): [
      {'type': 'Monthly Review', 'time': '15:00', 'location': 'Office'},
    ],
    
    // Tháng 3/2025
    DateTime.utc(2025, 3, 8): [
      {'type': 'Women\'s Day Special Class', 'time': '10:00', 'location': 'Studio A'},
    ],
    DateTime.utc(2025, 3, 15): [
      {'type': 'Equipment Inspection', 'time': '08:00', 'location': 'All Areas'},
    ],
    
    // Tháng 4/2025
    DateTime.utc(2025, 4, 1): [
      {'type': 'April Fitness Challenge', 'time': '17:00', 'location': 'Main Gym'},
    ],
    DateTime.utc(2025, 4, 15): [
      {'type': 'Coach Training Session', 'time': '09:00', 'location': 'Studio B'},
    ],
    
    // Tháng 5/2025
    DateTime.utc(2025, 5, 1): [
      {'type': 'One-on-one meeting', 'time': '09:00', 'location': 'Office'},
      {'type': 'Gym workout', 'time': '18:00', 'location': 'Main Gym'},
    ],
    DateTime.utc(2025, 5, 3): [
      {'type': 'Book club meeting', 'time': '19:00', 'location': 'Lounge'},
    ],
    DateTime.utc(2025, 5, 5): [
      {'type': 'Office relocation', 'time': '10:00', 'location': 'Admin Office'},
    ],
    DateTime.utc(2025, 5, 6): [
      {'type': 'Dental cleaning', 'time': '14:00', 'location': 'External'},
    ],
    DateTime.utc(2025, 5, 7): [
      {'type': 'Hiking expedition', 'time': '07:00', 'location': 'Mountain Trail'},
    ],
    DateTime.utc(2025, 5, 8): [
      {'type': 'Movie night', 'time': '20:00', 'location': 'Recreation Room'},
    ],
    DateTime.utc(2025, 5, 10): [
      {'type': 'Flight departure', 'time': '06:00', 'location': 'Airport'},
      {'type': 'Gym workout', 'time': '17:00', 'location': 'Main Gym'},
    ],
    DateTime.utc(2025, 5, 15): [
      {'type': 'Graduation ceremony', 'time': '10:00', 'location': 'University'},
      {'type': 'Dental cleaning', 'time': '15:00', 'location': 'Clinic'},
    ],
    DateTime.utc(2025, 5, 20): [
      {'type': 'Customer support', 'time': '09:00', 'location': 'Help Desk'},
      {'type': 'Physical therapy session', 'time': '16:00', 'location': 'Therapy Room'},
    ],
    DateTime.utc(2025, 5, 27): [
      {'type': 'Budget review', 'time': '14:00', 'location': 'Finance Office'},
      {'type': 'Book club meeting', 'time': '19:00', 'location': 'Lounge'},
    ],
    DateTime.utc(2025, 5, 31): [
      {'type': 'Financial planning', 'time': '10:00', 'location': 'Finance Office'},
      {'type': 'Code review', 'time': '15:00', 'location': 'IT Department'},
    ],
    
    // Tháng 6/2025
    DateTime.utc(2025, 6, 1): [
      {'type': 'Summer Program Launch', 'time': '10:00', 'location': 'Main Gym'},
    ],
    DateTime.utc(2025, 6, 15): [
      {'type': 'Mid-year Performance Review', 'time': '14:00', 'location': 'Conference Room'},
    ],
    DateTime.utc(2025, 6, 21): [
      {'type': 'Summer Solstice Yoga', 'time': '06:00', 'location': 'Outdoor Area'},
    ],
    
    // Tháng 7/2025
    DateTime.utc(2025, 7, 4): [
      {'type': 'Independence Day Event', 'time': '18:00', 'location': 'Main Gym'},
    ],
    DateTime.utc(2025, 7, 18): [
      {'type': 'Equipment Upgrade', 'time': '08:00', 'location': 'Cardio Section'},
    ],
    
    // Tháng 8/2025
    DateTime.utc(2025, 8, 10): [
      {'type': 'Back to School Promo', 'time': '09:00', 'location': 'Reception'},
    ],
    DateTime.utc(2025, 8, 25): [
      {'type': 'Fitness Assessment Day', 'time': '10:00', 'location': 'Assessment Room'},
    ],
    
    // Tháng 9/2025
    DateTime.utc(2025, 9, 1): [
      {'type': 'September Challenge Launch', 'time': '17:00', 'location': 'Main Gym'},
    ],
    DateTime.utc(2025, 9, 15): [
      {'type': 'Quarterly Business Review', 'time': '13:00', 'location': 'Conference Room'},
    ],
    
    // Tháng 10/2025
    DateTime.utc(2025, 10, 31): [
      {'type': 'Halloween Costume Workout', 'time': '19:00', 'location': 'Main Gym'},
    ],
    
    // Tháng 11/2025
    DateTime.utc(2025, 11, 15): [
      {'type': 'Thanksgiving Prep Event', 'time': '16:00', 'location': 'Kitchen'},
    ],
    DateTime.utc(2025, 11, 28): [
      {'type': 'Black Friday Sale', 'time': '00:00', 'location': 'Reception'},
    ],
    
    // Tháng 12/2025
    DateTime.utc(2025, 12, 25): [
      {'type': 'Christmas Day - Closed', 'time': '00:00', 'location': 'All Areas'},
    ],
    DateTime.utc(2025, 12, 31): [
      {'type': 'New Year\'s Eve Party', 'time': '22:00', 'location': 'Main Gym'},
    ],
  };

  List<Map<String, String>> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  void _addEvent(DateTime day, Map<String, String> event) {
    final key = DateTime.utc(day.year, day.month, day.day);
    setState(() {
      if (_events.containsKey(key)) {
        _events[key]!.add(event);
      } else {
        _events[key] = [event];
      }
    });
  }

  void _showAddEventDialog() {
    final _typeController = TextEditingController();
    final _timeController = TextEditingController();
    final _locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(
                labelText: 'Event Type',
                hintText: 'e.g., Staff Meeting',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Time',
                hintText: 'e.g., 09:00',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'e.g., Conference Room',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final event = {
                'type': _typeController.text.trim(),
                'time': _timeController.text.trim(),
                'location': _locationController.text.trim(),
              };
              if (event['type']!.isNotEmpty && _selectedDay != null) {
                _addEvent(_selectedDay!, event);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutCoach(
      body: Column(
        children: [
          AppBar(
            title: const Text('Dashboard Calendar'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _showAddEventDialog,
              ),
            ],
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
            elevation: 0,
          ),
          Expanded(
            child: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2000, 1, 1), // Không giới hạn từ năm 2000
                  lastDay: DateTime.utc(2100, 12, 31), // Đến năm 2100
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
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
                  eventLoader: (day) => _getEventsForDay(day),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.pink,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: Colors.pink,
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
                      ? const Center(child: Text('Chọn ngày để xem sự kiện'))
                      : ListView(
                          children: _getEventsForDay(_selectedDay!).map((event) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              child: ListTile(
                                leading: const Icon(Icons.event),
                                title: Text(event['type'] ?? ''),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (event['time'] != null && event['time']!.isNotEmpty)
                                      Text('Time: ${event['time']}'),
                                    if (event['location'] != null && event['location']!.isNotEmpty)
                                      Text('Location: ${event['location']}'),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      final key = DateTime.utc(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
                                      _events[key]?.remove(event);
                                      if (_events[key]?.isEmpty ?? false) {
                                        _events.remove(key);
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}