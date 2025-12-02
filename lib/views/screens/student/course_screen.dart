import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/models/course_model.dart';
import 'package:english_learning_app/view_model/my_course_viewmodel.dart';
import 'package:english_learning_app/views/screens/student/course_detail_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../localization/app_localizations.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<MyCourseViewmodel>(context, listen: false).fetchMyCourses());
  }

  @override
  Widget build(BuildContext context) {
    final courseViewModel = Provider.of<MyCourseViewmodel>(context);
    final loc = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            loc.tr("my_courses"),
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
          backgroundColor: AppColors.primaryDark,
        ),
        body: courseViewModel.isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
          decoration: BoxDecoration(color: AppColors.background),
          child: courseViewModel.courses.isEmpty
              ? Center(
            child: Text(
              loc.tr("no_course"),
              style: TextStyle(color: AppColors.textPrimary),
            ),
          )
              : ListView.builder(
            itemCount: courseViewModel.courses.length,
            itemBuilder: (context, index) {
              final course = courseViewModel.courses[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Color(0xFF342771).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Card(
                  elevation: 5,
                  shadowColor: Color(0xFF4A4E69),
                  color: AppColors.primary,
                  margin: EdgeInsets.all(2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    title: Text(
                      course.courseName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          "${loc.tr("status")}: ${course.courseStatus}",
                          style: TextStyle(color: Colors.white.withOpacity(0.7)),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${loc.tr("max_student")}: ${course.maxQuantity}',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7)),
                        ),
                        SizedBox(height: 5),
                        LinearProgressIndicator(
                          value: 80 / 100,
                          minHeight: 4,
                          backgroundColor: AppColors.background,
                          color: AppColors.Orange,
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.background,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailScreen(
                            courseId: course.courseID,
                            courseName: course.courseName,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
