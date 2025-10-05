import 'dart:async';
import 'dart:math';
import 'package:english_learning_app/models/lesson_model.dart';
import 'package:english_learning_app/models/vocabulary_model.dart';
import 'package:english_learning_app/view_model/lesson_viewmodel.dart';
import 'package:english_learning_app/views/widget/dialog/show_practice_dialog.dart';
import 'package:english_learning_app/views/widget/dialog/show_result_practice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Practice1Viewmodel extends ChangeNotifier {
  final List<VocabularyModel> _vocabList;
  final LessonViewModel lessonViewModel = LessonViewModel();
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
      this._vocabList, this.courseID, this.lessionID, this.oldProgress){
    _resetQuiz();
  }


  // Các getter để truy cập từ View
  int get score => _score;

  int get currentQuestion => _currentQuestion;

  int get totalQuestions => _totalQuestions;

  Color get targetColor => _targetColor;

  String get feedbackText => _feedbackText;

  VocabularyModel? get currentWord => _currentWord;

  List<String> get currentMeanings => _currentMeanings;

  // Khởi động lại bài luyện tập
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

  // Chọn một nghĩa ngẫu nhiên để làm đáp án sai
  String _getRandomMeaning() {
    final wrongMeanings = _vocabList
        .where((vocab) => vocab.meaning != _currentWord!.meaning)
        .toList();
    return wrongMeanings[Random().nextInt(wrongMeanings.length)].meaning;
  }

  // Kiểm tra đáp án khi người dùng kéo từ vào mục tiêu
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

    // Đợi một giây trước khi chuyển sang từ mới
    Future.delayed(Duration(seconds: 1), () {
      _currentQuestion++;
      if (_currentQuestion > _totalQuestions) {
        // Khi hết câu hỏi, hiển thị kết quả
        showResult(context);
      } else {
        _nextWord();
      }
    });
  }

  // Hàm hiển thị kết quả
  void showResult(BuildContext context) {
    double completionRate = (score / _vocabList.length) * 100;
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
          _resetQuiz(); // Khởi động lại bài luyện tập
        },
        onComplete: () async {
          await lessonViewModel.updateProcess(courseID, lessionID, newProgress);
          Navigator.of(context).pop(); // Đóng PracticeScreen
          Navigator.of(context).pop(); // Đóng PracticeScreen


        },
      ),
    );
  }

  // Hàm khởi động lại bài luyện tập khi người dùng chọn "Chơi lại"
  void resetQuiz() {
    _resetQuiz();
    notifyListeners();
  }
}
