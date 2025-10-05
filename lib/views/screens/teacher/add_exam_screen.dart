// import 'package:english_learning_app/constrants/app_colors.dart';
// import 'package:flutter/material.dart';
//
// class AddExamScreen extends StatefulWidget {
//   const AddExamScreen({Key? key}) : super(key: key);
//
//   @override
//   _AddExamScreenState createState() => _AddExamScreenState();
// }
//
// class _AddExamScreenState extends State<AddExamScreen> {
//   // Các thông tin của bài thi
//   final TextEditingController examNameController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController expirationDateController = TextEditingController();
//   final TextEditingController timeController = TextEditingController();
//   final TextEditingController levelController = TextEditingController();
//   final TextEditingController attemptsController = TextEditingController();
//   final TextEditingController passingScoreController = TextEditingController();
//
//   // Danh sách các câu hỏi và câu trả lời
//   List<Map<String, String>> questions = [];
//
//   void addQuestion() {
//     setState(() {
//       questions.add({
//         'question': '',
//         'answer1': '',
//         'answer2': '',
//         'answer3': '',
//         'answer4': '',
//         'correctAnswer': '',
//       });
//     });
//   }
//
//   void removeQuestion(int index) {
//     setState(() {
//       questions.removeAt(index);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Thêm bài thi', style: TextStyle(color: AppColors.lightGray),),
//         iconTheme: IconThemeData(color: AppColors.lightGray),
//         backgroundColor: AppColors.deepPurpleBlue,
//       ),
//       backgroundColor: AppColors.backgroundColor,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Các trường thông tin bài thi
//
//                 TextField(
//                   controller: examNameController,
//                   decoration: InputDecoration(labelText: 'Tên bài thi'),
//                 ),
//                 TextField(
//                   controller: descriptionController,
//                   decoration: InputDecoration(labelText: 'Mô tả'),
//                 ),
//                 TextField(
//                   controller: expirationDateController,
//                   decoration: InputDecoration(labelText: 'Ngày hết hạn'),
//                   keyboardType: TextInputType.datetime,
//                 ),
//                 TextField(
//                   controller: timeController,
//                   decoration: InputDecoration(
//                       labelText: 'Thời gian làm bài (phút)'
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: levelController,
//                   decoration: InputDecoration(labelText: 'Cấp độ'),
//                 ),
//                 TextField(
//                   controller: attemptsController,
//                   decoration: InputDecoration(labelText: 'Số lần làm bài'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: passingScoreController,
//                   decoration: InputDecoration(labelText: 'Điểm để pass'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 SizedBox(height: 20),
//
//                 // Danh sách câu hỏi
//                 Text('Câu hỏi và câu trả lời:', style: TextStyle(fontSize: 18)),
//                 SizedBox(height: 10),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: questions.length,
//                   itemBuilder: (context, index) {
//                     return Card(
//                       margin: EdgeInsets.symmetric(vertical: 8),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             TextField(
//                               decoration: InputDecoration(labelText: 'Câu hỏi ${index + 1}'),
//                               onChanged: (value) {
//                                 setState(() {
//                                   questions[index]['question'] = value;
//                                 });
//                               },
//                             ),
//                             TextField(
//                               decoration: InputDecoration(labelText: 'Câu trả lời 1'),
//                               onChanged: (value) {
//                                 setState(() {
//                                   questions[index]['answer1'] = value;
//                                 });
//                               },
//                             ),
//                             TextField(
//                               decoration: InputDecoration(labelText: 'Câu trả lời 2'),
//                               onChanged: (value) {
//                                 setState(() {
//                                   questions[index]['answer2'] = value;
//                                 });
//                               },
//                             ),
//                             TextField(
//                               decoration: InputDecoration(labelText: 'Câu trả lời 3'),
//                               onChanged: (value) {
//                                 setState(() {
//                                   questions[index]['answer3'] = value;
//                                 });
//                               },
//                             ),
//                             TextField(
//                               decoration: InputDecoration(labelText: 'Câu trả lời 4'),
//                               onChanged: (value) {
//                                 setState(() {
//                                   questions[index]['answer4'] = value;
//                                 });
//                               },
//                             ),
//                             TextField(
//                               decoration: InputDecoration(labelText: 'Câu trả lời đúng'),
//                               onChanged: (value) {
//                                 setState(() {
//                                   questions[index]['correctAnswer'] = value;
//                                 });
//                               },
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.delete, color: Colors.red),
//                               onPressed: () => removeQuestion(index),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//
//                 // Nút thêm câu hỏi mới
//                 ElevatedButton(
//                   onPressed: addQuestion,
//                   child: Text('Thêm câu hỏi'),
//                 ),
//                 SizedBox(height: 20),
//
//                 // Nút lưu bài thi
//                 ElevatedButton(
//                   onPressed: () {
//                     // Lưu bài thi
//                     // Ở đây bạn có thể thêm code để lưu bài thi vào cơ sở dữ liệu
//                     print('Bài thi đã được lưu');
//                   },
//                   child: Text('Lưu bài thi'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
