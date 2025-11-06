class LatestLesson {
  final int lessonId;
  final String lessonName;
  final String content;
  final String? attachments;
  final int level;
  final int courseId;
  final double progress;

  LatestLesson({
    required this.lessonId,
    required this.lessonName,
    required this.content,
    this.attachments,
    required this.level,
    required this.courseId,
    required this.progress,
  });

  factory LatestLesson.fromJson(Map<String, dynamic> json) {
    return LatestLesson(
      lessonId: json['lessonId'],
      lessonName: json['lessonName'],
      content: json['content'] ?? '',
      attachments: json['attachments'],
      level: json['level'] ?? 0,
      courseId: json['courseId'] ?? 0,
      progress: (json['progress'] ?? 0).toDouble(),
    );
  }
}
