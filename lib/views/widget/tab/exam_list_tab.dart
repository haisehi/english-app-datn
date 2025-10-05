import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/models/exam_model.dart';
import 'package:english_learning_app/models/question_model.dart';
import 'package:english_learning_app/view_model/exam_detail_viewmodel.dart';
import 'package:english_learning_app/view_model/exam_list_viewmodel.dart';
import 'package:english_learning_app/views/screens/student/exam_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExamListTab extends StatefulWidget {
  final int courseID;

  ExamListTab(this.courseID); // Danh sách các bài thi mẫu
  final List<ExamModel> exams = ExamModel.sampleExams;

  @override
  State<ExamListTab> createState() => _ExamListTabState();
}

class _ExamListTabState extends State<ExamListTab> {
  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  void _loadLessons() {
    Future.microtask(() =>
        Provider.of<ExamListViewmodel>(context, listen: false)
            .fetchExams(widget.courseID));
  }

  @override
  Widget build(BuildContext context) {
    // List<ExamModel> exams = widget.exams;
    final examViewModel = Provider.of<ExamListViewmodel>(context);

    return examViewModel.isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: examViewModel.exams.length,
            itemBuilder: (context, index) {
              final exam =
                  examViewModel.exams[index]; // Lấy bài thi tại vị trí index
              return GestureDetector(
                onTap: () async {
                  if (exam.status == 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Bạn không được phép làm bài thi này.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  ExamDetailViewmodel viewmodel = new ExamDetailViewmodel();
                  await viewmodel.fetchQuestions(exam.examID);
                  print(viewmodel.questions.length);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ExamScreen(exam, viewmodel.questions), // Chuyển đến màn hình thi
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.school, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Tên bài thi: ${exam.examName}', // Hiển thị tên bài thi
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Cấp độ: ${exam.level}'),
                            if (exam.status == 1) // Kiểm tra trạng thái
                              Text(
                                'Hết lượt thi',
                                style: TextStyle(
                                  color: Colors.red, // Màu nổi bật
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                        Text('Thời gian: ${exam.examTime}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ngày hết hạn: ${exam.examDate}'),
                            Text(
                              'Điểm số: ${exam.myScore}/100',
                              style: TextStyle(
                                color: AppColors.Orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),

                      ],
                    ),
                  ),
                ),
              );


            },
          );
  }
}
