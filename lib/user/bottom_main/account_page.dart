import 'package:flutter/material.dart';
import '../account_card.dart';
import 'bottom.dart';
import '../account/body_measurement_detail.dart';
import '../account/calorie_calculator.dart';
import '../account/chat_assist.dart';
import '../../api_service/auth_service.dart';
import '../account/bmi.dart';
import '../account/change_password_screen.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  // Thêm method logout
  Future<void> _logout() async {
    try {
      // Hiển thị dialog xác nhận
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Đăng xuất'),
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          // Xóa tất cả parameters vì AccountCard sẽ tự load dữ liệu
          const AccountCard(),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Body Measurements'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BodyMeasurementDetailScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('BMI Calculation'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BMICalculator(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Calculate Calories'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to Calculate Calories page
                    Navigator.push(context, MaterialPageRoute(builder: (_) => CalorieCalculator()));
                  },
                ),
                ListTile(
                  title: const Text('Ask AI'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to Ask AI page
                    Navigator.push(context, MaterialPageRoute(builder: (_) => GemBot()));
                  },
                ),
                ListTile(
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to Change Password page
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ChangePasswordScreen()));
                  },
                ),
                ListTile(
                  title: const Text('Logout'),
                  trailing: const Icon(Icons.logout),
                  onTap: _logout, // Sử dụng method logout mới
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 4, // "Account" tab
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/workout');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/calendar');
          } else if (index == 2) {
            showQRDialog(context);
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/package');
          }
        },
      ),
    );
  }
}