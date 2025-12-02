import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/view_model/lesson_viewmodel.dart';
import 'package:english_learning_app/views/screens/student/lesson_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../localization/app_localizations.dart';

class LessonListTab extends StatefulWidget {
  final int courseID;

  LessonListTab(this.courseID);

  @override
  _LessonListTabState createState() => _LessonListTabState();
}

class _LessonListTabState extends State<LessonListTab> {
  // Data for lessons
  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  void _loadLessons() {
    Future.microtask(() => Provider.of<LessonViewModel>(context, listen: false)
        .fetchLessons(widget.courseID));
  }

  @override
  Widget build(BuildContext context) {
    final lessonViewModel = Provider.of<LessonViewModel>(context);
    final loc = AppLocalizations.of(context)!;

    return lessonViewModel.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
          child: lessonViewModel.lessons.isEmpty
              ? Center(child: Text('Không có bài học nào', style: TextStyle(color: AppColors.primaryDark),))
              :ListView.builder(
                  itemCount: lessonViewModel.lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = lessonViewModel.lessons[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LessonScreen(lessonViewModel.lessons[index]),
                          ),
                        ).then((_) {
                          // Khi quay lại màn hình, tải lại dữ liệu
                          _loadLessons();
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFF342771), width: 1.0),
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFF4F4F9),
                                Color(0xFF342771),
                              ],
                              stops: [0.96, 0],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading:
                                  Icon(Icons.school, color: AppColors.Pink),
                              // Study icon
                              title: Text(
                                '${lesson.lessonName}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('${loc.tr("level")}: ${lesson.level}'),
                              trailing: Lottie.asset(
                                'assets/animations/learn_icon.json',
                                // Đảm bảo bạn đã thêm file JSON của Lottie trong thư mục assets
                                height: 50,
                                width: 50,
                                repeat: true, // Lặp lại animation
                                reverse: true,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text('${lesson.progress}%'),
                            LinearProgressIndicator(
                              value: lesson.progress / 100,
                              minHeight: 4,
                              backgroundColor: Colors.grey[300],
                              color: Color(0xFF342771),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
  }
}
