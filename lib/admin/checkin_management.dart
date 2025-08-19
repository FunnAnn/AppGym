import 'package:flutter/material.dart';
import '../api_service/checkin_service.dart';
import '../model/checkin.dart';
import 'admin_layout.dart';
import 'package:intl/intl.dart';

class CheckinManagementPage extends StatefulWidget {
  const CheckinManagementPage({Key? key}) : super(key: key);

  @override
  State<CheckinManagementPage> createState() => _CheckinManagementPageState();
}

class _CheckinManagementPageState extends State<CheckinManagementPage> {
  late Future<Checkin> _futureCheckins;
  List<Data> _allCheckins = [];
  List<Data> _filteredCheckins = [];
  String _searchText = '';
  DateTime selectedDate = DateTime.now();
  bool isFilterByDate = false;

  @override
  void initState() {
    super.initState();
    _fetchAllCheckins();
  }

  void _fetchAllCheckins() {
    isFilterByDate = false;
    _futureCheckins = CheckinService.getAllCheckins();
    _futureCheckins.then((checkin) {
      final all = checkin.data ?? [];
      setState(() {
        _allCheckins = all;
        _filteredCheckins = all;
      });
    });
  }

  void _fetchCheckinsByDate(DateTime date) {
    isFilterByDate = true;
    _futureCheckins = CheckinService.getAllCheckins();
    _futureCheckins.then((checkin) {
      final all = checkin.data ?? [];
      final filteredByDate = all.where((c) {
        if (c.checkinTime == null) return false;
        final dt = DateTime.tryParse(c.checkinTime!);
        return dt != null &&
            dt.year == date.year &&
            dt.month == date.month &&
            dt.day == date.day;
      }).toList();
      setState(() {
        _allCheckins = filteredByDate;
        _filteredCheckins = filteredByDate;
      });
    });
  }

  void _filterCheckins(String value) {
    setState(() {
      _searchText = value;
      _filteredCheckins = _allCheckins.where((checkin) {
        final name = checkin.users?.fullName?.toLowerCase() ?? '';
        return name.contains(_searchText.toLowerCase());
      }).toList();
    });
  }

  String _formatDateTime(String? iso) {
    if (iso == null) return '-';
    try {
      final dt = DateTime.parse(iso);
      return DateFormat('dd/MM/yyyy HH:mm').format(dt);
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AdminLayout(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<Checkin>(
              future: _futureCheckins,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Checkin Management',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search by name...',
                              prefixIcon: Icon(Icons.search, color: Colors.pink),
                              filled: true,
                              fillColor: Colors.pink.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                            ),
                            onChanged: _filterCheckins,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.calendar_today, size: 18),
                          label: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null && picked != selectedDate) {
                              setState(() {
                                selectedDate = picked;
                              });
                              _fetchCheckinsByDate(picked);
                            }
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedDate = DateTime.now();
                            });
                            _fetchAllCheckins();
                          },
                          child: const Text('Show All', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    if (_filteredCheckins.isEmpty)
                      const Expanded(
                        child: Center(
                          child: Text(
                            'No checkin records found for this date.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.separated(
                          itemCount: _filteredCheckins.length,
                          separatorBuilder: (_, __) => const Divider(height: 24, color: Colors.pinkAccent, thickness: 0.15),
                          itemBuilder: (context, index) {
                            final checkin = _filteredCheckins[index];
                            final user = checkin.users;
                            final avatarText = (user?.fullName != null && user!.fullName!.isNotEmpty)
                                ? user.fullName![0].toUpperCase()
                                : '';
                            return Card(
                              elevation: 4,
                              margin: EdgeInsets.zero,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.pink.shade100,
                                      child: avatarText.isNotEmpty
                                          ? Text(
                                              avatarText,
                                              style: const TextStyle(
                                                color: Colors.pink,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                              ),
                                            )
                                          : const Icon(Icons.person, color: Colors.pink, size: 28),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user?.fullName ?? 'Unknown User',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(Icons.login, size: 18, color: Colors.green),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Checkin: ',
                                                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
                                              ),
                                              Text(
                                                _formatDateTime(checkin.checkinTime),
                                                style: const TextStyle(fontSize: 14, color: Colors.black87),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              const Icon(Icons.logout, size: 18, color: Colors.red),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Checkout: ',
                                                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
                                              ),
                                              Text(
                                                checkin.checkoutTime == null
                                                    ? 'Not yet'
                                                    : _formatDateTime(checkin.checkoutTime),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: checkin.checkoutTime == null ? Colors.grey : Colors.black87,
                                                  fontStyle: checkin.checkoutTime == null ? FontStyle.italic : FontStyle.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
                );
              },
            ),
          ),
        ),
        // Floating QR Scan Button
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            backgroundColor: Colors.pink,
            onPressed: () {
              // TODO: Add your scan QR logic here
            },
            child: const Icon(Icons.qr_code_scanner, size: 32, color: Colors.white),
            tooltip: 'Scan QR',
          ),
        ),
      ],
    );
  }
}