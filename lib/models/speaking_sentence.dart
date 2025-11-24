class SpeakingSentence {
  final int id;
  final String sentenceEn;
  final int orderIndex;

  SpeakingSentence({
    required this.id,
    required this.sentenceEn,
    required this.orderIndex,
  });

  factory SpeakingSentence.fromJson(Map<String, dynamic> json) {
    return SpeakingSentence(
      id: json["id"],
      sentenceEn: json["sentenceEn"],
      orderIndex: json["orderIndex"],
    );
  }
}
