import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_learning_app/view_model/attendance_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceScreen extends StatefulWidget {
  final int userId;
  const AttendanceScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _hasMarkedToday = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    final viewModel = Provider.of<AttendanceViewModel>(context, listen: false);
    await viewModel.fetchStreak(widget.userId);
    await viewModel.fetchHistory(widget.userId);

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _hasMarkedToday = viewModel.history
        .any((att) => att.attendanceDate.startsWith(today));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2475FC);

    return Consumer<AttendanceViewModel>(
      builder: (context, viewModel, child) {
        /// ✅ Chuyển chuỗi ngày về dạng DateTime
        final attendedDays = viewModel.history.map((att) {
          try {
            return DateTime.parse(att.attendanceDate);
          } catch (e) {
            return DateTime.tryParse(att.attendanceDate.split('T')[0]) ??
                DateTime.now();
          }
        }).toList();

        print("✅ attendedDays: $attendedDays"); // Debug log

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              "Điểm danh học tập",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: primaryColor),
          ),
          body: viewModel.isLoading
              ? const Center(
            child: CircularProgressIndicator(color: primaryColor),
          )
              : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                /// Animation
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: _hasMarkedToday
                      ? Lottie.asset(
                    'assets/animations/Trophy.json',
                    key: const ValueKey('done'),
                    width: 200,
                    repeat: false,
                  )
                      : Lottie.asset(
                    'assets/animations/Handy Machine Learning Animation.json',
                    key: const ValueKey('notDone'),
                    width: 200,
                    repeat: true,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  _hasMarkedToday
                      ? "🎉 Hôm nay bạn đã điểm danh rồi!"
                      : "Chúc mừng bạn hoàn thành bài học hôm nay!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),

                const SizedBox(height: 20),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutBack,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: primaryColor.withOpacity(0.4)),
                  ),
                  child: Text(
                    "🔥 Chuỗi học liên tiếp: ${viewModel.streak} ngày",
                    style: const TextStyle(
                      fontSize: 18,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: !_hasMarkedToday
                      ? ElevatedButton.icon(
                    key: const ValueKey('markButton'),
                    onPressed: () async {
                      await viewModel.markAttendance(widget.userId);
                      await _loadAttendanceData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Điểm danh thành công!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle_outline,
                        color: Colors.white),
                    label: const Text(
                      "Điểm danh hôm nay",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      : ElevatedButton.icon(
                    key: const ValueKey('backButton'),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                    label: const Text(
                      "Quay về",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "📅 Lịch sử điểm danh:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),

                  /// ✅ TableCalendar đã sửa
                  child: TableCalendar(
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) =>
                        isSameDay(_selectedDay, day),
                    calendarFormat: CalendarFormat.month,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, _) {
                        bool isAttended = attendedDays.any((d) =>
                        d.year == day.year &&
                            d.month == day.month &&
                            d.day == day.day);
                        return _buildDayCell(day, isAttended);
                      },
                      todayBuilder: (context, day, _) {
                        bool isAttended = attendedDays.any((d) =>
                        d.year == day.year &&
                            d.month == day.month &&
                            d.day == day.day);
                        return _buildDayCell(day, isAttended, isToday: true);
                      },
                      outsideBuilder: (context, day, _) {
                        bool isAttended = attendedDays.any((d) =>
                        d.year == day.year &&
                            d.month == day.month &&
                            d.day == day.day);
                        return _buildDayCell(day, isAttended, isOutside: true);
                      },
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: primaryColor,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ✅ Hàm tạo ô ngày có tô màu đỏ cho ngày điểm danh
  Widget _buildDayCell(DateTime day, bool isAttended,
      {bool isToday = false, bool isOutside = false}) {
    const primaryColor = Color(0xFF2475FC);

    Color bgColor;
    if (isAttended) {
      bgColor = Colors.blueAccent;
    } else if (isToday) {
      bgColor = primaryColor.withOpacity(0.5);
    } else {
      bgColor = Colors.grey.shade300;
    }

    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: isToday
            ? Border.all(color: primaryColor, width: 2)
            : null, // viền hôm nay
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: isAttended ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
