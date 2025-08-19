import 'package:flutter/material.dart';
import 'dashboard_coach.dart';
import '../api_service/auth_service.dart';
import '../theme/app_colors.dart';
import 'user_coach.dart';
import 'view_package.dart';
import 'excercise_coach.dart';

class LayoutCoach extends StatelessWidget {
  final Widget body;
  const LayoutCoach({Key? key, required this.body}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    try {
      // Show confirmation dialog
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Logout'),
            ),
          ],
        ),
      );

      if (shouldLogout == true) {
        // Perform logout
        await AuthService.logout();
        
        // Navigate to login screen and remove all previous routes
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login', 
          (route) => false,
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error while logging out: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                    height: 120,
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      width: 300,
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // Coach Panel group
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                child: Text(
                  'Coach Panel',
                  style: const TextStyle(
                    color: Color(0xFFE91E63),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.dashboard_customize_outlined, color: AppColors.pinkTheme),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DashboardCoachPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person_outline, color: AppColors.pinkTheme),
                title: Text('User'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CoachCustomerPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.inventory_2_outlined, color: AppColors.pinkTheme),
                title: Text('Package'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPackagePage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.video_library_outlined, color: AppColors.pinkTheme),
                title: Text('Exercise'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CoachExercisePage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.chat_bubble_outline, color: AppColors.pinkTheme),
                title: Text('Chat'),
                onTap: () {},
              ),
              
              // Divider and logout
              Divider(
                color: Colors.grey[300],
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Coach Panel'),
        backgroundColor: AppColors.pinkTheme,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: body,
    );
  }
}
