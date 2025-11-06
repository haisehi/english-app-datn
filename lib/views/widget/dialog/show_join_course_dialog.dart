import 'package:english_learning_app/view_model/my_course_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowJoinCourseDialog extends StatelessWidget {
  final int courseId;
  final String role = "USER";
  final String status = "1";

  ShowJoinCourseDialog(this.courseId);

  @override
  Widget build(BuildContext context) {
    final myCourseViewModel = Provider.of<MyCourseViewmodel>(context, listen: false);

    return AlertDialog(
      title: const Text(
        'Xác nhận tham gia khóa học',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'Bạn có chắc chắn muốn tham gia khóa học này không?',
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, {'success': false});
          },
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            // Gọi hàm joinCourse mà không cần nhập mã sinh viên
            myCourseViewModel.joinCourse(
              courseId,
              0,        // studentCode giả định = 0
              role,
              status,
              context,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Xác nhận',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
