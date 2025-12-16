import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constrants/app_colors.dart';
import 'login_screen.dart';
import 'language_select_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _checkedAuth = false;

  final List<_SplashContent> _pages = [
    _SplashContent(
      image: 'assets/images/logo.png',
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
    _checkAuth();
  }

  /// 🔐 CHECK LOGIN STATE
  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token != null && token.isNotEmpty) {
      // Đã login → vào thẳng app
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/student');
      });
    } else {
      // Chưa login → show onboarding
      setState(() => _checkedAuth = true);
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      setState(() => _currentPage++);
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LanguageSelectScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_checkedAuth) {
      // ⏳ Đợi check login
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final bool isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final content = _pages[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Image.asset(content.image, height: 200),
                    const SizedBox(height: 40),
                    Text(
                      content.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
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
            Positioned(
              bottom: 40,
              left: 24,
              right: 24,
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isLastPage ? 'START' : 'CONTINUE',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.background,
                    fontWeight: FontWeight.bold,
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
