import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:english_learning_app/constrants/app_constrants.dart';
import '../models/attendance_model.dart';

class AttendanceService {
  final String baseUrl = "$apiUrl/attendance";

  // Điểm danh
  Future<String> markAttendance(int userId) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/mark?userId=$userId"));
      if (response.statusCode == 200) {
        final body = response.body.trim();

        if (body.contains("already_marked")) {
          return "Bạn đã điểm danh hôm nay rồi!";
        } else if (body.contains("marked_successfully")) {
          return "Điểm danh hôm nay thành công 🎉";
        } else {
          return "Phản hồi không xác định: $body";
        }
      } else {
        return "Không thể điểm danh (${response.statusCode})";
      }
    } catch (e) {
      return "Lỗi kết nối máy chủ: $e";
    }
  }

  // Lấy streak hiện tại
  Future<int> getStreak(int userId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/streak/$userId"));
      if (response.statusCode == 200) {
        return int.tryParse(response.body.toString()) ?? 0;
      } else {
        throw Exception('Server trả mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Không thể lấy streak: $e');
    }
  }

  // Lấy lịch sử điểm danh
  Future<List<AttendanceModel>> getAttendanceHistory(int userId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/history/$userId"));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => AttendanceModel.fromJson(e)).toList();
      } else {
        throw Exception('Server trả mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Không thể lấy lịch sử điểm danh: $e');
    }
  }
}
