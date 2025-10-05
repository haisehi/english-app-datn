import 'dart:convert';

import 'package:english_learning_app/constrants/app_constrants.dart';
import 'package:english_learning_app/models/exam_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StatisticsScoreViewmodel extends ChangeNotifier  {


  List<ExamModel> _exams = [];
  bool _isLoading = false;

  List<ExamModel> get exams => _exams;


  bool get isLoading => _isLoading;

  void fetchExams(int courseID) async {
    _isLoading = true;
    notifyListeners();
    notifyListeners();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception("Token không tồn tại");
      }
      final response = await http.get(
        Uri.parse("${apiUrl}/user-test/ranked-tests-example?courseId=$courseID"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData =
        json.decode(utf8.decode(response.bodyBytes));
        _exams = jsonData.map((json) => ExamModel.fromJsonStatistic(json)).toList();
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

  /// Nhóm dữ liệu theo tên bài thi và trả về danh sách điểm số
  Map<String, List<double>> groupExamsByName() {
    Map<String, List<double>> groupedData = {};
    for (var exam in _exams) {
      if (!groupedData.containsKey(exam.examName)) {
        groupedData[exam.examName] = [];
      }
      groupedData[exam.examName]!.add(exam.myScore);
    }
    return groupedData;
  }
}