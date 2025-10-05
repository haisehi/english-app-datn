import 'package:english_learning_app/models/answer_model.dart';

class QuestionModel {
    final int questionID;
    final String content;
    final String? attachments;
    final String type;
    final double score;
    final int testId;
    final List<AnswerModel> answerOptions;

    // Constructor
    QuestionModel({
        required this.questionID,
        required this.content,
        this.attachments,
        required this.type,
        required this.score,
        required this.testId,
        required this.answerOptions,
    });

    // Factory method to create a QuestionModel from JSON
    factory QuestionModel.fromJson(Map<String, dynamic> json) {
        return QuestionModel(
            questionID: json['id'] as int,
            content: json['content'] as String,
            attachments: json['attachments'] ?? "",
            type: json['type'] as String,
            score: double.tryParse(json['score']?.toString() ?? '0') ?? 0.0,
            testId: json['testId'] as int,
            answerOptions: (json['answerOptions'] as List<dynamic>)
                .map((answer) => AnswerModel.fromJson(answer))
                .toList(),
        );
    }

    // Method to convert a QuestionModel to JSON
    Map<String, dynamic> toJson() {
        return {
            'id': questionID,
            'content': content,
            'attachments': attachments,
            'type': type,
            'score': score.toString(),
            'testId': testId,
            'answerOptions': answerOptions.map((answer) => answer.toJson()).toList(),
        };
    }

    // Static list of sample questions
    static final List<QuestionModel> questions = [
        QuestionModel(
            questionID: 1,
            content: 'Câu hỏi 1: "Apple" trong tiếng Anh có nghĩa là gì?',
            attachments: null,
            type: 'trac-nghiem',
            score: 1.0,
            testId: 101,
            answerOptions: [
                AnswerModel(answerID: 1, answerContent: 'Táo', answerCorrect: 1, questionID: 1),
                AnswerModel(answerID: 2, answerContent: 'Chuối', answerCorrect: 0, questionID: 1),
                AnswerModel(answerID: 3, answerContent: 'Cam', answerCorrect: 0, questionID: 1),
                AnswerModel(answerID: 4, answerContent: 'Dưa hấu', answerCorrect: 0, questionID: 1),
            ],
        ),
        QuestionModel(
            questionID: 2,
            content:
            'Câu hỏi 2: "She ___ to the park every day." Chọn từ đúng để điền vào chỗ trống.',
            attachments: null,
            type: 'trac-nghiem',
            score: 1.0,
            testId: 101,
            answerOptions: [
                AnswerModel(answerID: 5, answerContent: 'goes', answerCorrect: 1, questionID: 2),
                AnswerModel(answerID: 6, answerContent: 'going', answerCorrect: 0, questionID: 2),
                AnswerModel(answerID: 7, answerContent: 'gone', answerCorrect: 0, questionID: 2),
                AnswerModel(answerID: 8, answerContent: 'to go', answerCorrect: 0, questionID: 2),
            ],
        ),
        // Thêm các câu hỏi khác tương tự
    ];

}
