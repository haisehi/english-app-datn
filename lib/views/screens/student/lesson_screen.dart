import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/models/lesson_model.dart';
import 'package:english_learning_app/models/vocabulary_model.dart';
import 'package:english_learning_app/view_model/lesson_viewmodel.dart';
import 'package:english_learning_app/view_model/vocabulary_viewmodel.dart';
import 'package:english_learning_app/views/widget/dialog/show_practice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../localization/app_localizations.dart';

class LessonScreen extends StatefulWidget {
  final LessonModel lesson;

  LessonScreen(this.lesson);

  @override
  _LessonDetailScreenState createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonScreen> {
// Các biến lưu dữ liệu của bài học
  late LessonModel lesson = widget.lesson;


  @override
  void initState()  {
    super.initState();
    Future.microtask(() =>
        Provider.of<VocabularyViewmodel>(context, listen: false)
            .fetchVocabs(lesson.lessonID));
  }

  // Danh sách từ vựng và nghĩa của chúng
  // final List<VocabularyModel> vocabList = VocabularyModel.vocabList;

  @override
  Widget build(BuildContext context) {
    final vocabularyViewModel = Provider.of<VocabularyViewmodel>(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.tr("lesson_detail"),
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryDark,

      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Lottie.asset(
                'assets/animations/lesson.json',
                // Đảm bảo bạn đã thêm file JSON của Lottie trong thư mục assets
                height: 150,
                width: 150,
                repeat: true, // Lặp lại animation
                reverse: true,
              ),
            ),
            Text(
              lesson.lessonName,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary),
            ),
            SizedBox(height: 16),
            Text(
              lesson.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            // Hình ảnh của bài học
            SizedBox(height: 16),
            // Danh sách từ vựng và nghĩa
            Text(
              loc.tr("vocabulary"),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: vocabularyViewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      color: AppColors.background,
                      child: ListView.builder(
                        itemCount: vocabularyViewModel.vocabs.length,
                        itemBuilder: (context, index) {
                          final vocab = vocabularyViewModel.vocabs[index];
                          return Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.stars_outlined,
                                  color: AppColors.Pink,
                                ),
                                title: Text(
                                  vocab.word ?? "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryDark),
                                ),
                                subtitle: Text(vocab.meaning ?? ""),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                width: double.infinity,
                                // Set width of the divider to a specific value (shorter line)
                                height: 1,
                                color: Colors.grey.shade500, // Divider color
                              ),
                            ],
                          );
                        },
                      ),
                    ),
            ),
            SizedBox(height: 16),
            // Nút luyện tập
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async  {
                  double progress = await Provider.of<LessonViewModel>(context, listen: false).fetchGetProgressByLesson(lesson.courseID, lesson.lessonID);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PracticeDialog(
                        progress,
                        vocabularyViewModel.vocabs,
                        lesson.courseID,
                        lesson.lessonID,
                      );
                    },
                  );
                },
                child: Text(
                  loc.tr("start"),
                  style: TextStyle(color: AppColors.background, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
