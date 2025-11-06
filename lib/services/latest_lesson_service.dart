import 'dart:convert';
import 'package:english_learning_app/models/latest_lesson_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constrants/app_constrants.dart';

class LatestLessonService {
  final String baseUrl = "$apiUrl/user-lesson/latest";

  Future<LatestLesson?> fetchLatestLesson() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token'); // ✅ Sửa ở đây

      if (token == null || token.isEmpty) {
        print("⚠️ Token không tồn tại hoặc rỗng!");
        return null;
      }

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("📡 Request GET $baseUrl");
      print("🧾 Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return LatestLesson.fromJson(data);
      } else if (response.statusCode == 401) {
        print("🚫 Unauthorized – Token hết hạn hoặc sai định dạng");
      } else {
        print("⚠️ Fetch latest lesson failed: ${response.statusCode}");
      }
      return null;
    } catch (e) {
      print("❌ Error fetching latest lesson: $e");
      return null;
    }
  }
}
