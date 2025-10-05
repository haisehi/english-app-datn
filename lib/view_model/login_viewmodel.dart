import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginViewModel {
      String email = '';
      String password = '';

      final AuthService _authService = AuthService();

      // Phương thức kiểm tra dữ liệu nhập vào
      bool validateInputs(BuildContext context) {
            if (email.isEmpty) {
                  _showError(context, 'Vui lòng nhập email!');
                  return false;
            }
            if (password.isEmpty) {
                  _showError(context, 'Vui lòng nhập mật khẩu!');
                  return false;
            }

            return true;
      }

      // Phương thức đăng nhập với kiểm tra thông tin trước
      Future<void> login(BuildContext context) async {
            if (!validateInputs(context)) return;

            bool isLoggedIn = await _authService.login(email, password);
            if (isLoggedIn) {
                  print("đăng nhập thành công");
                  Navigator.pushReplacementNamed(context, '/student');
            } else {
                  _showError(context, 'Đăng nhập thất bại, vui lòng đăng nhập lại!');
            }
      }

      Future<void> logout(BuildContext context) async {

            bool isLoggedIn = await _authService.logout();
            if (isLoggedIn) {
                  print("Đăng xuất thành công");
                  _showError(context, 'Đăng xuất thành công');
                  Navigator.pushReplacementNamed(context, '/login');
            } else {
                  _showError(context, 'Đăng xuất thất bại');
            }
      }

      // Phương thức hiển thị lỗi
      void _showError(BuildContext context, String message) {
            ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
            );
      }
}
