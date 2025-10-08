class LeaderboardModel {
  final int rank;
  final int userId;
  final String fullName;
  final String email;
  final String avatar;
  final double totalScore;

  LeaderboardModel({
    required this.rank,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.avatar,
    required this.totalScore,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      rank: json['rank'],
      userId: json['userId'],
      fullName: json['fullName'],
      email: json['email'],
      avatar: json['avatar'] ?? "",
      totalScore: (json['totalScore'] as num).toDouble(),
    );
  }
}
