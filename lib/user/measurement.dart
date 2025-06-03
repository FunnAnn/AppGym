import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'bottom_main/workout_plan.dart';

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({super.key});

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  int _weightInt = 60;
  int _weightDecimal = 0;
  int _height = 160;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Body Measurements',
          style: TextStyle(color: Colors.black),
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

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFf70d6f),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/workout');
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
