import 'dart:async';
import 'dart:math';
import 'package:english_learning_app/models/lesson_model.dart';
import 'package:english_learning_app/models/vocabulary_model.dart';
import 'package:english_learning_app/view_model/lesson_viewmodel.dart';
import 'package:english_learning_app/views/widget/dialog/show_practice_dialog.dart';
import 'package:english_learning_app/views/widget/dialog/show_result_practice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_learning_app/services/attendance_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_learning_app/views/screens/student/attendance_screen.dart';

import '../views/screens/student/attendance_screen.dart'; // ✅ import màn hình điểm danh

class Practice1Viewmodel extends ChangeNotifier {
  final List<VocabularyModel> _vocabList;
  final LessonViewModel lessonViewModel = LessonViewModel();
  final AttendanceService attendanceService = AttendanceService();

  final int courseID;
  final int lessionID;
  final double oldProgress;

  List<VocabularyModel> _remainingWords = [];
  VocabularyModel? _currentWord;
  List<String> _currentMeanings = [];
  int _score = 0;
  int _currentQuestion = 1;
  int _totalQuestions = 0;
  Color _targetColor = Colors.lightBlueAccent;
  String _feedbackText = "";

  Practice1Viewmodel(
      this._vocabList, this.courseID, this.lessionID, this.oldProgress) {
    _resetQuiz();
  }

  // Getters
  int get score => _score;
  int get currentQuestion => _currentQuestion;
  int get totalQuestions => _totalQuestions;
  Color get targetColor => _targetColor;
  String get feedbackText => _feedbackText;
  VocabularyModel? get currentWord => _currentWord;
  List<String> get currentMeanings => _currentMeanings;

  // Khởi động lại quiz
  void _resetQuiz() {
    _score = 0;
    _currentQuestion = 1;
    _remainingWords = List.from(_vocabList)..shuffle();
    _totalQuestions = _vocabList.length;
    _nextWord();
  }

  // Lấy từ tiếp theo
  void _nextWord() {
    if (_currentQuestion > _totalQuestions) return;
    _currentWord = _remainingWords.removeAt(0);
    _currentMeanings = [_currentWord!.meaning, _getRandomMeaning()];
    _currentMeanings.shuffle();
    _targetColor = Colors.lightBlueAccent;
    _feedbackText = "";
    notifyListeners();
  }

  // Nghĩa sai ngẫu nhiên
  String _getRandomMeaning() {
    final wrongMeanings = _vocabList
        .where((vocab) => vocab.meaning != _currentWord!.meaning)
        .toList();
    return wrongMeanings[Random().nextInt(wrongMeanings.length)].meaning;
  }

  // Kiểm tra đáp án
  void onDragCompleted(String chosenMeaning, BuildContext context) {
    if (chosenMeaning == _currentWord!.meaning) {
      _score++;
      _targetColor = Colors.green;
      _feedbackText = "Chính xác!";
    } else {
      _targetColor = Colors.red;
      _feedbackText = "Sai rồi!";
    }
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      _currentQuestion++;
      if (_currentQuestion > _totalQuestions) {
        showResult(context);
      } else {
        _nextWord();
      }
    });
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
          _resetQuiz();
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
    _resetQuiz();
    notifyListeners();
  }
}
