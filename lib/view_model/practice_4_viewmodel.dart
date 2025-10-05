import 'dart:async';
import 'dart:math';
import 'package:english_learning_app/view_model/lesson_viewmodel.dart';
import 'package:english_learning_app/views/widget/dialog/show_result_practice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:english_learning_app/models/vocabulary_model.dart';

class Practice4ViewModel extends ChangeNotifier {
  final List<VocabularyModel> _vocabList;
  final LessonViewModel lessonViewModel = LessonViewModel();
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
      _showResult(context);
    }
  }

  // Hàm hiển thị kết quả
  void _showResult(BuildContext context) {
    double completionRate = (score / _vocabList.length) * 100;
    bool isCompleted = completionRate >= 80;
    // Hiển thị dialog kết quả
    double completionProgress = min(completionRate, 25);


    double newProgress = oldProgress + completionProgress;
    if(newProgress > 100){
      newProgress = 100;
    }

    // Hiển thị kết quả
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
          await lessonViewModel.updateProcess(courseID, lessionID, newProgress);

          Navigator.of(context).pop(); // Đóng dialog
          Navigator.of(context).pop(); // Đóng PracticeScreen2
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
