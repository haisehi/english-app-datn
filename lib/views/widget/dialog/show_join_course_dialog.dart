import 'package:english_learning_app/view_model/my_course_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowJoinCourseDialog extends StatelessWidget {
  final int courseId;
  final String role = "USER";
  final status = "1";


  ShowJoinCourseDialog(this.courseId);

  @override
  Widget build(BuildContext context) {
    final myCourseViewModel = Provider.of<MyCourseViewmodel>(context, listen: false);
    final TextEditingController studentCodeController = TextEditingController();

    return AlertDialog(
      title: Text('Nhập mã sinh viên'),
      content: TextField(
        controller: studentCodeController,
        decoration: InputDecoration(
          labelText: 'Mã sinh viên (nếu có)',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, {'success': false,}); // Đóng dialog
          },
          child: Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            var studentCode = int.tryParse(studentCodeController.text);
            if (studentCode == null) {
              studentCode = -1;
            }
            myCourseViewModel.joinCourse(
              courseId,
              studentCode,
              role,
              status,
              context); // Gọi hàm từ ViewModel
             // Đóng dialog
          },
          child: Text('Tham gia'),
        ),
      ],
    );
  }
}
