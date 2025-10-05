import 'package:english_learning_app/models/lesson_model.dart';

class CourseModel {
  final int courseID;
  final String courseName;
  final String courseCode;
  final String courseStatus;
  final int maxQuantity;
  final String courseImage;
  final String enrollmentStatus;

  CourseModel({
    required this.courseID,
    required this.courseName,
    required this.courseCode,
    required this.courseStatus,
    required this.maxQuantity,
    required this.courseImage,
    required this.enrollmentStatus,
  });

  // Factory constructor for JSON
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      courseID: json['courseId'] as int,
      courseName: json['courseName'] as String,
      courseCode: json['courseCode'] as String,
      courseStatus: json['status'] == 0 ? 'Chưa hoàn thành' : 'Hoàn thành',
      maxQuantity: json['maxQuantity'] as int,
      courseImage: json['image'] as String? ?? '',
      enrollmentStatus:
          json['enrollmentStatus'] as String? ?? '', // Gán '' nếu là null
    );
  }

  // Static data for testing
  static List<CourseModel> getCourses() {
    return [
      CourseModel(
          courseID: 1,
          courseName: 'Bắt đầu học tiếng anh',
          courseCode: 'FLUT101',
          courseStatus: 'Active',
          maxQuantity: 100,
          courseImage: 'assets/images/image1.jpg',
          enrollmentStatus: ''),
      CourseModel(
          courseID: 2,
          courseName: 'Chủ đề Động Vật',
          courseCode: 'FLUT201',
          courseStatus: 'Active',
          maxQuantity: 50,
          courseImage: 'assets/images/image2.jpg',
          enrollmentStatus: ''),
      CourseModel(
          courseID: 3,
          courseName: 'Chủ đề Gia Đình',
          courseCode: 'PYTHON101',
          courseStatus: 'Inactive',
          maxQuantity: 200,
          courseImage: 'assets/images/image3.jpg',
          enrollmentStatus: ''),
      CourseModel(
          courseID: 4,
          courseName: 'Chủ đề Ăn Uống',
          courseCode: 'JS101',
          courseStatus: 'Active',
          maxQuantity: 150,
          courseImage: 'assets/images/image1.jpg',
          enrollmentStatus: ''),
      CourseModel(
          courseID: 5,
          courseName: 'Chủ đề Gia Đình',
          courseCode: 'DSA101',
          courseStatus: 'Active',
          maxQuantity: 75,
          courseImage: 'assets/images/image1.jpg',
          enrollmentStatus: ''),
    ];
  }
}
