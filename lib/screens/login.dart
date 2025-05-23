import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background ảnh full màn hình
          SizedBox.expand(
            child: Image.asset(
              'assets/images/background_login.jpg', // đổi tên file ảnh đúng với bạn
              fit: BoxFit.cover,
            ),
          ),

          // Overlay đen mờ nếu muốn làm chữ rõ hơn (tuỳ chọn)
          Container(color: Colors.black.withOpacity(0.5)),

          // Nội dung chính
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Tiêu đề
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: 'FITNESS ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'ONLINE',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Text "Đăng nhập bằng"
                  const Text(
                    'Sign in with',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),

                  const SizedBox(height: 20),

                  // Nút đăng nhập Apple
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(color: Colors.white, Icons.apple, size: 24),
                      label: const Text(
                        'Sign in with Apple',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () {},
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Nút đăng nhập Facebook
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(color: Colors.white,Icons.facebook, size: 24),
                      label: const Text(
                        'Sign in with Facebook',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3b5998), // màu Facebook
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () {},
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Text đăng nhập/đăng ký email
                  GestureDetector(
                    onTap: () {
                      // Xử lý nhấn vào
                    },
                    child: const Text(
                      'Sign in/Register with email address',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Nút BỎ QUA
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/measurement');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'SKIP',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Text hỏi huấn luyện viên
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Are you a coach?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          // Xử lý nhấn vào
                        },
                        child: const Text(
                          'Tap here',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Dòng thông báo thỏa thuận người dùng
                  Column(
                    children: [
                      const Text(
                        'By continuing to use Fitness Online, you agree to accept',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 4),

                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'User Agreement',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Text(
                            'and',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
