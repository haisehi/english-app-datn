class SpeakingSubmitResponse {
  final int id;
  final int lessonId;
  final int userId;
  final int totalCorrect;
  final int totalSentences;
  final bool isPass;
  final String createdAt;
  final int percent;

  SpeakingSubmitResponse({
    required this.id,
    required this.lessonId,
    required this.userId,
    required this.totalCorrect,
    required this.totalSentences,
    required this.isPass,
    required this.createdAt,
    required this.percent,
  });

  factory SpeakingSubmitResponse.fromJson(Map<String, dynamic> json) {
    return SpeakingSubmitResponse(
      id: json['id'],
      lessonId: json['lessonId'],
      userId: json['userId'],
      totalCorrect: json['totalCorrect'],
      totalSentences: json['totalSentences'],
      isPass: json['isPass'],
      createdAt: json['createdAt'],
      percent: json['percent'],
    );
  }
}
