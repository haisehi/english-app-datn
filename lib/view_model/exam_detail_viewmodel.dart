import 'dart:convert';

import 'package:english_learning_app/constrants/app_constrants.dart';
import 'package:english_learning_app/models/question_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ExamDetailViewmodel extends ChangeNotifier{
  bool _isLoading = false;
  List<QuestionModel> _questions = [];

  bool get isLoading => _isLoading;

  List<QuestionModel> get questions => _questions;




  Future<void> fetchQuestions(int examID) async {
    _isLoading = true;
    notifyListeners();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception("Token không tồn tại");
      }
      print(examID);
      final response = await http.get(
        Uri.parse("${apiUrl}/questions/test/$examID"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData =
        json.decode(utf8.decode(response.bodyBytes));
        _questions = jsonData.map((json) => QuestionModel.fromJson(json)).toList();
      } else {
        print('Lỗi: ${response.statusCode}');
        throw Exception('Lỗi');
      }
    } catch (e) {
      print('Lỗi khi lấy Câu hỏi: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateScore(
      int testId, double score, int status, String answerAttachments) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception("Token không tồn tại");
      }
      final Map<String, dynamic> data = {
        'testId': testId,
        'score': score,
        'status': status,
        'answerAttachments': answerAttachments,
      };
      final response = await http.post(
        Uri.parse("${apiUrl}/user-test/save"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Cập nhật điểm số thành công");
      } else {
        print("Cập nhật thất bại: ${response.statusCode}");
        print("Nội dung: ${response.body}");
        throw Exception("Lỗi từ server: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Lỗi khi cập nhật điểm số: $e");
    }
  }
}