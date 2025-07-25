import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api_service/health_service.dart';
import '../api_service/auth_service.dart';
import 'dart:convert';

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({super.key});

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  int _weightInt = 60;
  int _weightDecimal = 0;
  int _height = 160;
  int _age = 25;
  bool isFemale = false;
  String? userId;

  Future<void> _fetchUserIdFromProfile() async {
    print('[MeasurementScreen] Starting _fetchUserIdFromProfile');
    
    // Try multiple times with delay, especially useful after registration
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        print('[MeasurementScreen] Attempt $attempt to get userId');
        final userIdInt = await AuthService.getCurrentUserId();
        print('[MeasurementScreen] AuthService.getCurrentUserId() returned: $userIdInt');
        
        if (userIdInt != null) {
          userId = userIdInt.toString();
          print('[MeasurementScreen] userId set to: $userId');
          return;
        }
        
        // If first attempt fails, wait a bit before retrying (especially after registration)
        if (attempt < 3) {
          print('[MeasurementScreen] Waiting before retry...');
          await Future.delayed(Duration(milliseconds: 1000));
        }
      } catch (e) {
        print('[MeasurementScreen] Attempt $attempt failed: $e');
        if (attempt < 3) {
          await Future.delayed(Duration(milliseconds: 1000));
        }
      }
    }

    // fallback: get from arguments if not found in profile
    print('[MeasurementScreen] All attempts failed, trying fallback from arguments');
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['userId'] != null) {
      userId = args['userId'].toString();
      print('[MeasurementScreen] userId from arguments: $userId');
    } else {
      print('[MeasurementScreen] No userId found in arguments either');
      // Try to get email as fallback identifier
      if (args != null && args['email'] != null) {
        userId = args['email'].toString();
        print('[MeasurementScreen] Using email as userId fallback: $userId');
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      // Check for isFemale first (UI format)
      if (args.containsKey('isFemale')) {
        isFemale = args['isFemale'] as bool;
        print('[MeasurementScreen] Got isFemale: $isFemale');
      }
      // Fallback to gender (API format)
      else if (args.containsKey('gender')) {
        final genderValue = args['gender'];
        if (genderValue is bool) {
          isFemale = genderValue == false; // false means female in API
        } else if (genderValue is int) {
          isFemale = genderValue == 0; // 0 means female
        }
        print('[MeasurementScreen] Got gender: $genderValue, converted to isFemale: $isFemale');
      }
    }
    // Always fetch userId from profile (async)
    _fetchUserIdFromProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Body Measurements',
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'To choose the correct weight level, please enter the following data:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Picker cân nặng
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/images/weight.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'YOUR WEIGHT:',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Picker số nguyên
                        SizedBox(
                          width: 80,
                          child: CupertinoPicker(
                            backgroundColor: Colors.transparent,
                            itemExtent: 50,
                            scrollController: FixedExtentScrollController(initialItem: _weightInt - 30),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                _weightInt = index + 30;
                              });
                            },
                            children: List.generate(
                              101,
                              (index) => Center(
                                child: Text(
                                  '${index + 30}',
                                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Picker số lẻ
                        SizedBox(
                          width: 60,
                          child: CupertinoPicker(
                            backgroundColor: Colors.transparent,
                            itemExtent: 50,
                            scrollController: FixedExtentScrollController(initialItem: _weightDecimal),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                _weightDecimal = index;
                              });
                            },
                            children: List.generate(
                              10,
                              (index) => Center(
                                child: Text(
                                  '$index',
                                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text("KG", style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Picker chiều cao
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/images/height.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'YOUR HEIGHT:',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 120,
                    child: CupertinoPicker(
                      backgroundColor: Colors.transparent,
                      itemExtent: 50,
                      scrollController: FixedExtentScrollController(initialItem: _height - 100),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          _height = index + 100;
                        });
                      },
                      children: List.generate(
                        101,
                        (index) => Center(
                          child: Text(
                            '${index + 100}',
                            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text("CM", style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // Picker tuổi
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/images/age.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Lớp phủ màu tối
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  // Nội dung picker
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'YOUR AGE:',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 120,
                        child: CupertinoPicker(
                          backgroundColor: Colors.transparent,
                          itemExtent: 50,
                          scrollController: FixedExtentScrollController(initialItem: _age - 1),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              _age = index + 1;
                            });
                          },
                          children: List.generate(
                            101,
                            (index) => Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Text("AGE", style: TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFf70d6f),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  // Ensure userId is fetched
                  await _fetchUserIdFromProfile();

                  if (userId != null && userId!.isNotEmpty) {
                    final saveWeight = (_weightInt + _weightDecimal / 10).toDouble();
                    print('[MeasurementScreen] Saving health data: userId=$userId, weight=$saveWeight, height=$_height, age=$_age, gender=${!isFemale}');

                    try {
                      final result = await HealthService.saveHealthData(
                        userId: int.tryParse(userId!) ?? 0,
                        weight: saveWeight,
                        height: _height.toDouble(),
                        age: _age,
                        gender: !isFemale, // Convert isFemale to API format: false = female, true = male
                      );

                      print('[MeasurementScreen] Health data saved successfully: $result');

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Thông tin cơ thể đã được lưu thành công!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      print('[MeasurementScreen] Error saving health data: $e');

                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Lỗi khi lưu thông tin: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    print('[MeasurementScreen] No userId found, cannot save health data');

                    // Show error message for missing userId
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Không tìm thấy ID người dùng. Vui lòng đăng nhập lại.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }

                  // Navigate to workout plan regardless of save result
                  Navigator.pushReplacementNamed(
                    context,
                    '/workout',
                    arguments: {'isFemale': isFemale},
                  );
                },
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}