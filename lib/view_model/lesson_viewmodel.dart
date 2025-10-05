import 'dart:convert';

import 'package:english_learning_app/constrants/app_constrants.dart';
import 'package:english_learning_app/models/lesson_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LessonViewModel extends ChangeNotifier {
  List<LessonModel> _lessons = [];
  bool _isLoading = false;

  List<LessonModel> get lessons => _lessons;

  bool get isLoading => _isLoading;

  Future<void> fetchLessons(int courseID) async {
    _isLoading = true;
    notifyListeners();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception("Token không tồn tại");
      }
      final response = await http.get(
        Uri.parse("${apiUrl}/lessons/user?courseId=$courseID"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData =
            json.decode(utf8.decode(response.bodyBytes));
        _lessons = jsonData.map((json) => LessonModel.fromJson(json)).toList();
      } else {
        print('Lỗi: ${response.statusCode}');
        throw Exception('Lỗi');
      }
    } catch (e) {
      print('Lỗi khi lấy khóa học: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProcess(
      int courseId, int lessonId, double progress) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception("Token không tồn tại");
      }
      final Map<String, dynamic> data = {
        'courseId': courseId,
        'lessonId': lessonId,
        'progress': progress,
      };
      final response = await http.post(
        Uri.parse("${apiUrl}/user-lesson/start-or-update-lesson"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Cập nhật tiến trình thành công");
      } else {
        print("Cập nhật thất bại: ${response.statusCode}");
        print("Nội dung: ${response.body}");
        throw Exception("Lỗi từ server: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Lỗi khi cập nhật tiến trình: $e");
    }
  }

  Future<double> fetchGetProgressByLesson(int courseId, int lessonId) async {
    // Lấy token từ SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');
    if (token == null) {
      throw Exception("Token không tồn tại");
    }
    final response = await http.get(
      Uri.parse(
          '${apiUrl}/user-lesson/progress?courseId=$courseId&lessonId=$lessonId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception('Failed to fetch progress');
    }
  }
}
