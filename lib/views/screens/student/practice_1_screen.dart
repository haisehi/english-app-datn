import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/models/vocabulary_model.dart';
import 'package:english_learning_app/view_model/practice_1_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../localization/app_localizations.dart';


class Practice1Screen extends StatelessWidget {
  final List<VocabularyModel> _vocabList;
  final int courseID;
  final int lessonID;
  final double old_process;


  Practice1Screen(
      this._vocabList, this.courseID, this.lessonID, this.old_process);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ChangeNotifierProvider(
      create: (_) => Practice1Viewmodel(_vocabList, courseID, lessonID, old_process),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${loc.tr("exercises")} 1', style: TextStyle(color: AppColors.textSecondary.withOpacity(0.8)),),
          backgroundColor: AppColors.primaryDark,
          iconTheme: IconThemeData(color: AppColors.textSecondary),
          centerTitle: true,
        ),
        backgroundColor: AppColors.background,
        body: Consumer<Practice1Viewmodel>(
          builder: (context, viewModel, child) {
            double progress = (viewModel.currentQuestion) / viewModel.totalQuestions;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    color: AppColors.Pink,
                  ),
                  SizedBox(height: 10),
                  Text("${loc.tr("sentence")} ${viewModel.currentQuestion} / ${viewModel.totalQuestions}", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Lottie.asset(
                    'assets/animations/logo_animation.json', // Đảm bảo bạn đã thêm file JSON của Lottie trong thư mục assets
                    height: 200,
                    width: 200,
                    repeat: true, // Lặp lại animation
                    reverse: true,
                  ),
                  SizedBox(height:10),

                  Text("${loc.tr("drag")}", style: TextStyle(fontSize: 20, color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: viewModel.currentMeanings.map((meaning) {
                      return DragTarget<String>(
                        builder: (context, candidateData, rejectedData) => Container(
                          padding: EdgeInsets.all(16),
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 100,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: meaning == viewModel.currentWord!.meaning && viewModel.feedbackText.isNotEmpty
                                ? viewModel.targetColor
                                : AppColors.primary,
                          ),
                          child: Center(
                            child: Text(
                              meaning == viewModel.currentWord!.meaning && viewModel.feedbackText.isNotEmpty
                                  ? viewModel.feedbackText
                                  : meaning,
                              style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        onWillAccept: (data) => true,
                        onAccept: (data) => viewModel.onDragCompleted(meaning, context),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Draggable<String>(
                    data: viewModel.currentWord!.meaning,
                    feedback: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.Orange,
                      ),
                      child: Text(viewModel.currentWord!.word, style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    childWhenDragging: Container(
                      padding: EdgeInsets.all(16),
                      child: Text(viewModel.currentWord!.word, style: TextStyle(fontSize: 18, color: AppColors.primaryDark.withOpacity(0.6))),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.Orange,
                      ),

                      child: Text(viewModel.currentWord!.word, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),


                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
