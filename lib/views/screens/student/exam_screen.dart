import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/models/exam_model.dart';
import 'package:english_learning_app/models/question_model.dart';
import 'package:english_learning_app/view_model/exam_detail_viewmodel.dart';
import 'package:english_learning_app/view_model/exam_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../localization/app_localizations.dart';

class ExamScreen extends StatefulWidget {
  final ExamModel exam;
  final List<QuestionModel> questions;

  ExamScreen(this.exam, this.questions);

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late ExamViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ExamViewModel(widget.exam, widget.questions);
    viewModel.startCountdown(() {
      _onTimeUp();
    });
  }

  void _onTimeUp() {
    viewModel.calculateScore();
    _showResultDialog();
  }

  void _submitExam() async {
    final loc = AppLocalizations.of(context)!;
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.tr("confirm_submit_exam")),
        content: Text(loc.tr("are_you_sure_submit")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.tr("cancel")),
          ),
          ElevatedButton(
            onPressed: () async {
              viewModel.calculateScore();
              ExamDetailViewmodel examDetailViewmodel = ExamDetailViewmodel();
              await examDetailViewmodel.updateScore(widget.exam.examID, viewModel.totalScore, 0, '');
              Navigator.pop(context, true);
            },
            child: Text(loc.tr("submit_exam")),
          ),
        ],
      ),
    );

    if (confirm) {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.tr("exam_result")),
        content: Text('${loc.tr("completed_exam")}\n${loc.tr("total_score")}: ${viewModel.totalScore}'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exam.examName, style: TextStyle(color: AppColors.background)),
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: AppColors.background),
        actions: [
          StreamBuilder<int>(
            stream: viewModel.countdownController.stream,
            builder: (context, snapshot) {
              final time = snapshot.data ?? viewModel.countdownTime;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Text(viewModel.formatTime(time), style: TextStyle(color: AppColors.background)),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.getDisplayedQuestions().length,
                itemBuilder: (context, index) {
                  final question = viewModel.getDisplayedQuestions()[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. ${question.content}',
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          ...question.answerOptions.map(
                                (answer) => RadioListTile<int>(
                              title: Text(answer.answerContent),
                              value: answer.answerID,
                              groupValue: viewModel.selectedAnswers[question.questionID],
                              onChanged: (value) {
                                setState(() {
                                  viewModel.selectedAnswers[question.questionID] = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (viewModel.currentPage > 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        viewModel.previousPage();
                      });
                    },
                    child: Text(loc.tr("previous")),
                  ),
                if (!viewModel.isLastPage())
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        viewModel.nextPage();
                      });
                    },
                    child: Text(loc.tr("next")),
                  ),
                if (viewModel.isLastPage())
                  ElevatedButton(
                    onPressed: _submitExam,
                    child: Text(loc.tr("submit_exam")),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
