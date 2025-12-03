import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:english_learning_app/constrants/app_constrants.dart';
import 'package:english_learning_app/models/speaking_topic.dart';
import '../../../localization/app_localizations.dart';
import 'speaking_lessons_screen.dart';

class SpeakingTopicScreen extends StatefulWidget {
  const SpeakingTopicScreen({super.key});

  @override
  State<SpeakingTopicScreen> createState() => _SpeakingTopicScreenState();
}

class _SpeakingTopicScreenState extends State<SpeakingTopicScreen> {
  Future<List<SpeakingTopic>> fetchTopics() async {
    final res = await http.get(Uri.parse("$apiUrl/topics"));

    if (res.statusCode == 200) {
      List data = jsonDecode(res.body);
      return data.map((e) => SpeakingTopic.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load topics");
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        title: Text(
          loc.tr("speaking_topic"),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<List<SpeakingTopic>>(
        future: fetchTopics(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
                    strokeWidth: 3, color: Colors.blueAccent));
          }

          final topics = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SpeakingLessonsScreen(topicId: topic.id),
                  ),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.blueAccent.withOpacity(0.07),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.mic, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topic.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              topic.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.blueAccent,
                      ),
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
