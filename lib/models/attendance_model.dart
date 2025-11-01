class AttendanceModel {
  final int id;
  final String attendanceDate;
  final String status;
  final int userId;

  AttendanceModel({
    required this.id,
    required this.attendanceDate,
    required this.status,
    required this.userId,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] ?? 0,
      attendanceDate: json['attendance_date'] ?? '',
      status: json['status'] ?? 'present',
      userId: json['user_id'] ?? 0,
    );
  }
}
