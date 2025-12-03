import 'dart:ui';
import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/view_model/my_course_viewmodel.dart';
import 'package:english_learning_app/views/screens/student/course_detail_screen.dart';
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
    final courseVM = Provider.of<MyCourseViewmodel>(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          loc.tr("my_courses"),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2475FC), Color(0xFF002275)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: courseVM.isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : courseVM.courses.isEmpty
            ? Center(
          child: Text(
            loc.tr("no_course"),
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
        )
            : ListView.separated(
          padding: const EdgeInsets.only(top: 100, bottom: 20),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: courseVM.courses.length,
          itemBuilder: (context, index) {
            final course = courseVM.courses[index];

            return _CourseCard(
              title: course.courseName,
              status: course.courseStatus,
              maxQuantity: course.maxQuantity,
              progress: (course.maxQuantity > 0) ? (0.7) : 0,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CourseDetailScreen(
                      courseId: course.courseID,
                      courseName: course.courseName,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final String title;
  final String status;
  final int maxQuantity;
  final double progress;
  final VoidCallback onTap;

  const _CourseCard({
    required this.title,
    required this.status,
    required this.maxQuantity,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.menu_book_rounded, color: Colors.white),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Status: $status",
                              style: TextStyle(color: Colors.white.withOpacity(0.8)),
                            ),
                            Text(
                              "Max: $maxQuantity",
                              style: TextStyle(color: Colors.white.withOpacity(0.8)),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 6,
                                backgroundColor: Colors.white.withOpacity(0.25),
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFC857)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
