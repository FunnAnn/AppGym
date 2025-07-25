import 'dart:convert'; // For json.decode
import 'package:http/http.dart' as http; // For http.get
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../theme/app_colors.dart';
import '../api_service/schedule_service.dart';
import '../model/schedule.dart';
import 'layout_coach.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardCoachPage extends StatefulWidget {
  const DashboardCoachPage({Key? key}) : super(key: key);

  @override
  State<DashboardCoachPage> createState() => _DashboardCoachPageState();
}

class _DashboardCoachPageState extends State<DashboardCoachPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  // Events loaded from API
  Map<DateTime, List<Map<String, String>>> _events = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  Future<void> _fetchSchedules() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final service = ScheduleService();
    final schedule = await service.fetchSchedules();

    if (schedule != null && schedule.data != null) {
      final Map<DateTime, List<Map<String, String>>> events = {};
      for (final item in schedule.data!) {
        if (item.startDate != null) {
          final date = DateTime.tryParse(item.startDate!);
          if (date != null) {
            final key = DateTime.utc(date.year, date.month, date.day);
            final event = {
              'type': item.title ?? '',
              'time': (() {
                final dt = DateTime.tryParse(item.startDate ?? '');
                if (dt == null) return '';
                final local = dt.toLocal();
                return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
              })(),
              'location': item.description ?? '',
              'customer': item.customers?.users?.fullName ?? '',
            };
            if (events.containsKey(key)) {
              events[key]!.add(event);
            } else {
              events[key] = [event];
            }
          }
        }
      }
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _error = 'Không thể tải dữ liệu lịch trình';
      });
    }
  }

  List<Map<String, String>> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutCoach(
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(
                title: const Text('Dashboard Calendar'),
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _fetchSchedules,
                  ),
                ],
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(child: Text(_error!))
                        : Column(
                            children: [
                              TableCalendar(
                                firstDay: DateTime.utc(2000, 1, 1),
                                lastDay: DateTime.utc(2100, 12, 31),
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
                                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                                                  if (event['customer'] != null && event['customer']!.isNotEmpty)
                                                    Text('Customer: ${event['customer']}'),
                                                ],
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
          // FloatingActionButton for creating schedule
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              backgroundColor: AppColors.pinkTheme,
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                // Show dialog to create schedule
                // When opening the dialog, pass _selectedDay
                await showDialog(
                  context: context,
                  builder: (context) => _CreateScheduleDialog(
                    onCreated: () {
                      _fetchSchedules();
                    },
                    selectedDay: _selectedDay, // <-- pass this!
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Dialog widget for creating a schedule
class _CreateScheduleDialog extends StatefulWidget {
  final VoidCallback onCreated;
  final DateTime? selectedDay; // <-- add this

  const _CreateScheduleDialog({
    required this.onCreated,
    this.selectedDay,
  });

  @override
  State<_CreateScheduleDialog> createState() => _CreateScheduleDialogState();
}

class _CreateScheduleDialogState extends State<_CreateScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _timeController = TextEditingController();
  TimeOfDay? _selectedTime;
  bool _isLoading = false;
  List<Map<String, dynamic>> _customers = [];
  Map<String, dynamic>? _selectedCustomer;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _fetchCustomers() async {
    final customers = await ScheduleService().getCoachCustomers();
    setState(() {
      _customers = customers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Schedule'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime ?? TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedTime = picked;
                      _timeController.text = picked.format(context); // Update the field!
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      labelText: 'Time',
                      hintText: _selectedTime == null
                          ? 'Select time'
                          : _selectedTime!.format(context),
                      suffixIcon: const Icon(Icons.access_time),
                    ),
                    validator: (v) =>
                        _selectedTime == null ? 'Select time' : null,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (v) => v == null || v.isEmpty ? 'Enter location' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Map<String, dynamic>>(
                value: _selectedCustomer,
                items: _customers.map((customer) {
                  return DropdownMenuItem(
                    value: customer,
                    child: Text(customer['full_name'] ?? customer['customer_full_name'] ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCustomer = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Customer'),
                validator: (v) => v == null ? 'Please select a customer' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.pinkTheme,
          ),
          onPressed: _isLoading
              ? null
              : () async {
                  if (_formKey.currentState?.validate() != true) {
                    return;
                  }
                  setState(() => _isLoading = true);

                  // Get coachId from /user/me or your app state
                  final coachId = await _getCoachId();
                  final customerId = _selectedCustomer?['user_id'] ?? _selectedCustomer?['customer_id'];

                  final selectedDay = widget.selectedDay ?? DateTime.now();
                  final startDate = DateTime(
                    selectedDay.year,
                    selectedDay.month,
                    selectedDay.day,
                    _selectedTime?.hour ?? 0,
                    _selectedTime?.minute ?? 0,
                  );

                  final success = await ScheduleService().createSchedule(
                    customerId: customerId,
                    coachId: coachId,
                    title: _titleController.text,
                    startDate: startDate.toIso8601String(),
                    endDate: startDate.add(const Duration(hours: 1)).toIso8601String(),
                    description: _locationController.text,
                  );
                  setState(() => _isLoading = false);
                  if (success) {
                    widget.onCreated();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to create schedule')),
                    );
                  }
                },
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Create'),
        ),
      ],
    );
  }

  // Helper to get coachId from /user/me
  Future<int> _getCoachId() async {
    final url = Uri.parse('${ScheduleService.baseUrl}/user/me');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data']['user_id'];
    }
    return 0;
  }
}