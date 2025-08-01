import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../api_service/auth_service.dart';
import 'dart:convert';

// Hàm public để show QR popup
Future<void> showQRDialog(BuildContext context) async {
  final userId = await AuthService.getUserId();
  final role = await AuthService.getUserRole();
  final accessToken = await AuthService.getToken();
  final key = await AuthService.getUserKey();

  final qrData = jsonEncode({
    "user_id": userId,
    "role": role,
    "key": key,
    "accessToken": accessToken,
  });

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      contentPadding: const EdgeInsets.all(24),
      content: SizedBox(
        width: 300, 
        height: 300,
        child: Center(
          child: QrImageView(
            data: qrData,
            size: 260, 
          ),
        ),
      ),
    ),
  );
}

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: BottomNavigationBar(
              backgroundColor: const Color(0xFFF70D6F),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.fitness_center),
                  label: 'Plan',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Schedule',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code, color: Colors.transparent, size: 24), 
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_giftcard),
                  label: 'Packages',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_2_rounded),
                  label: 'Account',
                ),
              ],
              currentIndex: currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                if (index == 2) {
                  showQRDialog(context); // Hiện popup QR
                } else {
                  onTap(index);
                }
              },
            ),
          ),
          Positioned(
            top: -20,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      showQRDialog(context); // Hiện popup QR khi bấm nút
                    },
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFFF70D6F), width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.qr_code, color: Color(0xFFF70D6F), size: 36),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Scan QR',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}