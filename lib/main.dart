import 'package:flutter/material.dart';
import 'package:flutter_app/user/onboarding.dart';
import 'admin/admin_layout.dart';
import 'screens/login.dart';
import 'user/measurement.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFf70d6f)),
      ),
      home: const RoleSelectorScreen(),
      routes: {
        '/login': (context) => LoginScreen(), // Đăng nhập
        '/onboarding': (context) => OnboardingPager(), // Onboarding
        '/admin': (context) => AdminLayout(), // Giao diện admin
        '/measurement': (context) => MeasurementScreen(), // Thông số cơ thể
      },
    );
  }
}

class RoleSelectorScreen extends StatelessWidget {
  const RoleSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn vai trò')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Admin'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminLayout()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('User'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OnboardingPager()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
