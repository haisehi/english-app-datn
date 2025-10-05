// import 'package:english_learning_app/constrants/app_colors.dart';
// import 'package:english_learning_app/models/course_model.dart';
// import 'package:english_learning_app/views/screens/teacher/course_detail_management_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class CourseManagementScreen extends StatefulWidget {
//   const CourseManagementScreen({super.key});
//
//   @override
//   State<CourseManagementScreen> createState() => _CourseManagementScreenState();
// }
//
// class _CourseManagementScreenState extends State<CourseManagementScreen> {
//   List<CourseModel> courses = CourseModel.getCourses();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//       title: Text(
//         'Quản lý khóa học',
//         style: TextStyle(color: Colors.white.withOpacity(0.8)),
//       ),
//       backgroundColor: AppColors.darkBlueBlack,
//     ),
//
//       body:SafeArea(
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xFFF40076), // Màu hồng
//                   Color(0xFF342771), // Màu tím đậm
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                   gradient: AppColors.backgroundMainColor
//               ),
//               child: ListView.builder(
//                 itemCount: courses.length,
//                 itemBuilder: (context, index) {
//                   final course = courses[index];
//                   return Container(
//                     margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                     decoration: BoxDecoration(
//                       color: Color(0xFF342771).withOpacity(0.5),
//                       borderRadius: BorderRadius.circular(12), // Bo góc cho viền gradient
//                     ),
//                     child: Card(
//                       elevation: 5,
//                       shadowColor: Color(0xFF4A4E69),
//                       color: AppColors.deepPurpleBlue,
//                       margin: EdgeInsets.all(2), // Khoảng cách để hiển thị viền gradient
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12), // Bo góc cho Card bên trong
//                       ),
//                       child: ListTile(
//                         contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                         title: Text(
//                           course.courseName,
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white.withOpacity(0.8),
//                           ),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(height: 5),
//                             Text("Trạng thái: " + course.courseStatus, style: TextStyle(color: Colors.white.withOpacity(0.7)),),
//                             SizedBox(height: 5),
//                             Text('Giới hạn sinh viên: ${course.maxQuantity}' , style: TextStyle(color: Colors.white.withOpacity(0.7))),
//                             SizedBox(height: 5),
//                             LinearProgressIndicator(
//                               value: 80/100,
//                               minHeight: 4,
//                               backgroundColor: Colors.grey[300],
//                               color: AppColors.darkPurple,
//                             ),
//                           ],
//                         ),
//                         trailing: Icon(
//                           Icons.arrow_forward_ios,
//                           color: AppColors.lightGray,
//                         ),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CourseDetailManagementScreen(), // Chuyển đến màn hình thi
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   );
//
//                 },
//               ),
//             ),
//
//
//           )
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Hành động khi bấm nút
//           showAddCourseDialog(context);
//         },
//         backgroundColor: Color(0xFFF40076), // Màu nền nút
//         child: Icon(Icons.add), // Icon bên trong nút
//       ),
//     );
//   }
//   final TextEditingController courseNameController = TextEditingController();
//   final TextEditingController courseCodeController = TextEditingController();
//   final TextEditingController maxQuantityController = TextEditingController();
//   String courseStatus = 'Public';
//   bool isPrivate = false;
//   void showAddCourseDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) {
//           return Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 AppBar(
//                   title: Text('Thêm Khóa Học', style: TextStyle(color: AppColors.lightGray),),
//                   backgroundColor: AppColors.darkBlueBlack,
//                   automaticallyImplyLeading: false,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Tên khóa học
//                       TextField(
//                         controller: courseNameController,
//                         decoration: InputDecoration(
//                           labelText: 'Tên Khóa Học',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       // Mã khóa học
//                       TextField(
//                         controller: courseCodeController,
//                         decoration: InputDecoration(
//                           labelText: 'Mã Khóa Học',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       // Trạng thái
//                       DropdownButtonFormField<String>(
//                         value: courseStatus,
//                         items: ['Public', 'Private'].map((status) {
//                           return DropdownMenuItem(
//                             value: status,
//                             child: Text(status),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             courseStatus = value!;
//                             isPrivate = courseStatus == 'Private';
//                           });
//                         },
//                         decoration: InputDecoration(
//                           labelText: 'Trạng Thái',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       // Số lượng sinh viên tối đa (chỉ hiển thị nếu là Private)
//                       if (isPrivate)
//                         TextField(
//                           controller: maxQuantityController,
//                           keyboardType: TextInputType.number,
//                           decoration: InputDecoration(
//                             labelText: 'Số Lượng Sinh Viên Tối Đa',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 // Nút hành động
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           'Hủy',
//                           style: TextStyle(color: Colors.red),
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Thêm logic lưu khóa học tại đây
//                           final courseName = courseNameController.text;
//                           final courseCode = courseCodeController.text;
//                           final maxQuantity = maxQuantityController.text;
//
//                           print('Tên Khóa Học: $courseName');
//                           print('Mã Khóa Học: $courseCode');
//                           print('Trạng Thái: $courseStatus');
//                           if (isPrivate) print('Số Lượng Sinh Viên Tối Đa: $maxQuantity');
//
//                           // Đóng dialog sau khi lưu
//                           Navigator.pop(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.deepPurpleBlue,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           padding: EdgeInsets.symmetric(vertical: 8),
//                         ),
//                         child: Text('Lưu', style: TextStyle(color: AppColors.brightOrange),),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 16),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
