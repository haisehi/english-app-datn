import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/models/vocabulary_model.dart';
import 'package:english_learning_app/view_model/practice_3_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../localization/app_localizations.dart';


class Practice3Screen extends StatelessWidget {
  final List<VocabularyModel> _vocabList;
  final int courseID;
  final int lessonID;
  final double old_process;


  Practice3Screen(
      this._vocabList, this.courseID, this.lessonID, this.old_process);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ChangeNotifierProvider(
      create: (context) => Practice3ViewModel(_vocabList, courseID, lessonID, old_process),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${loc.tr("exercises")} 3', style: TextStyle(color: AppColors.textSecondary.withOpacity(0.8)),),
          backgroundColor: AppColors.primaryDark,
          iconTheme: IconThemeData(color: AppColors.textSecondary),
        ),
        body: SingleChildScrollView(
          child: Consumer<Practice3ViewModel>(
            builder: (context, viewModel, child) {
              // Kiểm tra nếu hết câu hỏi thì hiển thị kết quả
              if (viewModel.currentQuestionIndex >= viewModel.shuffledVocabularyList.length) {
                viewModel.showResult(context);
              }
              final currentWord = viewModel.currentQuestion.word;
              final currentMeaning = viewModel.currentQuestion.meaning;
              final shuffledLetters = viewModel.shuffledLetters;
              double progress = (viewModel.currentQuestionIndex + 1) / viewModel.vocabList.length;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
          
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${loc.tr("sentence")} ${viewModel.currentQuestionIndex + 1}/${viewModel.vocabList.length}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Lottie.asset(
                      'assets/animations/logo_animation.json', // Đảm bảo bạn đã thêm file JSON của Lottie trong thư mục assets
                      height: 200,
                      width: 200,
                      repeat: true, // Lặp lại animation
                      reverse: true,
                    ),
                    Text("${loc.tr("meaning_of_the_word")}: ", style: TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.Orange
                      ),
                      child: Text(
                        '$currentMeaning',
                        style: TextStyle(fontSize: 24, color: AppColors.textSecondary),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: List.generate(currentWord.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              if (index < viewModel.selectedLetters.length) {
                                viewModel.selectedLetters.removeAt(index);
                                viewModel.notifyListeners();
                              }
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primary, width: 1),
                                borderRadius: BorderRadius.circular(4),
                                color: index < viewModel.selectedLetters.length
                                    ? Colors.blue[100]
                                    : Colors.transparent,
                              ),
                              child: Text(
                                index < viewModel.selectedLetters.length
                                    ? viewModel.selectedLetters[index]
                                    : '',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.Orange, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: shuffledLetters.map((letter) {
                          return ElevatedButton(
                            onPressed: () {
                              viewModel.selectLetter(letter);
                            },
                            child: Text(
                              letter,
                              style: TextStyle(fontSize: 24, color: AppColors.primaryDark),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
          
                    SizedBox(height: 20),
                    if (viewModel.showImmediateResult)
                      Text(
                        viewModel.isAnswerCorrect ? 'Đúng!' : 'Sai!',
                        style: TextStyle(
                          fontSize: 24,
                          color: viewModel.isAnswerCorrect ? Colors.green : Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.primary
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          viewModel.checkAnswer(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text('${loc.tr("completed_percentage")}', style: TextStyle(color: AppColors.background, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
