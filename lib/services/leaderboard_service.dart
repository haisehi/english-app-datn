import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constrants/app_constrants.dart';
import '../models/leaderboard_model.dart';

class LeaderboardService {
  final String baseUrl = "$apiUrl/user-test/leaderboard";
  // final String baseUrl = "http://192.168.1.205:8080/api/v1/user-test/leaderboard";
  // ⚠️ Đổi sang API thật của bạn, ví dụ: "http://192.168.1.10:8080/api/leaderboard"

  Future<List<LeaderboardModel>> fetchLeaderboard() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => LeaderboardModel.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load leaderboard");
    }
  }
}
