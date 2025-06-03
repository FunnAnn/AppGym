import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'admin_layout.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Dummy events
  final Map<DateTime, List<String>> _events = {
    DateTime.utc(2025, 5, 1): ['One-on-one meeting', 'Gym workout'],
    DateTime.utc(2025, 5, 3): ['Book club meeting'],
    DateTime.utc(2025, 5, 5): ['Office relocation'],
    DateTime.utc(2025, 5, 6): ['Dental cleaning'],
    DateTime.utc(2025, 5, 7): ['Hiking expedition'],
    DateTime.utc(2025, 5, 8): ['Movie night'],
    DateTime.utc(2025, 5, 10): ['Flight departure', 'Gym workout'],
    DateTime.utc(2025, 5, 15): ['Graduation ceremony', 'Dental cleaning'],
    DateTime.utc(2025, 5, 20): ['Customer support', 'Physical therapy session'],
    DateTime.utc(2025, 5, 27): ['Budget review', 'Book club meeting'],
    DateTime.utc(2025, 5, 31): ['Financial planning', 'Code review'],
  };

  List<String> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      body: Column(
        children: [
          AppBar(
            title: const Text('Calendar'),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // Thêm sự kiện mới
                },
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
                  firstDay: DateTime.utc(2025, 5, 1),
                  lastDay: DateTime.utc(2025, 5, 31),
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
                  eventLoader: _getEventsForDay,
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
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _selectedDay == null
                      ? Center(child: Text('Chọn ngày để xem sự kiện'))
                      : ListView(
                          children: _getEventsForDay(_selectedDay!).map((event) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              child: ListTile(
                                leading: Icon(Icons.event),
                                title: Text(event),
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