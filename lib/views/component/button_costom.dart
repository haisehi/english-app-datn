import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  String tile;
  Function onclickButton;


  ButtonCustom(this.tile, this.onclickButton);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primary,
        ),
        child: ElevatedButton(
          onPressed: () => onclickButton(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,

          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 8),  // Khoảng cách giữa icon và text
                    Text(tile, style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),    // Văn bản
                  ],
                ),
                Icon(Icons.chevron_right, color: AppColors.textSecondary,), // Biểu tượng "more"
              ],
            ),
          ),

        ),
      ),
    );
  }

}
