import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFFFFFFF); // trắng
  static const Color primary = Color(0xFF2475FC); // xanh chủ đạo
  static const Color primaryDark = Color(0xFF1F66E3); // xanh đậm hơn
  static const Color textPrimary = Color(0xFF1E1E1E); // text đen nhẹ
  static const Color textSecondary = Color(0xFF8A8A8A); // xám phụ
  static const Color divider = Color(0xFFF1F1F1); // đường kẻ nhẹ
  static const Color Orange = Color(0xFFFF9400); // cam
  static const Color Pink = Color(0xFFF40076); // hồng
  static const Color red = Color(0xFFFF0000); // đỏ
  static const Color card = Color(0xFFCADEFD); // xanh
  static const Color LightOrange = Color(0xFFF1BF81); // đỏ
  static const border = Color(0xFFEAEAEA);
  // Bạn cũng có thể thêm các màu gradient nếu muốn.
  static const LinearGradient backgroundMainColor = LinearGradient(
    colors: [
      Color(0xFFF40076),
      Color(0xFF342771),
    ],
    stops: [0.1, 0.9],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}