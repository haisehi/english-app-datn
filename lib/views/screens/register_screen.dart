import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/view_model/register_viewmodel.dart';
import 'package:english_learning_app/views/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../../localization/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

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
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo ảnh tĩnh
              Image.asset(
                'assets/images/logo.png',
                height: 120,
              ),
              const SizedBox(height: 80),

              // Email Field
              _buildTextField(
                icon: Icons.email,
                label: loc.tr("email"),
                hintText: "example@gmail.com",
                onChanged: (val) => viewModel.email = val,
              ),

              // Phone Field
              _buildTextField(
                icon: Icons.phone,
                label: loc.tr("phone"),
                onChanged: (val) => viewModel.phone = val,
              ),

              // Full Name Field
              _buildTextField(
                icon: Icons.account_circle,
                label: loc.tr("full_name"),
                onChanged: (val) => viewModel.fullName = val,
              ),

              // Password Field
              _buildTextField(
                icon: Icons.lock,
                label: loc.tr("password"),
                obscureText: true,
                onChanged: (val) => viewModel.password = val,
              ),

              // Re-enter Password Field
              _buildTextField(
                icon: Icons.lock,
                label: loc.tr("re_password"),
                obscureText: true,
                onChanged: (val) => viewModel.rePassword = val,
              ),

              const SizedBox(height: 20),

              // Register Button
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
                  child: Text(
                    loc.tr("register").toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    loc.tr("already_have_account"),
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  TextButton(
                    onPressed: _goToLogin,
                    child: Text(
                      loc.tr("login").toUpperCase(),
                      style: const TextStyle(
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
                child: Text(
                  loc.tr("forgot_password"),
                  style: const TextStyle(
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
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
