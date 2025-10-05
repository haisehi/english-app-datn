import 'dart:math';
import 'package:english_learning_app/models/vocabulary_model.dart';
import 'package:english_learning_app/view_model/lesson_viewmodel.dart';
import 'package:english_learning_app/views/widget/dialog/show_result_practice_dialog.dart';
import 'package:flutter/material.dart';


class Practice3ViewModel extends ChangeNotifier {
  final List<VocabularyModel> _vocabList;
  final LessonViewModel lessonViewModel = LessonViewModel();
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

  // Hàm hiển thị kết quả
  void showResult(BuildContext context) {
    double completionRate = (score / shuffledVocabularyList.length) * 100;
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
}
