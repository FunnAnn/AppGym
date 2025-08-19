import 'package:flutter/material.dart';
import '../bottom_main/bottom.dart';
import '../../theme/app_colors.dart';
import '../../api_service/health_service.dart';
import '../../api_service/auth_service.dart';
import 'dart:convert';

class BodyMeasurementDetailScreen extends StatefulWidget {
  const BodyMeasurementDetailScreen({Key? key}) : super(key: key);

  @override
  State<BodyMeasurementDetailScreen> createState() => _BodyMeasurementDetailScreenState();
}

class _BodyMeasurementDetailScreenState extends State<BodyMeasurementDetailScreen> {
  int? weight;
  int? height;
  int? age; 
  int? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, fetchMeasurement);
  }

  Future<void> fetchMeasurement() async {
    // Get userId from AuthService helper function
    int? profileUserId;
    try {
      profileUserId = await AuthService.getCurrentUserId();
    } catch (e) {
      print('[BodyMeasurementDetailScreen] Error getting userId from AuthService: $e');
    }
    
    // Fallback to arguments if profile doesn't have userId
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    userId = profileUserId ?? (args != null && args['userId'] != null ? int.tryParse(args['userId'].toString()) : null);
    
    print('[BodyMeasurementDetailScreen] userId from AuthService: $profileUserId');
    print('[BodyMeasurementDetailScreen] userId final: $userId');
    
    if (userId == null) {
      setState(() { isLoading = false; });
      return;
    }
    
    try {
      final healthDataResponse = await HealthService.getHealthByUserId(userId!);
      print('HealthService.getHealthByUserId($userId) response: $healthDataResponse');
      
      if (healthDataResponse != null) {
        setState(() {
          weight = (healthDataResponse['weight'] as num?)?.toInt();
          height = (healthDataResponse['height'] as num?)?.toInt();
          age = healthDataResponse['age'] as int?;
          isLoading = false;
        });
        print('Loaded weight: $weight, height: $height, age: $age from API');
      } else {
        print('No health data found for userId: $userId');
        setState(() { isLoading = false; });
      }
    } catch (e) {
      setState(() { isLoading = false; });
      print('Error fetching health for userId $userId: $e');
    }
  }

  void _editWeight() async {
    final controller = TextEditingController(text: (weight ?? '').toString());
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Weight'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Weight (kg)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newWeight = int.tryParse(controller.text);
              if (newWeight != null) {
                Navigator.pop(context, newWeight);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() {
        weight = result;
      });
      await _updateHealthData();
    }
  }

  void _editHeight() async {
    final controller = TextEditingController(text: (height ?? '').toString());
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Height'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Height (cm)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newHeight = int.tryParse(controller.text);
              if (newHeight != null) {
                Navigator.pop(context, newHeight);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() {
        height = result;
      });
      await _updateHealthData();
    }
  }

  void _editAge() async {
    final controller = TextEditingController(text: (age ?? '').toString());
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Age'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Age (years)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newAge = int.tryParse(controller.text);
              if (newAge != null) {
                Navigator.pop(context, newAge);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() {
        age = result;
      });
      await _updateHealthData();
    }
  }

  Future<void> _updateHealthData() async {
    if (userId != null && weight != null && height != null && age != null) {
      try {
        await HealthService.saveHealthData(
          userId: userId!,
          weight: weight!.toDouble(),
          height: height!.toDouble(),
          age: age!,
          gender: true, // Default gender, should be fetched from user profile if needed
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Health data updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print('Error updating health data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating health data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: AppColors.pinkTheme,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'BODY MEASUREMENTS',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: _editWeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Weight, kg', style: TextStyle(fontSize: 18)),
                        Text(
                          weight != null ? '$weight' : '--',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.pinkTheme,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.bar_chart, color: Colors.blueGrey),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: _editHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Height, cm', style: TextStyle(fontSize: 18)),
                        Text(
                          height != null ? '$height' : '--',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.pinkTheme,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.bar_chart, color: Colors.blueGrey),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: _editAge,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Age, years', style: TextStyle(fontSize: 18)),
                        Text(
                          age != null ? '$age' : '--',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.pinkTheme,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.bar_chart, color: Colors.blueGrey),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/account');
          }
        },
      ),
    );
  }
}