class ExamModel {
  final int examID;
  final String examName;
  final String description;
  final String examDate;
  final int examTime;
  final String level;
  final int maxNumberOfExam;
  // final double passingScore;
  final double myScore;
  final int status;
  final String type;
  final int courseID;

  ExamModel({
    required this.examID,
    required this.examName,
    required this.description,
    required this.examDate,
    required this.examTime,
    required this.level,
    required this.maxNumberOfExam,
    // required this.passingScore,
    required this.myScore,
    required this.status,
    required this.type,
    required this.courseID,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      examID: json['testId'] as int,
      examName: json['testName'] as String,
      description: json['description'] as String,
      examDate: json['examDate'] as String,
      examTime: json['examTime'] as int, // Đã sửa lại ánh xạ đúng
      level: json['level'] as String,
      maxNumberOfExam: int.tryParse(json['maxNumberOfExams'].toString()) ?? 0,
      // passingScore: (json['passingScore'] as num).toDouble(), // Đảm bảo kiểu double
      myScore: double.tryParse(json['score'].toString()) ?? 0.0, // Đảm bảo kiểu double
      status: json['status'] as int,
      type: json['type'] as String,
      courseID: json['courseId'] as int,
    );
  }
  factory ExamModel.fromJsonStatistic(Map<String, dynamic> json) {
    return ExamModel(
      examID: json['testId'] as int,
      level: json['level'] as String,
      maxNumberOfExam: int.tryParse(json['maxNumberOfExams'].toString()) ?? 0,
      status: json['userTestStatus'] as int,
      examName: json['testName'] as String,
      type: json['type'] as String,
      courseID: json['courseId'] as int,
      myScore: double.tryParse(json['score'].toString()) ?? 0.0,
      examDate: json['date'] as String,
      examTime: 0 as int,
      description: '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'testId': examID,
      'testName': examName,
      'description': description,
      'examDate': examDate,
      'examTime': examTime,
      'level': level,
      'maxNumberOfExams': maxNumberOfExam,
      'score': myScore,
      'status': status,
      'type': type,
      'courseId': courseID,
    };
  }
  // Dữ liệu mẫu
  static List<ExamModel> sampleExams = [
    ExamModel(
      examID: 1,
      examName: "Java Basics",
      description: "Introduction to Java programming",
      examDate: "2024-12-20",
      examTime: 90,
      level: "Beginner",
      maxNumberOfExam: 100,
      // passingScore: 50.0,
      myScore: 75.0,
      status: 1,
      type: "Online",
      courseID: 101,
    ),
    ExamModel(
      examID: 2,
      examName: "Spring Framework",
      description: "Advanced Spring concepts",
      examDate: "2024-12-22",
      examTime: 120,
      level: "Intermediate",
      maxNumberOfExam: 50,
      // passingScore: 70.0,
      myScore: 60.0,
      status: 0,
      type: "Offline",
      courseID: 102,
    ),
    ExamModel(
      examID: 3,
      examName: "Database Design",
      description: "Designing relational databases",
      examDate: "2024-12-25",
      examTime: 60,
      level: "Beginner",
      maxNumberOfExam: 150,
      // passingScore: 60.0,
      myScore: 80.0,
      status: 1,
      type: "Online",
      courseID: 103,
    ),
    ExamModel(
      examID: 4,
      examName: "Data Structures",
      description: "Data structures in Java",
      examDate: "2024-12-28",
      examTime: 180,
      level: "Advanced",
      maxNumberOfExam: 200,
      // passingScore: 85.0,
      myScore: 90.0,
      status: 1,
      type: "Offline",
      courseID: 104,
    ),
    ExamModel(
      examID: 5,
      examName: "Software Testing",
      description: "Testing strategies and tools",
      examDate: "2025-01-05",
      examTime: 120,
      level: "Intermediate",
      maxNumberOfExam: 80,
      // passingScore: 65.0,
      myScore: 55.0,
      status: 0,
      type: "Online",
      courseID: 105,
    ),
  ];
}
