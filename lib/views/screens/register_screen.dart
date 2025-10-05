import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/view_model/register_viewmodel.dart';
import 'package:english_learning_app/views/screens/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String role = "USER"; // mặc định là USER
  late final RegisterViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = RegisterViewModel();
    viewModel.role = role;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo ảnh tĩnh thay thế Lottie
              Image.asset(
                'assets/images/logo.png', // Đảm bảo file ảnh đã có trong pubspec.yaml
                height: 120,
              ),
              const SizedBox(height: 80),
              _buildTextField(
                icon: Icons.email,
                label: "Email",
                hintText: "example@gmail.com",
                onChanged: (val) => viewModel.email = val,
              ),
              _buildTextField(
                icon: Icons.phone,
                label: "Số điện thoại",
                onChanged: (val) => viewModel.phone = val,
              ),
              _buildTextField(
                icon: Icons.account_circle,
                label: "Họ và tên",
                onChanged: (val) => viewModel.fullName = val,
              ),
              _buildTextField(
                icon: Icons.lock,
                label: "Mật khẩu",
                obscureText: true,
                onChanged: (val) => viewModel.password = val,
              ),
              _buildTextField(
                icon: Icons.lock,
                label: "Nhập Lại Mật Khẩu",
                obscureText: true,
                onChanged: (val) => viewModel.rePassword = val,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => viewModel.register(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "ĐĂNG KÝ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Đã có tài khoản?",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  TextButton(
                    onPressed: _goToLogin,
                    child: const Text(
                      "ĐĂNG NHẬP",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primary,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // TODO: Quên mật khẩu
                },
                child: const Text(
                  "Quên Mật Khẩu?",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.red,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String label,
    String? hintText,
    bool obscureText = false,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        onChanged: onChanged,
        obscureText: obscureText,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontFamily: 'Roboto',
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primary),
          labelText: label,
          labelStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontFamily: 'Roboto',
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontFamily: 'Roboto',
          ),
          filled: true,
          fillColor: AppColors.divider,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  void _goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
