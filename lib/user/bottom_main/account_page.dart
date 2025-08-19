import 'dart:ui';
import 'package:flutter/material.dart';
import '/../api_service/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bottom.dart'; 
import 'package:provider/provider.dart';
import '../../../theme_notifier.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import '../account/bmi.dart';
import '../account/calorie_calculator.dart';
import '../account/body_measurement_detail.dart';
import '../account/chat_assist.dart';
import '../account/change_password_screen.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String name = '';
  String email = '';
  String initials = '';
  String membership = '';
  String packageName = '';
  bool isLoading = true;
  String currentLanguage = 'English'; 

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _loadUserInfo();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentLanguage = prefs.getString('language') ?? 'Vietnamese';
    });
  }

  String displayNA(dynamic value) {
    if (value == null) return 'N/A';
    if (value is String && value.trim().isEmpty) return 'N/A';
    return value.toString();
  }

  Future<void> _loadUserInfo() async {
    try {
      final profileJson = await AuthService.getUserProfile();
      if (profileJson != null) {
        final profile = jsonDecode(profileJson);
        final data = profile['data'];
        setState(() {
          name = displayNA(data['full_name']);
          email = displayNA(data['email']);
          initials = _getInitials(name);
        });
        final userId = data['user_id']?.toString() ?? data['id']?.toString();
        if (userId != null) {
          await _loadMembership(userId);
        }
      } else {
        setState(() {
          name = 'N/A';
          email = 'N/A';
          initials = 'N/A';
          packageName = 'No package available';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        name = 'N/A';
        email = 'N/A';
        initials = 'N/A';
        packageName = 'No package available';
        isLoading = false;
      });
    }
  }

  Future<void> _loadMembership(String userId) async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('https://splendid-wallaby-ethical.ngrok-free.app/memberships/get-membership-card-by-user-id/$userId');
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final membershipData = jsonDecode(response.body);
        final data = membershipData['data'];
        final packageId = data['package_id'];
        if (packageId != null) {
          await _loadPackage(packageId.toString());
        } else {
          setState(() {
            packageName = 'No package available';
          });
        }
      } else {
        setState(() {
          packageName = 'No package available';
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        packageName = 'No package available';
        isLoading = false;
      });
    }
  }

  Future<void> _loadPackage(String packageId) async {
    try {
      final headers = await AuthService.getHeaders();
      final url = Uri.parse('https://splendid-wallaby-ethical.ngrok-free.app/packages/get-package-by-id/$packageId');
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final packageData = jsonDecode(response.body);
        final data = packageData['data'];
        setState(() {
          packageName = data['package_name']?.toString() ?? 'No package available';
        });
      } else {
        setState(() {
          packageName = 'No package available';
        });
      }
    } catch (_) {
      setState(() {
        packageName = 'No package available';
      });
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Define colors for light/dark mode
    final bgColor = isDark ? const Color(0xFF181A20) : const Color(0xFFF8F8F8);
    final headerGradient = isDark
        ? [const Color(0xFF232526), const Color(0xFF414345)]
        : [const Color(0xFFEC407A), const Color(0xFFF48FB1)];
    final cardBg = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.white.withOpacity(0.85);
    final cardBorder = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.white.withOpacity(0.5);
    final cardShadow = isDark
        ? Colors.black.withOpacity(0.4)
        : Colors.pink.shade100.withOpacity(0.18);
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                // Header
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Pink/Dark header
                    Container(
                      width: double.infinity,
                      height: 240,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: headerGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(36),
                          bottomRight: Radius.circular(36),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 36),
                          // Gradient badge
                          if (packageName.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF43E97B), Color(0xFF11998e)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.workspace_premium, color: Colors.white, size: 19),
                                  const SizedBox(width: 7),
                                  Text(
                                    packageName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 20),
                          Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            email,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Animated avatar with gradient border
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: -60,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [const Color(0xFF232526), const Color(0xFF414345)]
                                  : [const Color(0xFFF48FB1), const Color(0xFFEC407A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 18,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 56,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 52,
                              backgroundColor: isDark ? const Color(0xFF232526) : const Color(0xFFF48FB1),
                              child: Text(
                                initials,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 38,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
                // Divider below avatar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 90),
                  child: Divider(
                    color: isDark ? Colors.white12 : Colors.pink.shade100,
                    thickness: 2,
                    height: 0,
                  ),
                ),
                const SizedBox(height: 18),
                // Glassmorphism menu card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: cardShadow,
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: cardBorder,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildMenuItem(
                              icon: Icons.straighten,
                              iconBg: Colors.pink.shade50,
                              iconColor: Colors.pink,
                              text: 'Body Measurements',
                              textColor: textColor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BodyMeasurementDetailScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDivider(isDark),
                            _buildMenuItem(
                              icon: Icons.monitor_weight,
                              iconBg: Colors.orange.shade50,
                              iconColor: Colors.orange,
                              text: 'BMI Calculation',
                              textColor: textColor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BMICalculator(),
                                  ),
                                );
                              },
                            ),
                            _buildDivider(isDark),
                            _buildMenuItem(
                              icon: Icons.local_fire_department,
                              iconBg: Colors.red.shade50,
                              iconColor: Colors.red,
                              text: 'Calculate Calories',
                              textColor: textColor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CalorieCalculator(),
                                  ),
                                );
                              },
                            ),
                            _buildDivider(isDark),
                            _buildMenuItem(
                              icon: Icons.chat_bubble_outline,
                              iconBg: Colors.blue.shade50,
                              iconColor: Colors.blue,
                              text: 'Ask AI',
                              textColor: textColor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const GemBot(),
                                  ),
                                );
                              },
                            ),
                            _buildDivider(isDark),
                            _buildMenuItem(
                              icon: Icons.lock_outline,
                              iconBg: Colors.deepPurple.shade50,
                              iconColor: Colors.deepPurple,
                              text: 'Change Password',
                              textColor: textColor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ChangePasswordScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDivider(isDark),
                            _buildMenuItem(
                              icon: Icons.language,
                              iconBg: Colors.teal.shade50,
                              iconColor: Colors.teal,
                              text: 'Language (${currentLanguage == 'English' ? 'VN' : 'EN'})',
                              textColor: textColor,
                              onTap: () => _showLanguageDialog(context),
                            ),
                            _buildDivider(isDark),
                            _buildMenuItem(
                              icon: Icons.nightlight_round,
                              iconBg: Colors.grey.shade50,
                              iconColor: isDark ? Colors.yellow : Colors.grey,
                              text: 'Night Mode',
                              textColor: textColor,
                              onTap: () {
                                Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
                              },
                              isNightMode: true, // bật chế độ công tắc
                              isDark: isDark,    // truyền trạng thái dark/light
                            ),
                            _buildDivider(isDark),
                            _buildMenuItem(
                              icon: Icons.logout,
                              iconBg: Colors.grey.shade50,
                              iconColor: Colors.grey,
                              text: 'Logout',
                              textColor: textColor,
                              onTap: () async {
                                final shouldLogout = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirm Logout'),
                                    content: const Text('Are you sure you want to logout?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text('Logout'),
                                      ),
                                    ],
                                  ),
                                );
                                if (shouldLogout == true) {
                                  await AuthService.logout();
                                  Navigator.pushReplacementNamed(context, '/login');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/workout');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/calendar');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/package');
          }
        },
      ),
    );
  }

  // Update _buildMenuItem to accept textColor
  Widget _buildMenuItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String text,
    required Color textColor,
    required VoidCallback onTap,
    bool isNightMode = false, 
    bool isDark = false,      
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            isNightMode
                ? Icon(
                    isDark ? Icons.toggle_on : Icons.toggle_off,
                    color: isDark ? Colors.yellow : Colors.grey,
                    size: 32,
                  )
                : const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Update _buildDivider to accept isDark
  Widget _buildDivider(bool isDark) => Divider(
        height: 1,
        indent: 16,
        endIndent: 16,
        color: isDark ? Colors.white12 : Colors.grey.shade300,
      );

  // Thêm phương thức _showLanguageDialog
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                value: 'Vietnamese',
                groupValue: currentLanguage,
                title: const Text('Vietnamese'),
                onChanged: (value) async {
                  final prefs = await SharedPreferences.getInstance();
                  setState(() {
                    currentLanguage = value!;
                  });
                  prefs.setString('language', value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                value: 'English',
                groupValue: currentLanguage,
                title: const Text('English'),
                onChanged: (value) async {
                  final prefs = await SharedPreferences.getInstance();
                  setState(() {
                    currentLanguage = value!;
                  });
                  prefs.setString('language', value!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}