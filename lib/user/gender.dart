import 'package:flutter/material.dart';
import '../api_service/auth_service.dart'; // Thêm dòng này

class GenderSelectScreen extends StatelessWidget {
  const GenderSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final userId = args?['userId'];
    
    // Check if userId is available
    if (userId == null || userId.toString().isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Gender Selection',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: const Center(
          child: Text(
            'Lỗi: Không tìm thấy thông tin người dùng.\nVui lòng đăng nhập lại.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Gender Selection',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                try {
                  print('Attempting to update gender for userId: $userId');
                  
                  // Debug authentication status
                  await AuthService.debugAuthStatus();
                  
                  // Check authentication status
                  final isAuth = await AuthService.isAuthenticated();
                  final token = await AuthService.getCurrentToken();
                  print('Is authenticated: $isAuth');
                  print('Current token: ${token != null ? '${token.substring(0, 20)}...' : 'null'}');
                  
                  if (!isAuth || token == null || token.isEmpty) {
                    throw Exception('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
                  }
                  
                  await AuthService.updateGender(userId: userId.toString(), gender: 0);
                  print('Gender update successful, navigating to measurement screen');
                  Navigator.pushReplacementNamed(
                    context,
                    '/measurement',
                    arguments: {'userId': userId, 'isFemale': false},
                  );
                } catch (e) {
                  print('Error updating gender to male: $e');
                  
                  // Kiểm tra nếu là lỗi token hết hạn hoặc forbidden
                  if (e.toString().contains('hết hạn') || e.toString().contains('Unauthorized') || e.toString().contains('401') || e.toString().contains('403') || e.toString().contains('Forbidden')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Phiên đăng nhập đã hết hạn hoặc không có quyền truy cập. Đang chuyển về trang đăng nhập...'),
                        backgroundColor: Colors.orange,
                        duration: Duration(seconds: 3),
                      ),
                    );
                    
                    // Xóa token và chuyển về trang đăng nhập
                    await AuthService.clearToken();
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cập nhật giới tính thất bại: ${e.toString()}'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 5),
                      ),
                    );
                  }
                }
              },
              child: Container(
                height: 150,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/male_bg.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black26, BlendMode.darken),
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 24),
                child: const Text(
                  'MALE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                try {
                  print('Attempting to update gender for userId: $userId');
                  
                  // Debug authentication status
                  await AuthService.debugAuthStatus();
                  
                  // Check authentication status
                  final isAuth = await AuthService.isAuthenticated();
                  final token = await AuthService.getCurrentToken();
                  print('Is authenticated: $isAuth');
                  print('Current token: ${token != null ? '${token.substring(0, 20)}...' : 'null'}');
                  
                  if (!isAuth || token == null || token.isEmpty) {
                    throw Exception('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
                  }
                  
                  await AuthService.updateGender(userId: userId.toString(), gender: 1); // 1: Nữ
                  print('Gender update successful, navigating to measurement screen');
                  Navigator.pushReplacementNamed(
                    context,
                    '/measurement',
                    arguments: {'userId': userId, 'isFemale': true},
                  );
                } catch (e) {
                  print('Error updating gender to female: $e');
                  
                  // Kiểm tra nếu là lỗi token hết hạn hoặc forbidden
                  if (e.toString().contains('hết hạn') || e.toString().contains('Unauthorized') || e.toString().contains('401') || e.toString().contains('403') || e.toString().contains('Forbidden')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Phiên đăng nhập đã hết hạn hoặc không có quyền truy cập. Đang chuyển về trang đăng nhập...'),
                        backgroundColor: Colors.orange,
                        duration: Duration(seconds: 3),
                      ),
                    );
                    
                    // Xóa token và chuyển về trang đăng nhập
                    await AuthService.clearToken();
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cập nhật giới tính thất bại: ${e.toString()}'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 5),
                      ),
                    );
                  }
                }
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/female_bg.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black26, BlendMode.darken),
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 24),
                child: const Text(
                  'FEMALE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Expanded(child: SizedBox()), // Đẩy các container lên trên
          ],
        ),
      ),
    );
  }
}
