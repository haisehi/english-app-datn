import 'dart:convert';
import 'package:english_learning_app/constrants/app_constrants.dart';
import 'package:english_learning_app/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // final String baseUrl = "http://localhost:8080/api/v1/auth/authenticate";

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("${apiUrl}/auth/authenticate"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Lưu token nếu đăng nhập thành công
      // Phân tích cú pháp JSON để lấy access_token và refresh_token
      var jsonResponse = jsonDecode(response.body);

      String accessToken = jsonResponse['access_token'];
      String refreshToken = jsonResponse['refresh_token'];
      String role = jsonResponse['role'];
      String fullNameUser = jsonResponse['full_name_user'];
      print(accessToken);
      // Lưu token vào SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('refresh_token', refreshToken);
      await prefs.setString('role', role);
      await prefs.setString('full_name_user', fullNameUser);

      await fetchAndSaveUserProfile();
      return true;
    } else {
      return false;
    }
  }

  Future<void> fetchAndSaveUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final response = await http.get(
      Uri.parse("$apiUrl/users/me"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      await prefs.setInt("id_user", data["id"]);
      await prefs.setString("full_name_user", data["fullName"]);
      await prefs.setString("email_user", data["email"]);
      await prefs.setString("phone_user", data["phone"]);
      await prefs.setString("avatar_user", data["avatar"]);
      await prefs.setInt("status_user", data["status"]);
    } else {
      throw Exception("Lấy thông tin user thất bại: ${response.statusCode}");
    }
  }

  Future<bool> logout() async {

    // Lấy instance của SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');

    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final response = await http.post(
      Uri.parse("${apiUrl}/auth/logout"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if(response.statusCode == 200){


      // Xóa các token đã lưu
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      await prefs.remove('role');
      await prefs.remove('full_name_user');
      await prefs.remove('id_user');
      return true;
    }else{
      return false;
    }

    // Bạn có thể thực hiện thêm các bước khác như điều hướng về trang đăng nhập
  }
  Future<bool> registerUser(UserModel user) async {

    try {
      final response = await http.post(
        Uri.parse("${apiUrl}/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final error = jsonDecode(response.body)["message"];
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}