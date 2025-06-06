import 'package:flutter/material.dart';

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
      height: 80, // Increase height to make room for the floating button
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
                  icon: SizedBox(height: 0), // Keep for label alignment
                  label: '', // Hide label for the middle icon
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_giftcard), // Changed from Icons.package to Icons.card_giftcard
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
                  // Handle "Scan QR" button tap
                  // Example: showDialog(context: context, builder: (_) => ...);
                } else {
                  onTap(index);
                }
              },
            ),
          ),
          // Floating QR button
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
                      onTap(2); // When tapping the QR button
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
                const SizedBox(height: 8), // Align for consistency
                Text(
                  'Scan QR',
                  style: TextStyle(
                    color: Colors.white, // Match other labels
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