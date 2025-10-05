import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/models/exam_model.dart';
import 'package:english_learning_app/models/lesson_model.dart';
import 'package:english_learning_app/view_model/lesson_viewmodel.dart';
import 'package:english_learning_app/views/screens/student/exam_screen.dart';
import 'package:english_learning_app/views/screens/student/lesson_screen.dart';
import 'package:english_learning_app/views/widget/tab/exam_list_tab.dart';
import 'package:english_learning_app/views/widget/tab/lesson_list_tab.dart';
import 'package:english_learning_app/views/widget/tab/statistics_score_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class CourseDetailScreen extends StatefulWidget {
  final int courseId;
  final String courseName;

  CourseDetailScreen({required this.courseId, required this.courseName});

  @override
  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetailScreen> with SingleTickerProviderStateMixin {
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


    return Scaffold(
      appBar: AppBar(

        title: Text(widget.courseName, style: TextStyle(color: Colors.white.withOpacity(0.8)),),
        iconTheme: IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white, // Màu chữ cho tab được chọn
          unselectedLabelColor: Colors.grey, // Màu chữ cho tab không được chọn
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ), // Kiểu chữ cho tab được chọn
          unselectedLabelStyle: TextStyle(
            fontSize: 16,
          ), // Kiểu chữ cho tab không được chọn
          indicatorColor: Colors.white, // Màu của thanh chỉ báo tab
          tabs: [
            Tab(text: 'Bài học'),
            Tab(text: 'Bài thi'),
            Tab(text: 'Thống kê'),
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


