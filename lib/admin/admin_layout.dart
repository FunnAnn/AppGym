import 'package:flutter/material.dart';
import 'dashboard.dart';
import '../api_service/auth_service.dart';
import 'user_management.dart'; 
import '../theme/app_colors.dart';
import 'package_management.dart';
import 'membership_management.dart';
import 'equipment_management.dart';
import 'excercise_management.dart';
import 'training_plan_management.dart';
import 'chat_assistant.dart';
import 'checkin_management.dart';

class AdminLayout extends StatelessWidget {
  final Widget body;
  const AdminLayout({Key? key, required this.body}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    try {
      // Hiển thị dialog xác nhận
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Đăng xuất'),
          content: Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Đăng xuất'),
            ),
          ],
        ),
      );

      if (shouldLogout == true) {
        // Thực hiện logout
        await AuthService.logout();
        
        // Chuyển về màn hình đăng nhập và xóa tất cả route trước đó
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login', 
          (route) => false,
        );
      }
    } catch (e) {
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi đăng xuất: $e'),
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
                    height: 120, // Sửa chiều cao hợp lý
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
                  style: const TextStyle(
                    color: Color(0xFFE91E63), // Use direct color instead of AppColors.pinkTheme
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.dashboard_customize_outlined, color: AppColors.pinkTheme),
                title: const Text('Training Plans'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => TrainingPlanManagementPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.dashboard_customize_outlined, color: AppColors.pinkTheme),
                title: const Text('Plan Exercises'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                  );
                },
              ),
              
              ListTile(
                leading: Icon(Icons.person_outline, color: AppColors.pinkTheme),
                title: Text('User'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UserManagementPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.inventory_2_outlined, color: AppColors.pinkTheme),
                title: Text('Package'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PackageManagementPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.card_membership_outlined, color: AppColors.pinkTheme),
                title: Text('Memberships'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MembershipManagementPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.chat_bubble_outline, color: AppColors.pinkTheme),
                title: Text('Chat'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => GemBot()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.qr_code_scanner_outlined, color: AppColors.pinkTheme),
                title: Text('Checkins'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CheckinManagementPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.fitness_center_outlined, color: AppColors.pinkTheme),
                title: Text('Equipments'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EquipmentManagementPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.sports_gymnastics_outlined, color: AppColors.pinkTheme),
                title: Text('Exercises'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ExerciseManagementPage()),
                  );
                },
              ),
              // Divider và logout
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
        title: const Text('Admin Panel'),
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