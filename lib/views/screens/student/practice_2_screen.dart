
import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/models/vocabulary_model.dart';
import 'package:english_learning_app/view_model/practice_2_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';


class Practice2Screen extends StatelessWidget {
  final List<VocabularyModel> _vocabList;
  final int courseID;
  final int lessonID;
  final double old_process;


  Practice2Screen(
      this._vocabList, this.courseID, this.lessonID, this.old_process);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Practice2ViewModel(_vocabList, courseID, lessonID, old_process),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bài luyện tập số 2', style: TextStyle(color: AppColors.textSecondary.withOpacity(0.8)),),
          backgroundColor: AppColors.primaryDark,
          iconTheme: IconThemeData(color: AppColors.textSecondary),
        ),
        backgroundColor: AppColors.background,
        body: Consumer<Practice2ViewModel>(
          builder: (context, viewModel, child) {
            double progress = (viewModel.currentQuestionIndex + 1) / viewModel.quizQuestions.length;
            final question = viewModel.quizQuestions[viewModel.currentQuestionIndex];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: AppColors.Pink,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Câu ${viewModel.currentQuestionIndex + 1}/${viewModel.quizQuestions.length}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Lottie.asset(
                      'assets/animations/logo_animation.json', // Đảm bảo bạn đã thêm file JSON của Lottie trong thư mục assets
                      height: 200,
                      width: 200,
                      repeat: true, // Lặp lại animation
                      reverse: true,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Nghĩa của từ:',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(
                            color: AppColors.Orange,
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          child: Text(
                                            "${question['question']}",
                                            style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark),

                                          ),
                        )),
                    SizedBox(height: 20),
                    ...question['options'].map<Widget>((option) {
                      bool isSelected = viewModel.selectedAnswer == option;
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 6.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (viewModel.isAnswerCorrect! ? Colors.green : Colors.red)
                              : Colors.white,
                            border: Border.all(
                              color: AppColors.primaryDark, // Màu của viền
                              width: 2,           // Độ dày của viền
                            ),
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: () => viewModel.checkAnswer(option, context),
                          child: Text(
                            option,
                            style: TextStyle(fontSize: 20, color: AppColors.primaryDark),
                          ),
                        ),
                      );
                    }).toList(),
                    if (viewModel.isAnswerCorrect != null)
                      Text(
                        viewModel.isAnswerCorrect! ? 'Đúng!' : 'Sai!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: viewModel.isAnswerCorrect! ? Colors.green : Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
