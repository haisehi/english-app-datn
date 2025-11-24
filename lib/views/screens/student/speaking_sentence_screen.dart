import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:english_learning_app/constrants/app_constrants.dart';
import 'package:english_learning_app/models/speaking_sentence.dart';
import 'package:english_learning_app/services/auth_service.dart';

class SpeakingSentenceScreen extends StatefulWidget {
  final int lessonId;
  const SpeakingSentenceScreen({super.key, required this.lessonId});

  @override
  State<SpeakingSentenceScreen> createState() => _SpeakingSentenceScreenState();
}

class _SpeakingSentenceScreenState extends State<SpeakingSentenceScreen> {
  late stt.SpeechToText speech;
  List<SpeakingSentence> sentences = [];
  int currentIndex = 0;
  String recognizedText = "";
  bool isListening = false;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
    fetchSentences();
  }

  Future<void> fetchSentences() async {
    final token = await _authService.getAccessToken();
    if (token == null) throw Exception("Token không tồn tại");

    final res = await http.get(
      Uri.parse("$apiUrl/sentences/by-lesson/${widget.lessonId}"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (res.statusCode == 200) {
      List data = jsonDecode(res.body);
      setState(() {
        sentences = data.map((e) => SpeakingSentence.fromJson(e)).toList();
      });
    } else {
      throw Exception("Failed to load sentences");
    }
  }

  Future<void> startListening() async {
    bool available = await speech.initialize();
    if (!available) return;

    setState(() => isListening = true);

    speech.listen(
      onResult: (result) {
        setState(() {
          recognizedText = result.recognizedWords;
        });
      },
    );
  }

  void stopListening() {
    speech.stop();
    setState(() => isListening = false);
  }

  void nextSentence() {
    if (currentIndex < sentences.length - 1) {
      setState(() {
        currentIndex++;
        recognizedText = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (sentences.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final current = sentences[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Speaking Practice")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Câu ${currentIndex + 1}/${sentences.length}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              current.sentenceEn,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),

            /// Recognized text box
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                recognizedText.isEmpty ? "Bạn chưa nói..." : recognizedText,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 40),

            /// Microphone button
            FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: isListening ? stopListening : startListening,
              child: Icon(isListening ? Icons.mic : Icons.mic_none),
            ),

            Spacer(),

            if (currentIndex < sentences.length - 1)
              ElevatedButton(
                onPressed: nextSentence,
                child: Text("Câu tiếp theo"),
              )
            else
              ElevatedButton(
                onPressed: () {},
                child: Text("Hoàn thành bài học"),
              ),
          ],
        ),
      ),
    );
  }
}
