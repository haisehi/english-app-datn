class SpeakingTopic {
  final int id;
  final String title;
  final String description;

  SpeakingTopic({
    required this.id,
    required this.title,
    required this.description,
  });

  factory SpeakingTopic.fromJson(Map<String, dynamic> json) {
    return SpeakingTopic(
      id: json["id"],
      title: json["title"],
      description: json["description"],
    );
  }
}
