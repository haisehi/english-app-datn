import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constrants/app_colors.dart';

class LanguageSelectScreen extends StatelessWidget {
  const LanguageSelectScreen({super.key});

  Future<void> _saveLanguage(BuildContext context, String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', code);

    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildLanguageButton(
      BuildContext context, String language, String code, String flag) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Text(flag, style: const TextStyle(fontSize: 26)),
        title: Text(
          language,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        onTap: () => _saveLanguage(context, code),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          "Select your language",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLanguageButton(context, "English", "en", "🇺🇸"),
            _buildLanguageButton(context, "한국어 (Korean)", "ko", "🇰🇷"),
            _buildLanguageButton(context, "日本語 (Japanese)", "ja", "🇯🇵"),
            _buildLanguageButton(context, "Tiếng Việt", "vi", "🇻🇳"),
          ],
        ),
      ),
    );
  }
}
