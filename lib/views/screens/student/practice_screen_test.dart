import 'dart:async';
import 'dart:math';
import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../localization/app_localizations.dart';

class PracticeScreenTest extends StatefulWidget {
  @override
  _VocabPracticeScreenState createState() => _VocabPracticeScreenState();
}

class _VocabPracticeScreenState extends State<PracticeScreenTest> {
  final List<Map<String, String>> _vocabList = [
    {"word": "apple", "meaning": "quả táo"},
    {"word": "banana", "meaning": "quả chuối"},
    {"word": "cat", "meaning": "con mèo"},
    {"word": "dog", "meaning": "con chó"},
  ];

  List<Map<String, String>> _remainingWords = [];
  Map<String, String>? _currentWord;
  List<String> _currentMeanings = [];
  int _score = 0;
  int _currentQuestion = 1;
  int _totalQuestions = 0;
  Color _targetColor = Colors.lightBlueAccent;
  String _feedbackText = "";
  bool _isAnswerCorrect = false;

  late AppLocalizations loc;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loc = AppLocalizations.of(context)!;
      _resetQuiz();
    });
  }

  void _resetQuiz() {
    setState(() {
      _score = 0;
      _currentQuestion = 1;
      _remainingWords = List.from(_vocabList)..shuffle();
      _totalQuestions = _vocabList.length;
      _nextWord();
    });
  }

  void _nextWord() {
    if (_currentQuestion > _totalQuestions) {
      _showCompletionDialog();
      return;
    }

    setState(() {
      _currentWord = _remainingWords.removeAt(0);
      _currentMeanings = [_currentWord!['meaning']!, _getRandomMeaning()];
      _currentMeanings.shuffle();
      _targetColor = Colors.lightBlueAccent;
      _feedbackText = "";
    });
  }

  String _getRandomMeaning() {
    final wrongMeanings = _vocabList.where((vocab) => vocab['meaning'] != _currentWord!['meaning']).toList();
    return wrongMeanings[Random().nextInt(wrongMeanings.length)]['meaning']!;
  }

  void _onDragCompleted(String chosenMeaning) {
    setState(() {
      if (chosenMeaning == _currentWord!['meaning']) {
        _score++;
        _targetColor = Colors.green;
        _feedbackText = loc.tr("correct");
        _isAnswerCorrect = true;
      } else {
        _targetColor = Colors.red;
        _feedbackText = loc.tr("wrong");
        _isAnswerCorrect = false;
      }
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _currentQuestion++;
      });
      _nextWord();
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.tr("completed")),
        content: Text('${loc.tr("quiz_completed")}\n${loc.tr("score")}: $_score/$_totalQuestions'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetQuiz();
            },
            child: Text(loc.tr("retry")),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.tr("vocab_practice"), style: TextStyle(color: AppColors.background),),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(loc.tr("drag_to_match"), style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          Text('${loc.tr("question")} $_currentQuestion / $_totalQuestions', style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _currentMeanings.map((meaning) {
              return DragTarget<String>(
                builder: (context, candidateData, rejectedData) => Container(
                  padding: EdgeInsets.all(16),
                  width: 150,
                  height: 100,
                  color: meaning == _currentWord!['meaning'] && _feedbackText.isNotEmpty ? _targetColor : Colors.lightBlueAccent,
                  child: Center(
                    child: Text(
                      meaning == _currentWord!['meaning'] && _feedbackText.isNotEmpty
                          ? _feedbackText
                          : meaning,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                onWillAccept: (data) => true,
                onAccept: (data) => _onDragCompleted(meaning),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Draggable<String>(
            data: _currentWord!['meaning'],
            feedback: Container(
              padding: EdgeInsets.all(16),
              color: Colors.blue,
              child: Text(_currentWord!['word']!, style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            childWhenDragging: Container(
              padding: EdgeInsets.all(16),
              child: Text(_currentWord!['word']!, style: TextStyle(fontSize: 18, color: Colors.grey)),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.blue,
              child: Text(_currentWord!['word']!, style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
          SizedBox(height: 20),
          Text('${loc.tr("score")}: $_score', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
