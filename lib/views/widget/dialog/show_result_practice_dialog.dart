import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../localization/app_localizations.dart';

class ShowResultPracticeDialog extends StatelessWidget {
  final double completionRate;
  final bool isCompleted;
  final VoidCallback onReplay;
  final VoidCallback onComplete;

  const ShowResultPracticeDialog({
    Key? key,
    required this.completionRate,
    required this.isCompleted,
    required this.onReplay,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 32), // Icon hoàn thành
          SizedBox(width: 10),
          Text(
            loc.tr("result"), // đa ngôn ngữ
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${loc.tr("completed_percentage")} ${completionRate.toStringAsFixed(1)}%', // đa ngôn ngữ
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.refresh, color: AppColors.Orange),
              label: Text(
                loc.tr("replay"), // đa ngôn ngữ
                style: TextStyle(color: AppColors.Orange),
              ),
              onPressed: onReplay,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.check, color: AppColors.background),
              label: Text(
                loc.tr("complete"), // đa ngôn ngữ
                style: TextStyle(color: AppColors.background),
              ),
              onPressed: isCompleted ? onComplete : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                backgroundColor: isCompleted ? AppColors.primary : Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}