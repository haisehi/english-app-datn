import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class SpeakingPracticeScreen extends StatefulWidget {
  const SpeakingPracticeScreen({Key? key}) : super(key: key);

  @override
  State<SpeakingPracticeScreen> createState() => _SpeakingPracticeScreenState();
}

class _SpeakingPracticeScreenState extends State<SpeakingPracticeScreen> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;

  bool _isListening = false;
  String _recognizedText = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
          });
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  Future<void> _speakText() async {
    if (_recognizedText.isNotEmpty) {
      await _flutterTts.setLanguage("en-US"); // có thể đổi sang "vi-VN"
      await _flutterTts.setPitch(1.0);
      await _flutterTts.speak(_recognizedText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Luyện nói"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Nói một câu tiếng Anh:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _recognizedText.isEmpty ? "Chưa có câu nào..." : _recognizedText,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: _isListening ? _stopListening : _startListening,
                  child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                ),
                const SizedBox(width: 40),
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: _speakText,
                  child: const Icon(Icons.volume_up),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
