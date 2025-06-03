import 'package:flutter/material.dart';
import 'dashboard.dart';

class AdminLayout extends StatelessWidget {
  final Widget body;
  const AdminLayout({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Logo
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Center(
                  child: SizedBox(
                    height: 1500, // Chiều cao khung logo, chỉnh nhỏ lại nếu muốn
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      width: 300,
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // Dash Board group
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                child: Text(
                  'Dash Board',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.dashboard_customize_outlined),
                title: Text('Dash Board'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.people_outline),
                title: Text('Models'),
                trailing: Icon(Icons.arrow_right),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('User'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.calendar_today_outlined),
                title: Text('Training schedule'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.card_membership_outlined),
                title: Text('Memberships'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.chat_bubble_outline),
                title: Text('Chat'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.qr_code_scanner_outlined),
                title: Text('Checkins'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.fitness_center_outlined),
                title: Text('Equipments'),
                onTap: () {},
              ),
              // Projects group
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  'Projects',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.engineering_outlined),
                title: Text('Design Engineering'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.access_time_outlined),
                title: Text('Sales & Marketing'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.map_outlined),
                title: Text('Travel'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.more_horiz),
                title: Text('More'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: body,
    );
  }
}