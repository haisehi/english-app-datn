import 'dart:async';
import 'package:flutter/material.dart';

import '../../constrants/app_colors.dart'; // Nhớ đảm bảo AppColors đã được cập nhật

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_SplashContent> _pages = [
    _SplashContent(
      image: 'assets/images/logo.png', // Đặt tên ảnh ở đây
      title: 'MeoV',
      subtitle: '',
    ),
    _SplashContent(
      image: 'assets/images/Discover.png',
      title: 'Discover',
      subtitle: 'Learn new words in a fun way!',
    ),
    _SplashContent(
      image: 'assets/images/Grow.png',
      title: 'Grow',
      subtitle: 'Speaking practice powered by AI assistant',
    ),
    _SplashContent(
      image: 'assets/images/Ready.png',
      title: 'Ready',
      subtitle: 'Begin your language adventure now',
    ),
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentPage < _pages.length - 1) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        timer.cancel();
        // Sau khi xong splash, bạn chuyển sang màn home/login
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _pages.length,
          itemBuilder: (context, index) {
            final content = _pages[index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  content.image,
                  height: 200,
                ),
                const SizedBox(height: 40),
                Text(
                  content.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  content.subtitle,
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SplashContent {
  final String image;
  final String title;
  final String subtitle;

  _SplashContent({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}
