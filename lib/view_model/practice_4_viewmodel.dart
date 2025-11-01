import 'dart:async';
import 'dart:math';
import 'package:english_learning_app/view_model/lesson_viewmodel.dart';
import 'package:english_learning_app/views/widget/dialog/show_result_practice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:english_learning_app/models/vocabulary_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/attendance_service.dart';
import '../views/screens/student/attendance_screen.dart';

class Practice4ViewModel extends ChangeNotifier {
  final List<VocabularyModel> _vocabList;
  final LessonViewModel lessonViewModel = LessonViewModel();
  final AttendanceService attendanceService = AttendanceService();
  final int courseID;
  final int lessionID;
  final double oldProgress;

  int _currentIndex = 0;
  int _score = 0;
  String _feedbackText = "";

  int get score => _score;
  int get totalQuestions => _vocabList.length;
  VocabularyModel get currentWord => _vocabList[_currentIndex];
  String get feedbackText => _feedbackText;
  int get currentIndex => _currentIndex;


  Practice4ViewModel(
      this._vocabList, this.courseID, this.lessionID, this.oldProgress){
   resetQuiz();
  }

  void checkAnswer(String userAnswer, BuildContext context) {
    if (userAnswer.trim().toLowerCase() == currentWord.word.toLowerCase()) {
      _score++;
      _feedbackText = "Chính xác!";
    } else {
      _feedbackText = "Sai rồi! Đáp án là '${currentWord.word}'.";
    }
    notifyListeners();
    Future.delayed(Duration(seconds: 1), () {
      _nextQuestion(context);
    });
  }

  void _nextQuestion(BuildContext context) {
    if (_currentIndex < _vocabList.length - 1) {
      _currentIndex++;
      _feedbackText = "";
      notifyListeners();
    } else {
      showResult(context);
    }
  }

  // ✅ Hiển thị kết quả + chuyển sang trang điểm danh
  void showResult(BuildContext context) async {
    double completionRate = (score / _vocabList.length) * 100;
    bool isCompleted = completionRate >= 80;
    double completionProgress = min(completionRate, 25);
    double newProgress = oldProgress + completionProgress;
    if (newProgress > 100) newProgress = 100;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ShowResultPracticeDialog(
        completionRate: completionRate,
        isCompleted: isCompleted,
        onReplay: () {
          Navigator.of(context).pop();
          resetQuiz();
        },
        onComplete: () async {
          // Cập nhật tiến độ học
          await lessonViewModel.updateProcess(courseID, lessionID, newProgress);

          // Lấy userId
          final prefs = await SharedPreferences.getInstance();
          final userId = prefs.getInt("id_user") ?? 1;

          // Đóng dialog
          Navigator.of(context).pop();

          // ✅ Chuyển sang màn hình AttendanceScreen để điểm danh
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => AttendanceScreen(userId: userId),
            ),
          );
        },
      ),
    );
  }

  void resetQuiz() {
    _currentIndex = 0;
    _score = 0;
    _feedbackText = "";
    notifyListeners();
  }
}
