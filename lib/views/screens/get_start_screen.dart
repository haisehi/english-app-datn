import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GetStartScreen extends StatefulWidget {
  @override
  _GetStartScreenState createState() => _GetStartScreenState();
}

class _GetStartScreenState extends State<GetStartScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              _buildSlide(
                imagePath: "assets/images/image1.jpg",
                title: "Welcome to English Learning App",
                description: "Learn English quickly and efficiently with our app!",
                color: Colors.blueAccent,
              ),
              _buildSlide(
                imagePath: "assets/images/image2.jpg",
                title: "Interactive Lessons",
                description: "Engage in interactive lessons that make learning fun.",
                color: Colors.greenAccent,
              ),
              _buildSlide(
                imagePath: "assets/images/image3.jpg",
                title: "Track Your Progress",
                description: "Monitor your improvements and stay motivated.",
                color: Colors.orangeAccent,
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: _currentIndex == 2
                ? ElevatedButton(
              onPressed: () {
                // Chuyển đến màn hình chính khi nhấn nút "Get Started"
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Get Started",
                style: TextStyle(fontSize: 18),
              ),

            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                    (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: _currentIndex == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide({
    required String imagePath,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 250,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}