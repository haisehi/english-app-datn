import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatAiScreen extends StatefulWidget {
  @override
  _ChatAiScreenState createState() => _ChatAiScreenState();
}

class _ChatAiScreenState extends State<ChatAiScreen> {
  final List<ChatMessage> _messages = [];

  final ChatUser _user = ChatUser(
    id: 'user',
    firstName: 'User',
    profileImage: 'assets/images/image1.jpg', // avatar user
  );

  final ChatUser _bot = ChatUser(
    id: 'bot',
    firstName: 'MeoV AI',
    profileImage: 'assets/images/logo.png', // avatar bot
  );

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Gửi tin nhắn chào từ AI khi mở màn hình
    Future.delayed(Duration(milliseconds: 300), () {
      final ChatMessage welcomeMessage = ChatMessage(
        text: 'Xin chào! Mình là MeoV AI 🤖. Mình có thể giúp gì cho bạn hôm nay?',
        user: _bot,
        createdAt: DateTime.now(),
      );

      setState(() {
        _messages.insert(0, welcomeMessage);
      });
    });
  }

  void _sendMessage(String message) async {
    final ChatMessage userMessage = ChatMessage(
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

      final ChatMessage botMessage = ChatMessage(
        text: response?.output ?? 'Xin lỗi, mình chưa hiểu bạn nói gì 😢',
        user: _bot,
        createdAt: DateTime.now(),
      );

      setState(() {
        _messages.insert(0, botMessage);
      });
    } catch (e) {
      final ChatMessage errorMessage = ChatMessage(
        text: 'Đã xảy ra lỗi. Vui lòng thử lại sau!',
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat AI',
          style: TextStyle(color: AppColors.background.withOpacity(0.8)),
        ),
        backgroundColor: AppColors.primaryDark,
        iconTheme: IconThemeData(color: AppColors.background),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: DashChat(
              messages: _messages,
              currentUser: _user,
              onSend: (ChatMessage message) {
                _controller.clear();
                _sendMessage(message.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}
