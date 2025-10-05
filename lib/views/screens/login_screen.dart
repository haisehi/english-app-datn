import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/view_model/login_viewmodel.dart';
import 'package:english_learning_app/views/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginViewModel viewModel = LoginViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png', // Đổi logo tại đây
                  height: 120,
                ),
                const SizedBox(height: 32),

                // Title
                const Text(
                  'Chào mừng bạn!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Đăng nhập để tiếp tục học tiếng Anh',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Email Field
                TextField(
                  onChanged: (value) => viewModel.email = value,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(fontFamily: 'Roboto'),
                    hintText: 'example@gmail.com',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Field
                TextField(
                  onChanged: (value) => viewModel.password = value,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    labelStyle: const TextStyle(fontFamily: 'Roboto'),
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => viewModel.login(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'ĐĂNG NHẬP',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.background,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // đăng nhập bằng bên thứ 3
                Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Hoặc đăng nhập với",
                      style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.google, color: AppColors.red),
                          onPressed: () {
                            // TODO: Xử lý đăng nhập Google
                          },
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.facebook, color: AppColors.primary),
                          onPressed: () {
                            // TODO: Xử lý đăng nhập Facebook
                          },
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.discord, color: Colors.indigo),
                          onPressed: () {
                            // TODO: Xử lý đăng nhập Discord
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                // Links
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _onClickRegister,
                      child: const Text(
                        "Đăng ký",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          color: Color(0xFF2475FC),
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Thêm chức năng quên mật khẩu nếu có
                  },
                  child: const Text(
                    "Quên mật khẩu?",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onClickRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }
}
