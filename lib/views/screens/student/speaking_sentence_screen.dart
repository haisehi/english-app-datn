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

import '../../../localization/app_localizations.dart';
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

  List<bool> wordResults = []; // true = đúng, false = sai
  List<SpeakingResultDTO> speakingResults = [];

  final AuthService _authService = AuthService();

  // Lottie animations
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

  // ================= API =================

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

  // ================= SPEECH =================

  Future<void> startListening() async {
    bool available = await speech.initialize();
    if (!available) return;

    setState(() {
      isListening = true;
      recognizedText = "";
      feedbackMessage = "";
      wordResults.clear();
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
      compareWords(sentences[currentIndex].sentenceEn, recognizedText);
      await compareSentenceAPI();
    }
  }

  // ================= COMPARE =================

  void compareWords(String correctSentence, String userSentence) {
    final correctWords =
    correctSentence.toLowerCase().split(RegExp(r"\s+"));
    final userWords =
    userSentence.toLowerCase().split(RegExp(r"\s+"));

    wordResults = [];

    for (int i = 0; i < correctWords.length; i++) {
      if (i < userWords.length && correctWords[i] == userWords[i]) {
        wordResults.add(true);
      } else {
        wordResults.add(false);
      }
    }
  }

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
      final data =
      SpeakingCompareResponse.fromJson(jsonDecode(res.body));

      setState(() {
        feedbackMessage = data.feedback;
        feedbackColor = data.correct ? Colors.green : Colors.red;
        canNext = true;
      });

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

  // ================= UI HELPERS =================

  void pickRandomAnimation() {
    final random = Random();
    currentAnimation = animations[random.nextInt(animations.length)];
  }

  Widget buildHighlightedSentence(String sentence) {
    final words = sentence.split(" ");

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: List.generate(words.length, (index) {
          Color color = const Color(0xFF2475FC);

          if (wordResults.isNotEmpty && index < wordResults.length) {
            color = wordResults[index] ? Colors.green : Colors.red;
          }

          return TextSpan(
            text: "${words[index]} ",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          );
        }),
      ),
    );
  }

  // ================= NAV =================

  void nextSentence() {
    if (currentIndex < sentences.length - 1) {
      setState(() {
        currentIndex++;
        recognizedText = "";
        feedbackMessage = "";
        canNext = false;
        wordResults.clear();
        pickRandomAnimation();
      });
    }
  }

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
      final data =
      SpeakingSubmitResponse.fromJson(jsonDecode(res.body));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SpeakingResultScreen(
            results: speakingResults,
            returnTo: StudentNavigation(),
            submitResponse: data,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Submit thất bại!")),
      );
    }
  }

  void finishLesson() async {
    await submitLessonResult();
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final current = sentences[currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(loc.tr("lesson_speaking")),
        backgroundColor: const Color(0xFF2475FC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Câu ${currentIndex + 1}/${sentences.length}",
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF2475FC),
              ),
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
                  child: buildHighlightedSentence(current.sentenceEn),
                ),
              ],
            ),
            const SizedBox(height: 40),
            SpeakingWave(active: isListening),
            const SizedBox(height: 16),
            FloatingActionButton(
              backgroundColor:
              isListening ? Colors.red : const Color(0xFF2475FC),
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
                        ? loc.tr("next")
                        : loc.tr("completed"),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
