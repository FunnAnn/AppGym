import 'package:flutter/material.dart';
import '../api_service/auth_service.dart';
import '../theme/app_colors.dart';

class LayoutCoach extends StatelessWidget {
  final Widget body;
  const LayoutCoach({Key? key, required this.body}) : super(key: key);

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
                title: const Text('Dash Board'),
                onTap: () {
                },
              ),
              ListTile(
                leading: Icon(Icons.person_outline, color: AppColors.pinkTheme),
                title: Text('Member'),
                onTap: () {
                },
              ),
              ListTile(
                leading: Icon(Icons.inventory_2_outlined, color: AppColors.pinkTheme),
                title: Text('Package'),
                onTap: () {
                },
              ),
              
              ListTile(
                leading: Icon(Icons.chat_bubble_outline, color: AppColors.pinkTheme),
                title: Text('Chat'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.video_library_outlined, color: AppColors.pinkTheme),
                title: Text('Video'),
                onTap: () {},
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
                  'Đăng xuất',
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
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: body,
    );
  }
}