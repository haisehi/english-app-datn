import 'package:carousel_slider/carousel_slider.dart';
import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/models/course_model.dart';
import 'package:english_learning_app/models/reminder_model.dart';
import 'package:english_learning_app/services/reminder_service.dart';
import 'package:english_learning_app/view_model/my_course_viewmodel.dart';
import 'package:english_learning_app/view_model/attendance_viewmodel.dart';
import 'package:english_learning_app/views/component/section_header.dart';
import 'package:english_learning_app/views/widget/dialog/show_join_course_dialog.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_learning_app/models/latest_lesson_model.dart';
import 'package:english_learning_app/services/latest_lesson_service.dart';


class HomeStudentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeStudentState();
}

class _HomeStudentState extends State<HomeStudentScreen> {
  final TextEditingController _controller = TextEditingController();
  String _searchText = '';
  final ReminderViewModel _viewModel = ReminderViewModel();
  Reminder? _nextReminder;
  LatestLesson? _latestLesson;
  final _latestLessonService = LatestLessonService();


  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserDataAndInit();
  }


  Future<void> _loadUserDataAndInit() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("id_user");

    if (userId == null) {
      print("⚠️ Không tìm thấy id_user trong SharedPreferences!");
      return;
    }

    setState(() {
      _currentUserId = userId;
    });

    await _loadAllCourse();
    await _loadNextReminder();
    await _loadAttendance(userId);
    await _loadLatestLesson();
  }

  Future<void> _loadLatestLesson() async {
    final lesson = await _latestLessonService.fetchLatestLesson();
    if (mounted) {
      setState(() {
        _latestLesson = lesson;
      });
    }
  }

  Future<void> _loadAttendance(int userId) async {
    final attendanceVM = Provider.of<AttendanceViewModel>(context, listen: false);
    await attendanceVM.fetchHistory(userId);
    await attendanceVM.fetchStreak(userId);
    setState(() {});
  }

  Future<void> _loadNextReminder() async {
    final reminders = await _viewModel.loadReminders();
    if (reminders.isNotEmpty) {
      reminders.sort((a, b) => a.time.compareTo(b.time));
      final now = DateTime.now();
      final upcomingReminders = reminders.where((r) => r.time.isAfter(now)).toList();
      setState(() {
        _nextReminder = upcomingReminders.isNotEmpty ? upcomingReminders.first : null;
      });
    }
  }

  Future<void> _loadAllCourse() async {
    await Future.microtask(() =>
        Provider.of<MyCourseViewmodel>(context, listen: false).fetchAllCourses());
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ngày ${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  final List<String> imgList = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
  ];

  List<CourseModel> courses = CourseModel.getCourses();

  @override
  Widget build(BuildContext context) {
    final courseViewModel = Provider.of<MyCourseViewmodel>(context);
    final attendanceVM = Provider.of<AttendanceViewModel>(context);

    List<CourseModel> unattendedCourses = courseViewModel.courses
        .where((course) => course.enrollmentStatus == 'NOT_ENROLLED')
        .toList();

    List<DateTime> attendanceDates = attendanceVM.history.map((e) {
      try {
        DateTime dt = DateTime.parse(e.attendanceDate);
        return DateTime(dt.year, dt.month, dt.day);
      } catch (_) {
        final parts = e.attendanceDate.split(RegExp(r'[-/]'));
        if (parts.length == 3) {
          return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
        } else {
          return DateTime.now();
        }
      }
    }).toList();

    return SafeArea(
      child: Scaffold(
        body: _currentUserId == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: AppColors.background),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🔍 Thanh tìm kiếm
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm...',
                        prefixIcon: Icon(Icons.search, color: AppColors.primary),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppColors.primaryDark, width: 2.0),
                        ),
                      ),
                      onChanged: (text) => setState(() => _searchText = text),
                    ),
                  ),

                  // 🖼 Slider
                  CarouselSlider(
                    items: imgList
                        .map((item) => ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(item, fit: BoxFit.cover, width: 1000),
                    ))
                        .toList(),
                    options: CarouselOptions(
                      height: 200.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                  ),

                  SectionHeader("Bài học gần nhất của bạn"),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE8F3FF), Color(0xFFF7F9FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _latestLesson == null
                        ? Center(
                      child: Text(
                        "Chưa có bài học nào gần đây",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                        : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 📘 Thông tin bài học
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _latestLesson!.lessonName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Tiến độ học của bạn đang rất tốt!",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 14),

                              // 🌟 Nút “Tiếp tục học” có gradient
                              Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF0050FF), // Blue pastel
                                      Color(0xFF0050FF), // Lavender
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF8EC5FC).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/lesson-detail', arguments: {
                                      'lessonId': _latestLesson!.lessonId,
                                      'courseId': _latestLesson!.courseId,
                                    });
                                  },
                                  icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                                  label: const Text(
                                    "Tiếp tục học",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 🌈 Vòng tròn tiến trình gradient
                        CircularPercentIndicator(
                          radius: 45.0,
                          lineWidth: 10.0,
                          percent: (_latestLesson!.progress / 100).clamp(0, 1),
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(
                            "${_latestLesson!.progress.toStringAsFixed(0)}%",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          backgroundColor: Colors.grey.shade200,
                          linearGradient: const LinearGradient(
                            colors: [
                              Color(0xFF62D2A2), // mint
                              Color(0xFF8EC5FC), // blue pastel
                              Color(0xFFE0C3FC), // lavender
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          animation: true,
                          animationDuration: 800,
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),



                  // 🔔 Hoạt động tiếp theo
                  SectionHeader("Hoạt động tiếp theo"),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey.shade300, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: _nextReminder == null
                        ? Center(child: Text('Không có nhắc nhở nào sắp tới', style: TextStyle(fontSize: 16)))
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nhắc nhở: ${_nextReminder!.content}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Thời gian: ${_formatDateTime(_nextReminder!.time)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),

                  // 📅 Lịch điểm danh
                  SectionHeader("Lịch điểm danh"),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
                      ],
                    ),
                    child: attendanceDates.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Chưa có dữ liệu điểm danh",
                          style: TextStyle(fontSize: 14, color: Colors.black54)),
                    )
                        : TableCalendar(
                      firstDay: DateTime.utc(2024, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      calendarFormat: CalendarFormat.week,
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      headerStyle: HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false,
                        titleTextStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.primary),
                        rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.primary),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(fontSize: 12, color: Colors.black54),
                        weekendStyle: TextStyle(fontSize: 12, color: Colors.redAccent),
                      ),
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, _) {
                          bool isMarked = attendanceDates.any((d) =>
                          d.year == day.year && d.month == day.month && d.day == day.day);
                          bool isToday = isSameDay(day, DateTime.now());
                          return _buildDayCell(day, isMarked, isToday: isToday);
                        },
                        todayBuilder: (context, day, _) {
                          bool isMarked = attendanceDates.any((d) =>
                          d.year == day.year && d.month == day.month && d.day == day.day);
                          return _buildDayCell(day, isMarked, isToday: true);
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // 📘 Các khóa học có thể tham gia
                  SectionHeader("Các khóa học"),
                  SizedBox(height: 12),
                  Container(
                    constraints: BoxConstraints(maxHeight: 280),
                    child: unattendedCourses.isEmpty
                        ? Center(child: Text("Không có khóa học nào khả dụng"))
                        : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: unattendedCourses.length,
                      itemBuilder: (context, index) {
                        final course = unattendedCourses[index];
                        return GestureDetector(
                          onTap: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (context) => ShowJoinCourseDialog(course.courseID),
                            );
                            if (result != null && result['success'] == true) {
                              _loadAllCourse();
                            }
                          },
                          child: Container(
                            width: 200,
                            margin: EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                  child: Image.asset(
                                    'assets/images/image${(index % 3) + 1}.jpg',
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 40, // chiều cao đủ cho 2 dòng (tuỳ chỉnh 38–45 tuỳ font size)
                                        child: Text(
                                          course.courseName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                            height: 1.2, // khoảng cách giữa các dòng, giúp không tràn
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(Icons.people_alt_outlined,
                                              size: 18, color: AppColors.primaryDark),
                                          SizedBox(width: 6),
                                          Text(
                                            "Tối đa: ${course.maxQuantity}",
                                            style: TextStyle(fontSize: 13, color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final result = await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  ShowJoinCourseDialog(course.courseID),
                                            );
                                            if (result != null && result['success'] == true) {
                                              _loadAllCourse();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primaryDark,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Text(
                                            'Tham gia',
                                            style: TextStyle(color: Colors.white, fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/chat-ai');
          },
          backgroundColor: AppColors.primary,
          shape: CircleBorder(),
          child: Icon(Icons.chat, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDayCell(DateTime day, bool isMarked, {bool isToday = false}) {
    const primaryColor = Color(0xFF2475FC);
    Color bgColor;

    if (isMarked) {
      bgColor = Colors.redAccent;
    } else if (isToday) {
      bgColor = primaryColor.withOpacity(0.3);
    } else {
      bgColor = Colors.transparent;
    }

    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: isToday && !isMarked ? Border.all(color: primaryColor, width: 2) : null,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: isMarked ? Colors.white : Colors.black87,
          fontWeight: (isMarked || isToday) ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }
}
