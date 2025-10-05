

import 'package:english_learning_app/models/user_model.dart';
import 'package:english_learning_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class RegisterViewModel {


      String email = '';
      String password = '';
      String phone = '';
      String role = '';
      String avatar = '';
      String fullName = '';
      String rePassword = '';
      final AuthService _authService = AuthService();

      bool ValidateFormRegister(BuildContext context){

        // validate email
        if (email.isEmpty) {
          _showError(context, 'Vui lòng nhập email!');
          return false;
        }
        // else {
        //   // check email @gmail.com
        //   RegExp regex = RegExp(r"^[a-zA-Z0-9._%+-]+@gmail.com$");
        //   if(!regex.hasMatch(email)){
        //     _showError(context, 'Vui Lòng Nhập Đúng Định Đạng @gmail.com');
        //     return false;
        //
        //   }
        // }
        // validate password
        if (password.isEmpty) {
          _showError(context, 'Vui Lòng Nhập Mật Khẩu');
          return false;
        }
        // validate repassword
        if(rePassword.isEmpty){
          _showError(context, 'Vui Lòng Nhập Lại Mật Khẩu');
          return false;
        }else if(rePassword != password){
          _showError(context, 'Vui Lòng Nhập Lại Mật Khẩu');
          return false;
        }
        if(fullName.isEmpty){
          _showError(context, 'Vui Lòng Nhập Họ Và Tên');
          return false;
        }

        // validate phone number
        if(phone.isEmpty){
          _showError(context, 'Vui Lòng Nhập Số điện thoại');
          return false;
        }
        return true;
      }
      Future<void> register(BuildContext context) async {
        if (!ValidateFormRegister(context)) return;
        print("role $role");
        UserModel userModel = UserModel(fullName: fullName, email: email, password: password, phone: phone, role: role, avatar: avatar);

        bool isRegister = await _authService.registerUser(userModel);
        if(isRegister){
          print("đăng ký thành công");
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          _showError(context, 'Đăng ký thất bại, vui lòng đăng ký lại!');
        }
      }

      void _showError(BuildContext context, String message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }


}