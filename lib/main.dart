import 'package:flutter/material.dart';
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
import '../../coach/dashboard_coach.dart';
import 'dart:async';
import 'screens/reset_password.dart';
import 'package:app_links/app_links.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appLinks = AppLinks();
  StreamSubscription<Uri>? _appLinksSub;
  String? _pendingResetToken;

  @override
  void initState() {
    super.initState();
    _listenAppLinks();
  }

  @override
  void dispose() {
    _appLinksSub?.cancel();
    super.dispose();
  }

  void _listenAppLinks() {
    _appLinksSub = appLinks.uriLinkStream.listen((Uri? uri) {
      if (!mounted || uri == null) return;
      if (uri.pathSegments.contains('reset-password')) {
        final token = uri.queryParameters['token'];
        if (token != null && token.isNotEmpty) {
          setState(() {
            _pendingResetToken = token;
          });
        }
      }
    });

    appLinks.getInitialAppLink().then((Uri? initialUri) {
      if (initialUri != null) {
        if (initialUri.pathSegments.contains('reset-password')) {
          final token = initialUri.queryParameters['token'];
          if (token != null && token.isNotEmpty) {
            setState(() {
              _pendingResetToken = token;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Body Shape',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFf70d6f)),
      ),
      home: RootPage(
        pendingResetToken: _pendingResetToken,
        onResetTokenHandled: (token) {
          setState(() {
            _pendingResetToken = token;
          });
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/onboarding': (context) => OnboardingPager(),
        '/admin': (context) => DashboardPage(),
        '/measurement': (context) => MeasurementScreen(),
        '/workout': (context) => WorkoutPlanScreen(),
        '/calendar': (context) => WorkoutCalendarPage(),
        '/account': (context) => AccountPage(),
        '/package': (context) => PackagesOverviewPage(),
        '/gender': (context) => GenderSelectScreen(),
        '/email': (context) => EmailScreen(),
        '/coach_dashboard': (context) => DashboardCoachPage(),
        '/reset_password': (context) {
          final token = ModalRoute.of(context)!.settings.arguments as String?;
          if (token == null || token.isEmpty) {
            return Scaffold(
              body: Center(child: Text('Invalid or missing token')),
            );
          }
          return ResetPasswordScreen(token: token);
        },
      },
    );
  }
}

class RootPage extends StatefulWidget {
  final String? pendingResetToken;
  final Function(String?) onResetTokenHandled;

  const RootPage({Key? key, this.pendingResetToken, required this.onResetTokenHandled}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void didUpdateWidget(covariant RootPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pendingResetToken != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed('/reset_password', arguments: widget.pendingResetToken);
        widget.onResetTokenHandled(null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingPager();
  }
}
