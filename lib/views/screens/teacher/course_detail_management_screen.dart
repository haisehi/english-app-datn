// import 'package:english_learning_app/constrants/app_colors.dart';
// import 'package:english_learning_app/models/exam_model.dart';
// import 'package:english_learning_app/models/lesson_model.dart';
// import 'package:english_learning_app/views/component/button_costom.dart';
// import 'package:english_learning_app/views/screens/teacher/add_exam_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
//
// class CourseDetailManagementScreen extends StatefulWidget {
//   const CourseDetailManagementScreen({super.key});
//
//   @override
//   State<CourseDetailManagementScreen> createState() => _CourseDetailManagementScreenState();
// }
//
// class _CourseDetailManagementScreenState extends State<CourseDetailManagementScreen> {
//   List<LessonModel> lessons = LessonModel.englishLessons;
//   List<ExamModel> exams = ExamModel.sampleExams;
//
//   // Thông tin khóa học (có thể được lấy từ API hoặc là dữ liệu tĩnh)
//   String courseName = "Khóa học Tiếng Anh Cơ Bản";
//   int studentCount = 120;
//   String courseStatus = "Đang mở";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Quản lý chi tiết khóa học", style: TextStyle(color: AppColors.lightGray)),
//         iconTheme: IconThemeData(color: AppColors.lightGray),
//         backgroundColor: AppColors.deepPurpleBlue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             // Thông tin khóa học
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: AppColors.deepPurpleBlue,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//
//                 children: [
//                   Text("$courseName", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.lightGray)),
//                   SizedBox(height: 5),
//                   Text("Số lượng sinh viên: $studentCount", style: TextStyle(fontSize: 16, color: AppColors.lightGray)),
//                   SizedBox(height: 5),
//                   Text("Trạng thái: $courseStatus", style: TextStyle(fontSize: 16, color: AppColors.lightGray)),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//
//             Lottie.asset(
//               'assets/animations/learn_icon.json', // Đảm bảo bạn đã thêm file JSON của Lottie trong thư mục assets
//               height: 200,
//               width: 200,
//               repeat: true, // Lặp lại animation
//               reverse: true,
//             ),
//             SizedBox(height: 10),
//             // Các nút chức năng
//             ButtonCustom("Thêm bài học", () {}),
//             SizedBox(height: 10),
//             ButtonCustom("Thêm Bài Thi", () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => AddExamScreen(), // Chuyển đến màn hình thi
//                 ),
//               );
//             }),
//             SizedBox(height: 10),
//             ButtonCustom("Danh sách bài thi", () {}),
//             SizedBox(height: 10),
//             ButtonCustom("Danh sách bài học", () {}),
//           ],
//         ),
//       ),
//     );
//   }
// }
