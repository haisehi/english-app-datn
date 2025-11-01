import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../services/attendance_service.dart';

class AttendanceViewModel extends ChangeNotifier {
  final AttendanceService _service = AttendanceService();
  int _streak = 0;
  List<AttendanceModel> _history = [];
  bool _isLoading = false;

  int get streak => _streak;
  List<AttendanceModel> get history => _history;
  bool get isLoading => _isLoading;

  Future<void> markAttendance(int userId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _service.markAttendance(userId);
    if (result == "marked_successfully") {
      await fetchStreak(userId);
      await fetchHistory(userId);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchStreak(int userId) async {
    _streak = await _service.getStreak(userId);
    notifyListeners();
  }

  Future<void> fetchHistory(int userId) async {
    _history = await _service.getAttendanceHistory(userId);
    notifyListeners();
  }
}
