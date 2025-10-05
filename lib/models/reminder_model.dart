class Reminder {
  final int id; // ID duy nhất cho thông báo
  final String content;
  final DateTime time;

  Reminder({required this.id, required this.content, required this.time});

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'time': time.toIso8601String(),
  };

  static Reminder fromJson(Map<String, dynamic> json) => Reminder(
    id: json['id'],
    content: json['content'],
    time: DateTime.parse(json['time']),
  );
}
