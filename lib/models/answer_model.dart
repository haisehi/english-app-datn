class AnswerModel {
  final int answerID;
  final String answerContent;
  final int answerCorrect;
  final int questionID;

  AnswerModel(
      {required this.answerID,
      required this.answerContent,
      required this.answerCorrect,
      required this.questionID});

  // Phương thức factory để chuyển đổi từ JSON thành AnswerModel
  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      answerID: json['answerId'],
      answerContent: json['content'],
      answerCorrect: int.tryParse(json['correctAnswer'])?? 0,
      questionID: json['id'],
    );
  }
  // Phương thức chuyển đổi AnswerModel sang JSON
  Map<String, dynamic> toJson() {
    return {
      'answerId': answerID,
      'correctAnswer': answerCorrect,
      'content': answerContent,
      'questionId': questionID,
    };
  }
}