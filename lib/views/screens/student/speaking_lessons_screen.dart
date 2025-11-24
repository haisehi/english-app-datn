import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:english_learning_app/constrants/app_constrants.dart';
import 'package:english_learning_app/models/speaking_lesson_status.dart';
import 'package:english_learning_app/services/auth_service.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text("Lessons")),
      body: FutureBuilder<List<SpeakingLessonStatus>>(
        future: fetchLessons(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final lesson = snapshot.data![index];
              return Card(
                child: ListTile(
                  title: Text(lesson.title),
                  subtitle: Text(lesson.description),
                  trailing: Icon(
                    lesson.joined ? Icons.check_circle : Icons.pending_outlined,
                    color: lesson.joined ? Colors.green : Colors.grey,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SpeakingSentenceScreen(
                          lessonId: lesson.lessonId,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
