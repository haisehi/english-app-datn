import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/views/widget/tab/exam_list_tab.dart';
import 'package:english_learning_app/views/widget/tab/lesson_list_tab.dart';
import 'package:english_learning_app/views/widget/tab/statistics_score_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../localization/app_localizations.dart';

class CourseDetailScreen extends StatefulWidget {
  final int courseId;
  final String courseName;

  CourseDetailScreen({required this.courseId, required this.courseName});

  @override
  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.courseName,
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(fontSize: 16),
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: loc.tr("lessons")), // Bài học
            Tab(text: loc.tr("exams")), // Bài thi
            Tab(text: loc.tr("statistics")), // Thống kê
          ],
        ),
        backgroundColor: AppColors.primaryDark,
      ),
      backgroundColor: AppColors.background,
      body: TabBarView(
        controller: _tabController,
        children: [
          LessonListTab(widget.courseId),
          ExamListTab(widget.courseId),
          StatisticsScoreTab(widget.courseId),
        ],
      ),
    );
  }
}
