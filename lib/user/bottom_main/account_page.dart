import 'package:flutter/material.dart';
import '../account_card.dart';
import 'bottom.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _currentIndex = 4; // "Account" tab index

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      // Add navigation to other pages if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: ListView(
        children: const [
          SizedBox(height: 24),
          AccountCard(
            name: 'USER NAME',
            phone: 'N/A',
            exp: '_ / _ / _',
            pt: '0/0',
            hasPackage: false,
          ),
          // Add other widgets here
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
            // Handle "Scan QR" button tap
            // Example: showDialog(context: context, builder: (_) => ...);
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/package');
          }
        },
      ),
    );
  }
}