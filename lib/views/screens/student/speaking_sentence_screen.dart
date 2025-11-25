import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:lottie/lottie.dart';

import 'package:english_learning_app/constrants/app_constrants.dart';
import 'package:english_learning_app/models/speaking_sentence.dart';
import 'package:english_learning_app/models/speaking_result_dto.dart';
import 'package:english_learning_app/models/speaking_submit_response.dart';
import 'package:english_learning_app/services/auth_service.dart';

import '../../../main.dart';
import '../../component/speaking_wave.dart';
import 'home_student_screen.dart';
import 'speaking_result_screen.dart';

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
  bool isLoading = true;

  String feedbackMessage = "";
  Color feedbackColor = Colors.red;
  bool canNext = false;

  List<SpeakingResultDTO> speakingResults = [];
  final AuthService _authService = AuthService();

  // Animation Lottie
  final List<String> animations = [
    "assets/animations2/Audio Translation.json",
    "assets/animations2/Cat playing animation.json",
    "assets/animations2/oklm read.json",
    "assets/animations2/Voice Search.json",
  ];
  String? currentAnimation;

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
    fetchSentences().then((_) => pickRandomAnimation());
  }

  Future<void> fetchSentences() async {
    try {
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
        sentences = data.map((e) => SpeakingSentence.fromJson(e)).toList();
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> startListening() async {
    bool available = await speech.initialize();
    if (!available) return;

    setState(() {
      isListening = true;
      recognizedText = "";
      feedbackMessage = "";
      canNext = false;
    });

    speech.listen(
      listenMode: stt.ListenMode.confirmation,
      onResult: (result) {
        recognizedText = result.recognizedWords;
      },
    );
  }

  void stopListening() async {
    speech.stop();
    setState(() => isListening = false);

    if (recognizedText.isNotEmpty) {
      await compareSentenceAPI();
    }
  }

  // gọi API /compare
  Future<void> compareSentenceAPI() async {
    final currentSentence = sentences[currentIndex];
    final token = await _authService.getAccessToken();
    final body = {
      "sentenceId": currentSentence.id,
      "userText": recognizedText,
    };

    final res = await http.post(
      Uri.parse("$apiUrl/speaking/compare"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      final data = SpeakingCompareResponse.fromJson(jsonDecode(res.body));
      setState(() {
        feedbackMessage = data.feedback;
        feedbackColor = data.correct ? Colors.green : Colors.red;
        canNext = true;
      });

      // Lưu vào danh sách kết quả để submit sau
      speakingResults.add(
        SpeakingResultDTO(
          sentenceId: currentSentence.id,
          userText: recognizedText,
        ),
      );
    } else {
      setState(() {
        feedbackMessage = "So sánh thất bại!";
        feedbackColor = Colors.red;
        canNext = true;
      });
    }
  }

  void pickRandomAnimation() {
    final random = Random();
    currentAnimation = animations[random.nextInt(animations.length)];
  }

  void nextSentence() {
    if (currentIndex < sentences.length - 1) {
      setState(() {
        currentIndex++;
        recognizedText = "";
        feedbackMessage = "";
        canNext = false;
        pickRandomAnimation();
      });
    }
  }

  // gọi API /submit
  Future<void> submitLessonResult() async {
    final token = await _authService.getAccessToken();
    final body = {
      "lessonId": widget.lessonId,
      "results": speakingResults.map((e) => e.toJson()).toList(),
    };

    final res = await http.post(
      Uri.parse("$apiUrl/speaking/submit"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      final data = SpeakingSubmitResponse.fromJson(jsonDecode(res.body));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SpeakingResultScreen(
            results: speakingResults,
            returnTo: StudentNavigation(), // <-- thay đổi đây
            submitResponse: data,
          ),
        ),
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Submit thất bại!")));
    }
  }

  void finishLesson() async {
    await submitLessonResult();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final current = sentences[currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Luyện nói"),
        backgroundColor: const Color(0xFF2475FC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Câu ${currentIndex + 1}/${sentences.length}",
              style: const TextStyle(fontSize: 18, color: Color(0xFF2475FC)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (currentAnimation != null)
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Lottie.asset(currentAnimation!),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    current.sentenceEn,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2475FC),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            SpeakingWave(active: isListening),
            const SizedBox(height: 16),
            FloatingActionButton(
              backgroundColor: isListening ? Colors.red : const Color(0xFF2475FC),
              onPressed: isListening ? stopListening : startListening,
              child: Icon(isListening ? Icons.mic : Icons.mic_none),
            ),
            const Spacer(),
            if (feedbackMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  feedbackMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: feedbackColor,
                  ),
                ),
              ),
            if (canNext)
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: currentIndex < sentences.length - 1
                      ? nextSentence
                      : finishLesson,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2475FC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    currentIndex < sentences.length - 1
                        ? "Câu tiếp theo"
                        : "Hoàn thành bài học",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
