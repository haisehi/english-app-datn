import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:english_learning_app/constrants/app_constrants.dart';
import 'package:english_learning_app/models/speaking_topic.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text("Speaking Topics")),
      body: FutureBuilder<List<SpeakingTopic>>(
        future: fetchTopics(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final topic = snapshot.data![index];
              return Card(
                child: ListTile(
                  title: Text(topic.title),
                  subtitle: Text(topic.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SpeakingLessonsScreen(topicId: topic.id),
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
