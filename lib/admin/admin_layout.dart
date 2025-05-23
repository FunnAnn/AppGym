import 'package:flutter/material.dart';

class AdminLayout extends StatelessWidget {
  const AdminLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                // Handle navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Users'),
              onTap: () {
                // Handle navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle navigation
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: Center(
        child: Text('Welcome to the Admin Panel!'),
      ),
    );
  }
}