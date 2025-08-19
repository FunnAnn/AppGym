import 'package:flutter/material.dart';
import '../theme/app_colors.dart'; // Thêm dòng này
import '../api_service/auth_service.dart'; // Thêm dòng này
import 'dart:convert'; // Thêm dòng này để sử dụng jsonDecode
import 'package:http/http.dart' as http; // Thêm dòng này để sử dụng http.Response

class EmailScreen extends StatefulWidget {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  bool isRegister = true;
  bool didInitIsRegister = false; // Thêm biến này
  bool showPassword = false;
  bool isLoading = false;
  String? errorMessage;
  String? selectedGender; // Thêm biến để lưu gender

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  DateTime? dateOfBirth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!didInitIsRegister) { // Chỉ gán một lần duy nhất
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey('isRegister')) {
        isRegister = args['isRegister'] as bool;
      }
      didInitIsRegister = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Sign In / Register',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tab Register / Login
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRegister ? AppColors.pinkTheme : Colors.white,
                        foregroundColor: isRegister ? Colors.white : Colors.black,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: () => setState(() => isRegister = true),
                      child: const Text('Register'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isRegister ? AppColors.pinkTheme : Colors.white,
                        foregroundColor: !isRegister ? Colors.white : Colors.black,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: () => setState(() => isRegister = false),
                      child: const Text('Sign In'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Email', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your email address',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.pinkTheme, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Password', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                    TextField(
                      controller: passwordController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        suffixIcon: IconButton(
                          icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => showPassword = !showPassword),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.pinkTheme, width: 2),
                        ),
                      ),
                    ),
                    if (isRegister) ...[
                      const SizedBox(height: 16),
                      const Text('Full Name', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                      TextField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your full name',
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Date of Birth', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000, 1, 1),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) setState(() => dateOfBirth = picked);
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            hintText: 'Select date of birth',
                          ),
                          child: Text(
                            dateOfBirth == null
                                ? ''
                                : '${dateOfBirth!.day.toString().padLeft(2, '0')}/${dateOfBirth!.month.toString().padLeft(2, '0')}/${dateOfBirth!.year}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Gender', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedGender = 'Male'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedGender == 'Male' ? AppColors.pinkTheme : Colors.grey.shade300,
                                    width: selectedGender == 'Male' ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: selectedGender == 'Male' ? AppColors.pinkTheme.withOpacity(0.1) : Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.male,
                                      color: selectedGender == 'Male' ? AppColors.pinkTheme : Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Male',
                                      style: TextStyle(
                                        color: selectedGender == 'Male' ? AppColors.pinkTheme : Colors.black,
                                        fontWeight: selectedGender == 'Male' ? FontWeight.bold : FontWeight.normal,
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
                              onTap: () => setState(() => selectedGender = 'Female'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedGender == 'Female' ? AppColors.pinkTheme : Colors.grey.shade300,
                                    width: selectedGender == 'Female' ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: selectedGender == 'Female' ? AppColors.pinkTheme.withOpacity(0.1) : Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.female,
                                      color: selectedGender == 'Female' ? AppColors.pinkTheme : Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Female',
                                      style: TextStyle(
                                        color: selectedGender == 'Female' ? AppColors.pinkTheme : Colors.black,
                                        fontWeight: selectedGender == 'Female' ? FontWeight.bold : FontWeight.normal,
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
                      const Text('Phone Number', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Enter your phone number',
                        ),
                      ),
                    ],
                    if (errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pinkTheme,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isLoading ? null : () async {
                    setState(() {
                      isLoading = true;
                      errorMessage = null;
                    });
                    try {
                      if (isRegister) {
                        // Validation before sending
                        if (!isValidEmail(emailController.text.trim())) {
                          throw Exception('Invalid email');
                        }
                        if (firstNameController.text.trim().length < 2) {
                          throw Exception('Full name must be at least 2 characters');
                        }
                        if (!isValidPhoneNumber(phoneController.text.trim())) {
                          throw Exception('Invalid phone number');
                        }
                        String formattedDate = '${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}';
                        bool genderValue = selectedGender == 'Male'; // Male = true, Female = false

                        // Registration
                        try {
                          final registerResult = await AuthService.register(
                            fullName: firstNameController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text,
                            dateOfBirth: formattedDate,
                            phoneNumber: phoneController.text.trim(),
                            gender: genderValue,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Registration successful! Logging in...')),
                          );
                          // Auto login after registration
                          try {
                            final loginResult = await AuthService.login(
                              email: emailController.text.trim(),
                              password: passwordController.text,
                            );
                            await Future.delayed(Duration(milliseconds: 500));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Login successful! Please enter your body information.')),
                            );
                          } catch (loginError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Registration successful but auto-login failed. Please login again.'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                          Navigator.pushReplacementNamed(
                            context,
                            '/measurement',
                            arguments: {
                              'gender': genderValue,
                              'email': emailController.text.trim(),
                            },
                          );
                        } catch (e) {
                          rethrow;
                        }
                        setState(() {
                          isRegister = false;
                          firstNameController.clear();
                          phoneController.clear();
                          dateOfBirth = null;
                          selectedGender = null;
                        });
                      } else {
                        // Login
                        final loginResult = await AuthService.login(
                          email: emailController.text.trim(),
                          password: passwordController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Login successful!')),
                        );
                        String? profileJson = await AuthService.getUserProfile();
                        String userRole = 'USER';
                        if (profileJson != null) {
                          final profileMap = jsonDecode(profileJson);
                          if (profileMap is Map && profileMap.containsKey('data')) {
                            final data = profileMap['data'];
                            if (data is Map && data.containsKey('role')) {
                              userRole = data['role']?.toString().toUpperCase() ?? 'USER';
                            }
                          }
                        }
                        switch (userRole) {
                          case 'OWNER':
                          case 'ADMIN':
                            Navigator.pushReplacementNamed(context, '/admin');
                            break;
                          case 'COACH':
                            Navigator.pushReplacementNamed(context, '/coach_dashboard');
                            break;
                          case 'CUSTOMER':
                          case 'USER':
                          default:
                            String userId = '';
                            if (loginResult.containsKey('user_id')) {
                              userId = loginResult['user_id']?.toString() ?? '';
                            } else if (loginResult.containsKey('id')) {
                              userId = loginResult['id']?.toString() ?? '';
                            } else if (loginResult.containsKey('userId')) {
                              userId = loginResult['userId']?.toString() ?? '';
                            } else if (loginResult.containsKey('user')) {
                              final user = loginResult['user'];
                              if (user is Map) {
                                userId = user['id']?.toString() ?? user['user_id']?.toString() ?? '';
                              }
                            }
                            if (userId.isEmpty && loginResult.containsKey('accessToken')) {
                              userId = emailController.text.trim();
                            }
                            if (userId.isEmpty) {
                              throw Exception('Cannot get user ID from server. Available keys: ${loginResult.keys.toList()}');
                            }
                            String? profileJson = await AuthService.getUserProfile();
                            bool isFemale = false;
                            if (profileJson != null) {
                              final profileMap = jsonDecode(profileJson);
                              if (profileMap is Map && profileMap.containsKey('data')) {
                                final data = profileMap['data'];
                                if (data is Map && data.containsKey('gender')) {
                                  final g = data['gender'];
                                  if (g is bool) {
                                    isFemale = g == false;
                                  } else if (g is int) {
                                    isFemale = g == 0;
                                  } else {
                                    isFemale = false;
                                  }
                                }
                              }
                            }
                            setState(() {
                              selectedGender = isFemale ? 'Female' : 'Male';
                            });
                            Navigator.pushReplacementNamed(
                              context,
                              '/workout',
                              arguments: {
                                'userId': userId,
                                'isFemale': isFemale,
                              },
                            );
                            break;
                        }
                      }
                    } catch (e) {
                      setState(() {
                        String cleanError = e.toString();
                        if (cleanError.startsWith('Exception: ')) {
                          cleanError = cleanError.substring('Exception: '.length);
                        }
                        errorMessage = cleanError;
                      });
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          isRegister ? 'REGISTER' : 'SIGN IN',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isFormValid() {
    if (isRegister) {
      // Kiểm tra các trường cho chế độ Đăng ký
      return emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          firstNameController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          dateOfBirth != null &&
          selectedGender != null;
    } else {
      // Kiểm tra các trường cho chế độ Đăng nhập (nếu có, bạn chưa thêm logic đăng nhập vào AuthService)
      return emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
    }
  }

  // Validation methods
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  bool isValidPhoneNumber(String phone) {
    // Vietnamese phone number validation (10-11 digits, starts with 0)
    return RegExp(r'^0[0-9]{9,10}$').hasMatch(phone);
  }
}
