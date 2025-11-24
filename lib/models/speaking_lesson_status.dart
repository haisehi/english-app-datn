class SpeakingLessonStatus {
  final int lessonId;
  final String title;
  final String description;
  final bool joined;

  SpeakingLessonStatus({
    required this.lessonId,
    required this.title,
    required this.description,
    required this.joined,
  });

  factory SpeakingLessonStatus.fromJson(Map<String, dynamic> json) {
    return SpeakingLessonStatus(
      lessonId: json["lessonId"],
      title: json["title"],
      description: json["description"],
      joined: json["joined"] ?? false,
    );
  }
}
