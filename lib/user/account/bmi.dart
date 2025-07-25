import 'package:flutter/material.dart';
import '../bottom_main/bottom.dart';
import '../../theme/app_colors.dart';
import '../../api_service/health_service.dart';
import '../../model/health.dart' as HealthModel;

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  
  bool _isLoading = true;
  bool _isSaving = false;
  Map<String, dynamic>? _currentUser;
  HealthModel.Data? _healthData;
  
  bool? _selectedGender; // true = male, false = female
  double? _calculatedBMI;
  String? _bmiStatus;
  Color? _bmiColor;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final user = await HealthService.getCurrentUser();
      
      if (user != null && user['user_id'] != null) {
        final healthData = await HealthService.getHealthByUserId(user['user_id']);
        
        setState(() {
          _currentUser = user;
          _healthData = healthData != null ? HealthModel.Data.fromJson(healthData) : null;
          
          // Pre-fill gender from user profile
          if (user['gender'] != null) {
            _selectedGender = user['gender'];
          }
          
          // Fill form with existing health data
          if (healthData != null) {
            _heightController.text = healthData['height']?.toString() ?? '';
            _weightController.text = healthData['weight']?.toString() ?? '';
            _ageController.text = healthData['age']?.toString() ?? '';
            _selectedGender = healthData['gender'] ?? _selectedGender;
            _calculatedBMI = healthData['bmi'];
            _bmiStatus = healthData['bmiStatus'];
            if (_calculatedBMI != null) {
              _bmiColor = HealthService.getBMIColor(_calculatedBMI!);
            }
          }
          
          _isLoading = false;
        });
      } else {
        throw Exception('Unable to get user information');
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _calculateAndSaveBMI() async {
    if (_heightController.text.isEmpty || 
        _weightController.text.isEmpty || 
        _ageController.text.isEmpty ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final height = double.parse(_heightController.text);
      final weight = double.parse(_weightController.text);
      final age = int.parse(_ageController.text);

      if (height <= 0 || weight <= 0 || age <= 0) {
        throw Exception('All values must be greater than 0');
      }

      setState(() {
        _isSaving = true;
      });

      // Calculate BMI locally first
      final bmi = HealthService.calculateBMI(weight, height);
      final status = HealthService.getBMIStatus(bmi);
      final color = HealthService.getBMIColor(bmi);

      setState(() {
        _calculatedBMI = bmi;
        _bmiStatus = status;
        _bmiColor = color;
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('BMI calculated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildUserInfo() {
    if (_currentUser == null) return Container();
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: AppColors.pinkTheme),
                const SizedBox(width: 8),
                Text(
                  'User Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pinkTheme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Name', _currentUser!['full_name'] ?? 'N/A'),
            _buildInfoRow('Email', _currentUser!['email'] ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBMIInput() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calculate, color: AppColors.pinkTheme),
                const SizedBox(width: 8),
                Text(
                  'BMI Calculator',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pinkTheme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Gender Selection
            Text(
              'Gender',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedGender = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedGender == true ? AppColors.pinkTheme : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedGender == true ? AppColors.pinkTheme : Colors.grey[300]!,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.male,
                            color: _selectedGender == true ? Colors.white : Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Male',
                            style: TextStyle(
                              color: _selectedGender == true ? Colors.white : Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedGender = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedGender == false ? AppColors.pinkTheme : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedGender == false ? AppColors.pinkTheme : Colors.grey[300]!,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.female,
                            color: _selectedGender == false ? Colors.white : Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Female',
                            style: TextStyle(
                              color: _selectedGender == false ? Colors.white : Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Age Input
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age (years)',
                prefixIcon: const Icon(Icons.cake),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Height and Weight Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Height (cm)',
                      prefixIcon: const Icon(Icons.height),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      prefixIcon: const Icon(Icons.monitor_weight),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Calculate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _calculateAndSaveBMI,
                icon: _isSaving 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.calculate, color: Colors.white),
                label: Text(
                  _isSaving ? 'Calculating...' : 'Calculate BMI',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pinkTheme,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBMIResult() {
    if (_calculatedBMI == null) return Container();
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: AppColors.pinkTheme),
                const SizedBox(width: 8),
                Text(
                  'BMI Result',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pinkTheme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // BMI Circle Display
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _bmiColor?.withOpacity(0.1),
                border: Border.all(color: _bmiColor!, width: 3),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _calculatedBMI!.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _bmiColor,
                      ),
                    ),
                    Text(
                      'BMI',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // BMI Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _bmiColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _bmiStatus ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Health Summary
            _buildHealthSummary(),
            const SizedBox(height: 16),
            _buildBMIScale(),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthSummary() {
    if (_healthData == null) return Container();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Summary',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem('Gender', _selectedGender == true ? 'Male' : 'Female'),
              ),
              Expanded(
                child: _buildSummaryItem('Age', '${_healthData!.age ?? 0} years'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem('Height', '${_healthData!.height ?? 0} cm'),
              ),
              Expanded(
                child: _buildSummaryItem('Weight', '${_healthData!.weight ?? 0} kg'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
          children: [
            TextSpan(text: '$label: '),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBMIScale() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BMI Scale:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildScaleItem('Underweight', '< 18.5', Colors.blue),
        _buildScaleItem('Normal weight', '18.5 - 24.9', Colors.green),
        _buildScaleItem('Overweight', '25.0 - 29.9', Colors.orange),
        _buildScaleItem('Obese', '≥ 30.0', Colors.red),
      ],
    );
  }

  Widget _buildScaleItem(String label, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
          Text(range, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BMI Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.pinkTheme,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildUserInfo(),
                  _buildBMIInput(),
                  _buildBMIResult(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/workout');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/calendar');
          } else if (index == 2) {
            // Handle "Scan QR" button tap
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/package');
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
