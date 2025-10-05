import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/view_model/translate_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final Color accentColor = const Color(0xFF2475FC);
  final FlutterTts flutterTts = FlutterTts();

  /// Map ngôn ngữ để TTS hiểu đúng
  String _mapLang(String lang) {
    switch (lang) {
      case "en":
        return "en-US";
      case "vi":
        return "vi-VN";
      default:
        return "en-US";
    }
  }

  Future _speak(String text, String lang) async {
    if (text.isEmpty) return;

    await flutterTts.setLanguage(_mapLang(lang));
    await flutterTts.setVolume(1.0);      // max volume
    await flutterTts.setSpeechRate(0.9);  // tốc độ đọc
    await flutterTts.setPitch(1.0);       // cao độ giọng

    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final translateViewModel = Provider.of<TranslateViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Dịch Từ Vựng",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/animations/translate_icon.json',
                  height: 180,
                  repeat: true,
                ),
              ),
              const SizedBox(height: 20),

              // Ô nhập văn bản
              TextField(
                decoration: InputDecoration(
                  labelText: "Nhập từ vựng",
                  labelStyle: TextStyle(color: accentColor),
                  hintText: "Ví dụ: Hello",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: accentColor, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: accentColor, width: 2),
                  ),
                ),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                maxLines: 3,
                onChanged: (value) => translateViewModel.updateInputText(value),
              ),

              const SizedBox(height: 20),

              // Language Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLanguageDropdown(
                    "Từ",
                    translateViewModel.inputLanguage,
                        (value) {
                      if (value != null) {
                        translateViewModel.updateInputLanguage(value);
                      }
                    },
                  ),
                  // Đổi chiều ngôn ngữ
                  IconButton(
                    icon: Icon(Icons.compare_arrows,
                        color: accentColor, size: 30),
                    onPressed: () {
                      setState(() {
                        final temp = translateViewModel.inputLanguage;
                        translateViewModel.updateInputLanguage(
                            translateViewModel.outputLanguage);
                        translateViewModel.updateOutputLanguage(temp);
                      });
                    },
                  ),
                  _buildLanguageDropdown(
                    "Sang",
                    translateViewModel.outputLanguage,
                        (value) {
                      if (value != null) {
                        translateViewModel.updateOutputLanguage(value);
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Nút dịch
              ElevatedButton(
                onPressed: translateViewModel.translate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 3,
                ),
                child: const Text(
                  "Dịch",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),

              const SizedBox(height: 25),

              // Kết quả + nút loa
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        translateViewModel.outputText.isEmpty
                            ? "Kết quả sẽ hiển thị ở đây..."
                            : translateViewModel.outputText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (translateViewModel.outputText.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.volume_up,
                            color: accentColor, size: 28),
                        onPressed: () => _speak(
                          translateViewModel.outputText,
                          translateViewModel.outputLanguage,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(
      String label,
      String value,
      ValueChanged<String?> onChanged,
      ) {
    final Color accentColor = const Color(0xFF2475FC);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: accentColor, width: 1.5),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: DropdownButton<String>(
            value: value,
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'vi', child: Text('Vietnamese')),
            ],
            onChanged: onChanged,
            underline: const SizedBox(),
            style: TextStyle(color: accentColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
