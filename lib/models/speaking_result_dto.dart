class SpeakingResultDTO {
  final int sentenceId;
  final String userText;

  SpeakingResultDTO({
    required this.sentenceId,
    required this.userText,
  });

  Map<String, dynamic> toJson() => {
    "sentenceId": sentenceId,
    "userText": userText,
  };
}

class SpeakingCompareResponse {
  final double similarity;
  final String expected;
  final bool correct;
  final String feedback;

  SpeakingCompareResponse({
    required this.similarity,
    required this.expected,
    required this.correct,
    required this.feedback,
  });

  factory SpeakingCompareResponse.fromJson(Map<String, dynamic> json) {
    return SpeakingCompareResponse(
      similarity: (json['similarity'] ?? 0).toDouble(),
      expected: json['expected'] ?? "",
      correct: json['correct'] ?? false,
      feedback: json['feedback'] ?? "",
    );
  }
}