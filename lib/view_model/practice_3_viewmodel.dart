import 'dart:math';
import 'package:english_learning_app/models/vocabulary_model.dart';
import 'package:english_learning_app/view_model/lesson_viewmodel.dart';
import 'package:english_learning_app/views/widget/dialog/show_result_practice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/attendance_service.dart';
import '../views/screens/student/attendance_screen.dart';


class Practice3ViewModel extends ChangeNotifier {
  final List<VocabularyModel> _vocabList;
  final LessonViewModel lessonViewModel = LessonViewModel();
  final AttendanceService attendanceService = AttendanceService();
  final int courseID;
  final int lessionID;
  final double oldProgress;


  List<VocabularyModel> get vocabList => _vocabList;
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  int score = 0;
  List<String> selectedLetters = [];
  bool showImmediateResult = false;
  bool isAnswerCorrect = false;
  List<VocabularyModel> shuffledVocabularyList = [];



  Practice3ViewModel(
      this._vocabList, this.courseID, this.lessionID, this.oldProgress){
    _shuffleQuestions();
  }



  // Hàm xáo trộn câu hỏi
  void _shuffleQuestions() {
    shuffledVocabularyList = List.from(_vocabList);
    shuffledVocabularyList.shuffle(Random());
    notifyListeners(); // Thông báo cập nhật dữ liệu
  }

  // Hàm lấy câu hỏi hiện tại
  VocabularyModel get currentQuestion =>
      shuffledVocabularyList[currentQuestionIndex];

  // Hàm lấy các chữ cái xáo trộn
  List<String> get shuffledLetters {
    List<String> letters = currentQuestion.word.split('');
    letters.shuffle(Random());
    return letters;
  }

  // Hàm xử lý khi người dùng chọn câu trả lời
  void selectLetter(String letter) {
    selectedLetters.add(letter);
    notifyListeners();
  }

  // Hàm xử lý khi người dùng xác nhận câu trả lời
  void checkAnswer(BuildContext context) {
    isAnswerCorrect = selectedLetters.join() == currentQuestion.word;
    if (isAnswerCorrect) {
      correctAnswers++;
      score++;
    }
    showImmediateResult = true;
    notifyListeners();

    Future.delayed(Duration(seconds: 1), () {
      if (currentQuestionIndex < shuffledVocabularyList.length - 1) {
        currentQuestionIndex++;
        selectedLetters.clear();
        showImmediateResult = false;
        notifyListeners();
      } else {
        // Khi hết câu hỏi, hiển thị kết quả
        showResult(context);
      }
    });
  }

  // Hàm xử lý khi chơi lại
  void resetQuiz() {
    currentQuestionIndex = 0;
    correctAnswers = 0;
    score = 0;
    selectedLetters.clear();
    _shuffleQuestions();
    notifyListeners();
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
}
