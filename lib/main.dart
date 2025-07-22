import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_app/user/onboarding.dart';
import 'admin/admin_layout.dart';
import 'screens/login.dart';
import 'user/measurement.dart';
import 'user/bottom_main/workout_plan.dart';
import 'admin/dashboard.dart';
import 'user/bottom_main/calendar.dart';
import 'user/bottom_main/account_page.dart';
import 'user/bottom_main/package.dart';
import 'user/gender.dart';
import 'screens/email.dart';
import 'admin/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    // Thêm log để debug
    print('🔥 Bắt đầu khởi tạo Firebase...');
    
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    print('✅ Firebase khởi tạo thành công!');
    
    // Kiểm tra Firebase app
    final app = Firebase.app();
    print('📱 Firebase App: ${app.name}');
    print('🔗 Firebase Options: ${app.options.projectId}');
  } catch (e) {
    print('Firebase initialization: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Body Shape',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFf70d6f)),
      ),
      home: const OnboardingPager(),
      routes: {
        '/login': (context) => LoginScreen(), // Đăng nhập
        '/onboarding': (context) => OnboardingPager(), // Onboarding
        '/admin': (context) => DashboardPage(), // Giao diện admin
        '/measurement': (context) => MeasurementScreen(),
        '/workout': (context) => WorkoutPlanScreen(), // Thông số cơ thể
        '/calendar': (context) => WorkoutCalendarPage(), // Lịch tập
        '/account': (context) => AccountPage(), // Tài khoản
        '/package': (context) => PackagesOverviewPage(), // Gói thành viên
        '/gender': (context) => GenderSelectScreen(), // Chọn giới tính
        '/email': (context) => EmailScreen(), // Đăng nhập bằng email
        '/admin_dashboard': (context) => DashboardPage(), // Dashboard admin

      },
    );
  }
}
