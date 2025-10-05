// practice_view_model.dart
import 'dart:math';
import 'package:english_learning_app/models/vocabulary_model.dart';
import 'package:english_learning_app/view_model/lesson_viewmodel.dart';
import 'package:english_learning_app/views/widget/dialog/show_result_practice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class Practice2ViewModel extends ChangeNotifier {
  final List<VocabularyModel> _vocabList;
  final LessonViewModel lessonViewModel = LessonViewModel();
  final int courseID;
  final int lessionID;
  final double oldProgress;

  List<Map<String, dynamic>> quizQuestions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool? isAnswerCorrect;
  String? selectedAnswer;


  Practice2ViewModel(
      this._vocabList, this.courseID, this.lessionID, this.oldProgress){
   resetQuiz();
  }

  void generateQuizQuestions() {
    _vocabList.shuffle();
    quizQuestions = _vocabList.map((vocab) {
      List<VocabularyModel> options = List.from(_vocabList);
      options.remove(vocab);
      options.shuffle();
      options = options.take(3).toList();
      options.add(vocab);
      options.shuffle();

      return {
        'question': vocab.word,
        'correctAnswer': vocab.meaning,
        'options': options.map((opt) => opt.meaning).toList(),
      };
    }).toList();
    notifyListeners();
  }

  void checkAnswer(String answer, BuildContext context) {
    selectedAnswer = answer;
    isAnswerCorrect =
        answer == quizQuestions[currentQuestionIndex]['correctAnswer'];
    if (isAnswerCorrect!) score++;
    notifyListeners();

    Future.delayed(Duration(seconds: 1), () {
      if (currentQuestionIndex < quizQuestions.length - 1) {
        currentQuestionIndex++;
        selectedAnswer = null;
        isAnswerCorrect = null;
      } else {
        showResult(context);
      }
      notifyListeners();
    });
  }

  void showResult(BuildContext context) {
    double completionRate = (score / quizQuestions.length) * 100;
    bool isCompleted = completionRate >= 80;
    // Hiển thị dialog kết quả
    double completionProgress = min(completionRate, 25);
    double newProgress = oldProgress + completionProgress;
    if(newProgress > 100){
      newProgress = 100;
    }
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
    score = 0;
    currentQuestionIndex = 0;
    isAnswerCorrect = null;
    selectedAnswer = null;
    generateQuizQuestions();
    notifyListeners();
  }
}
