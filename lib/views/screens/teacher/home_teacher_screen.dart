import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTeacherScreen extends StatefulWidget {
  const HomeTeacherScreen({super.key});

  @override
  State<HomeTeacherScreen> createState() => _HomeTeacherScreenState();
}

class _HomeTeacherScreenState extends State<HomeTeacherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF40076), // Màu hồng
                  Color(0xFF342771), // Màu tím đậm
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(),

          )
      ),
    );
  }
}
