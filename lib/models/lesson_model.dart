
class LessonModel {
  final int lessonID;
  final String lessonName;
  final String content;
  final String attachments;
  final int level;
  final int courseID;
  late final double progress;

  LessonModel(
      {required this.lessonID,
      required this.lessonName,
      required this.content,
      required this.attachments,
      required this.level,
      required this.courseID,
      required this.progress
      });
  factory LessonModel.fromJson(Map<String, dynamic> json){
    return LessonModel(
        lessonID: json['lessonId'] as int,
        lessonName: json['lessonName'] as String,
        content: json['content'] as String,
        attachments: json['attachments'] as String,
        level: json['level'] as int,
        courseID: json['courseId'] as int,
        progress: json['progress'] as double
    );
  }
  static List<LessonModel> englishLessons = [
    LessonModel(
        lessonID: 1,
        lessonName: "Introduction to English",
        content: "Basic phrases and greetings.",
        attachments: "assets/images/image1.jpg",
        level: 1,
        courseID: 101,
        progress: 0.0),
    LessonModel(
        lessonID: 2,
        lessonName: "English Alphabet",
        content: "Learning the alphabet and pronunciation.",
        attachments: "assets/images/image2.jpg",
        level: 1,
        courseID: 101,
        progress: 0.0),
    LessonModel(
        lessonID: 3,
        lessonName: "Basic Grammar",
        content: "Introduction to English grammar.",
        attachments: "assets/images/image3.jpg",
        level: 2,
        courseID: 101,
        progress: 0.0),
    LessonModel(
        lessonID: 4,
        lessonName: "Simple Conversations",
        content: "Conversational phrases for daily use.",
        attachments: "assets/images/image4.jpg",
        level: 2,
        courseID: 101,
        progress: 0.0),
    LessonModel(
        lessonID: 5,
        lessonName: "Intermediate Vocabulary",
        content: "Expand your vocabulary.",
        attachments: "assets/images/image5.jpg",
        level: 3,
        courseID: 102,
        progress: 0.0),
    LessonModel(
        lessonID: 6,
        lessonName: "Reading Comprehension",
        content: "Practice reading skills.",
        attachments: "assets/images/image6.jpg",
        level: 3,
        courseID: 102,
        progress: 0.0),
    LessonModel(
        lessonID: 7,
        lessonName: "Advanced Grammar",
        content: "In-depth grammar lessons.",
        attachments: "assets/images/image7.jpg",
        level: 4,
        courseID: 103,
        progress: 0.0),
    LessonModel(
        lessonID: 8,
        lessonName: "Writing Skills",
        content: "Improve writing through exercises.",
        attachments: "assets/images/image8.jpg",
        level: 4,
        courseID: 103,
        progress: 0.0),
    LessonModel(
        lessonID: 9,
        lessonName: "Listening Practice",
        content: "Improve listening comprehension.",
        attachments: "assets/images/image9.jpg",
        level: 3,
        courseID: 102,
        progress: 0.0),
    LessonModel(
        lessonID: 10,
        lessonName: "Business English",
        content: "English for business settings.",
        attachments: "assets/images/image10.jpg",
        level: 5,
        courseID: 104,
        progress: 0.0),
  ];
}