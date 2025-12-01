import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/view_model/login_viewmodel.dart';
import 'package:english_learning_app/views/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../localization/app_localizations.dart';

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
                Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                ),
                const SizedBox(height: 32),

                // 🔹 Title
                Text(
                  AppLocalizations.of(context).tr("welcome"),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context).tr("login_subtitle"),
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // 🔹 Email Field
                TextField(
                  onChanged: (value) => viewModel.email = value,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).tr("email"),
                    hintText: "example@gmail.com",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🔹 Password Field
                TextField(
                  onChanged: (value) => viewModel.password = value,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).tr("password"),
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 🔹 Login Button
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
                    child: Text(
                      AppLocalizations.of(context).tr("login"),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.background,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 🔹 Social Login Text
                Text(
                  AppLocalizations.of(context).tr("login_with"),
                  style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 10),

                // 🔹 Social Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.google, color: AppColors.red),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.facebook, color: AppColors.primary),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.discord, color: Colors.indigo),
                      onPressed: () {},
                    ),
                  ],
                ),

                // 🔹 Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _onClickRegister,
                      child: Text(
                        AppLocalizations.of(context).tr("register"),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          color: Color(0xFF2475FC),
                        ),
                      ),
                    ),
                  ],
                ),

                // 🔹 Forgot Password
                TextButton(
                  onPressed: () {},
                  child: Text(
                    AppLocalizations.of(context).tr("forgot_password"),
                    style: const TextStyle(
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
