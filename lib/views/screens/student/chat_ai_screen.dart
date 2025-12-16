import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

import '../../../localization/app_localizations.dart';

class ChatAiScreen extends StatefulWidget {
  @override
  _ChatAiScreenState createState() => _ChatAiScreenState();
}

class _ChatAiScreenState extends State<ChatAiScreen> {
  final List<ChatMessage> _messages = [];

  final ChatUser _user = ChatUser(
    id: 'user',
    firstName: 'User',
    profileImage: 'assets/images/image1.jpg',
  );

  final ChatUser _bot = ChatUser(
    id: 'bot',
    firstName: 'MeoV AI',
    profileImage: 'assets/images/logo.png',
  );

  @override
  void initState() {
    super.initState();

    /// ⚠️ Không dùng context trực tiếp trong initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loc = AppLocalizations.of(context)!;

      final welcomeMessage = ChatMessage(
        text: loc.tr("ai_welcome"),
        user: _bot,
        createdAt: DateTime.now(),
      );

      setState(() {
        _messages.insert(0, welcomeMessage);
      });
    });
  }

  void _sendMessage(String message) async {
    final loc = AppLocalizations.of(context)!;

    final userMessage = ChatMessage(
      text: message,
      user: _user,
      createdAt: DateTime.now(),
    );

    setState(() {
      _messages.insert(0, userMessage);
    });

    try {
      final response = await Gemini.instance.prompt(parts: [
        Part.text(message),
      ]);

      final botMessage = ChatMessage(
        text: response?.output ?? loc.tr("ai_not_understand"),
        user: _bot,
        createdAt: DateTime.now(),
      );

      setState(() {
        _messages.insert(0, botMessage);
      });
    } catch (e) {
      final errorMessage = ChatMessage(
        text: loc.tr("common_error"),
        user: _bot,
        createdAt: DateTime.now(),
      );

      setState(() {
        _messages.insert(0, errorMessage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.tr("chat_ai"),
          style: TextStyle(color: AppColors.background.withOpacity(0.8)),
        ),
        backgroundColor: AppColors.primaryDark,
        iconTheme: IconThemeData(color: AppColors.background),
        centerTitle: true,
      ),
      body: DashChat(
        messages: _messages,
        currentUser: _user,
        onSend: (ChatMessage message) {
          _sendMessage(message.text);
        },
      ),
    );
  }
}
