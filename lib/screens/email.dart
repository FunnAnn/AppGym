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
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('isRegister')) {
      isRegister = args['isRegister'] as bool;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Đăng nhập/Đăng ký',
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
            // Tab Đăng ký / Đăng nhập
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
                      child: const Text('Đăng ký'),
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
                      child: const Text('Đăng nhập'),
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
                        hintText: 'Nhập địa chỉ email của bạn',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.pinkTheme, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Mật khẩu', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                    TextField(
                      controller: passwordController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        hintText: 'Nhập mật khẩu của bạn',
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
                      const Text('Họ và tên', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                      TextField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                          hintText: 'Nhập họ và tên của bạn',
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Ngày sinh', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
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
                            hintText: 'Chọn ngày sinh',
                          ),
                          child: Text(
                            dateOfBirth == null
                                ? ''
                                : '${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Giới tính', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedGender = 'Nam'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedGender == 'Nam' ? AppColors.pinkTheme : Colors.grey.shade300,
                                    width: selectedGender == 'Nam' ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: selectedGender == 'Nam' ? AppColors.pinkTheme.withOpacity(0.1) : Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.male,
                                      color: selectedGender == 'Nam' ? AppColors.pinkTheme : Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Nam',
                                      style: TextStyle(
                                        color: selectedGender == 'Nam' ? AppColors.pinkTheme : Colors.black,
                                        fontWeight: selectedGender == 'Nam' ? FontWeight.bold : FontWeight.normal,
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
                              onTap: () => setState(() => selectedGender = 'Nữ'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedGender == 'Nữ' ? AppColors.pinkTheme : Colors.grey.shade300,
                                    width: selectedGender == 'Nữ' ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: selectedGender == 'Nữ' ? AppColors.pinkTheme.withOpacity(0.1) : Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.female,
                                      color: selectedGender == 'Nữ' ? AppColors.pinkTheme : Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Nữ',
                                      style: TextStyle(
                                        color: selectedGender == 'Nữ' ? AppColors.pinkTheme : Colors.black,
                                        fontWeight: selectedGender == 'Nữ' ? FontWeight.bold : FontWeight.normal,
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
                      const Text('Số điện thoại', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Nhập số điện thoại của bạn',
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
                  onPressed: isLoading || !isFormValid() ? null : () async {
                    setState(() {
                      isLoading = true;
                      errorMessage = null;
                    });
                    try {
                      if (isRegister) {
                        // Validation trước khi gửi
                        if (!isValidEmail(emailController.text.trim())) {
                          throw Exception('Email không hợp lệ');
                        }
                        
                        if (firstNameController.text.trim().length < 2) {
                          throw Exception('Họ tên phải có ít nhất 2 ký tự');
                        }
                        
                        if (!isValidPhoneNumber(phoneController.text.trim())) {
                          throw Exception('Số điện thoại không hợp lệ');
                        }
                        
                        // Format ngày sinh theo định dạng YYYY-MM-DD
                        String formattedDate = '${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}';
                        
                        // Convert gender để match với backend (false: female, true: male)
                        bool genderValue = selectedGender == 'Nam'; // Nam = true (male), Nữ = false (female)

                        print('Preparing registration with:');
                        print('FullName: ${firstNameController.text.trim()}');
                        print('Email: ${emailController.text.trim()}');
                        print('DateOfBirth: ${formattedDate}');
                        print('PhoneNumber: ${phoneController.text.trim()}');
                        print('Gender: ${genderValue} (${selectedGender})');

                        // Xử lý đăng ký
                        try {
                          final registerResult = await AuthService.register(
                            fullName: firstNameController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text,
                            dateOfBirth: formattedDate,
                            phoneNumber: phoneController.text.trim(),
                            gender: genderValue,
                          );
                          
                          print('Registration successful: $registerResult');
                          
                          // Hiển thị thông báo thành công
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đăng ký thành công! Đang đăng nhập...')),
                          );
                          
                          // Tự động đăng nhập sau khi đăng ký thành công
                          try {
                            print('Auto-login after registration...');
                            final loginResult = await AuthService.login(
                              email: emailController.text.trim(),
                              password: passwordController.text,
                            );
                            print('Auto-login successful: $loginResult');
                            
                            // Chờ một chút để token được lưu
                            await Future.delayed(Duration(milliseconds: 500));
                            
                            // Hiển thị thông báo đăng nhập thành công
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Đăng nhập thành công! Vui lòng nhập thông tin cơ thể.')),
                            );
                          } catch (loginError) {
                            print('Auto-login failed: $loginError');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Đăng ký thành công nhưng không thể tự động đăng nhập. Vui lòng đăng nhập lại.'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                          
                          // Chuyển sang trang measurement sau khi đăng ký (và tự động đăng nhập)
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
                          // Clear form fields
                          firstNameController.clear();
                          phoneController.clear();
                          dateOfBirth = null;
                          selectedGender = null;
                          // Keep email and password for convenience
                        });
                      } else {
                        // Xử lý đăng nhập
                        final loginResult = await AuthService.login(
                          email: emailController.text.trim(),
                          password: passwordController.text,
                        );
                        
                        print('Login result: $loginResult');
                        print('Login result keys: ${loginResult.keys.toList()}');
                        
                        // Lấy role từ profile để đảm bảo chính xác
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
                        
                        print('User role from profile: $userRole');
                        
                        // Hiển thị thông báo thành công
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Đăng nhập thành công!')),
                        );
                        
                        // Chuyển hướng dựa trên role
                        switch (userRole) {
                          case 'OWNER':
                          case 'ADMIN':
                            // Chuyển sang dashboard cho owner và admin
                            Navigator.pushReplacementNamed(context, '/admin');
                            break;
                          case 'COACH':
                            // Chuyển sang coach dashboard
                            Navigator.pushReplacementNamed(context, '/coach_dashboard');
                            break;
                          case 'CUSTOMER':
                          case 'USER':
                          default:
                            // Xử lý customer - chuyển sang workout_plan
                            // Thử các cách khác nhau để lấy userId
                            String userId = '';
                            
                            // Thử lấy từ các field phổ biến
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
                            
                            // Nếu không có userId nhưng có accessToken, dùng email làm userId tạm thời
                            if (userId.isEmpty && loginResult.containsKey('accessToken')) {
                              userId = emailController.text.trim();
                              print('Using email as temporary userId: $userId');
                            }
                            
                            print('Extracted userId: $userId');
                            
                            if (userId.isEmpty) {
                              print('Available login result data: $loginResult');
                              throw Exception('Không thể lấy user ID từ server. Available keys: ${loginResult.keys.toList()}');
                            }
                            
                            // Lấy gender từ profile
                            String? profileJson = await AuthService.getUserProfile();
                            print('Profile JSON: ' + (profileJson ?? 'null'));
                            bool isFemale = false; // mặc định nam
                            if (profileJson != null) {
                              final profileMap = jsonDecode(profileJson);
                              if (profileMap is Map && profileMap.containsKey('data')) {
                                final data = profileMap['data'];
                                if (data is Map && data.containsKey('gender')) {
                                  final g = data['gender'];
                                  if (g is bool) {
                                    isFemale = g == false; // false = female, true = male
                                  } else if (g is int) {
                                    isFemale = g == 0; // 0 = female, 1 = male
                                  } else {
                                    isFemale = false; // default to male
                                  }
                                }
                              }
                            }
                            
                            // Cập nhật selectedGender để đồng bộ radio button
                            setState(() {
                              selectedGender = isFemale ? 'Nữ' : 'Nam';
                            });
                            print('Gender from profile - isFemale: $isFemale, selectedGender: $selectedGender');
                            
                            // Chuyển đến trang workout_plan với userId và isFemale
                            Navigator.pushReplacementNamed(
                              context,
                              '/workout',
                              arguments: {
                                'userId': userId,
                                'isFemale': isFemale, // false = male, true = female for UI
                              },
                            );
                            break;
                        }
                      }
                    } catch (e) {
                      setState(() {
                        // Làm sạch error message để hiển thị user-friendly hơn
                        String cleanError = e.toString();
                        if (cleanError.startsWith('Exception: ')) {
                          cleanError = cleanError.substring('Exception: '.length);
                        }
                        errorMessage = cleanError;
                      });
                      print('Full error details: $e');
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
                          isRegister ? 'ĐĂNG KÝ' : 'ĐĂNG NHẬP',
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
