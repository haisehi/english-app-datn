import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constrants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 1.5),
        borderRadius: BorderRadius.circular(8),
        color: AppColors.primary, // hoặc AppColors.background nếu muốn nền trắng
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white, // đổi thành AppColors.textPrimary nếu cần
            ),
          ),
          Icon(Icons.more_outlined, color: Colors.white)
        ],
      ),
    );
  }
}
