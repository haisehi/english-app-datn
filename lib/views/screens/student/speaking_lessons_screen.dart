import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/constrants/app_constrants.dart';
import 'package:english_learning_app/models/speaking_lesson_status.dart';
import 'package:english_learning_app/services/auth_service.dart';
import '../../../localization/app_localizations.dart';
import 'speaking_sentence_screen.dart';

class SpeakingLessonsScreen extends StatefulWidget {
  final int topicId;
  const SpeakingLessonsScreen({super.key, required this.topicId});

  @override
  State<SpeakingLessonsScreen> createState() => _SpeakingLessonsScreenState();
}

class _SpeakingLessonsScreenState extends State<SpeakingLessonsScreen> {
  final AuthService _authService = AuthService();

  Future<List<SpeakingLessonStatus>> fetchLessons() async {
    final token = await _authService.getAccessToken();
    if (token == null) throw Exception("Token không tồn tại");

    final res = await http.get(
      Uri.parse("$apiUrl/SpeakingLessons/TopicId/${widget.topicId}/me"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (res.statusCode == 200) {
      List data = jsonDecode(res.body);
      return data.map((e) => SpeakingLessonStatus.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load lessons");
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          loc.tr("lesson_speaking"),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 3,
        shadowColor: AppColors.primaryDark.withOpacity(0.4),
      ),
      body: FutureBuilder<List<SpeakingLessonStatus>>(
        future: fetchLessons(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final lessons = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          SpeakingSentenceScreen(lessonId: lesson.lessonId),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: lesson.joined
                          ? AppColors.primary
                          : AppColors.border,
                      width: lesson.joined ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.mic,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lesson.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              lesson.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        lesson.joined
                            ? Icons.check_circle_rounded
                            : Icons.play_circle_fill_rounded,
                        color: lesson.joined
                            ? Colors.green
                            : AppColors.primary,
                        size: 30,
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
