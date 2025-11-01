import 'package:english_learning_app/constrants/app_constrants.dart';
import 'package:english_learning_app/models/exam_model.dart';
import 'package:english_learning_app/models/vocabulary_model.dart';
import 'package:english_learning_app/view_model/exam_detail_viewmodel.dart';
import 'package:english_learning_app/view_model/exam_list_viewmodel.dart';
import 'package:english_learning_app/view_model/lesson_viewmodel.dart';
import 'package:english_learning_app/view_model/my_course_viewmodel.dart';
import 'package:english_learning_app/view_model/practice_2_viewmodel.dart';
import 'package:english_learning_app/view_model/practice_3_viewmodel.dart';
import 'package:english_learning_app/view_model/statistics_score_viewmodel.dart';
import 'package:english_learning_app/view_model/translate_viewmodel.dart';
import 'package:english_learning_app/view_model/vocabulary_viewmodel.dart';
import 'package:english_learning_app/view_model/attendance_viewmodel.dart'; // ✅ Thêm dòng này
import 'package:english_learning_app/views/screens/get_start_screen.dart';
import 'package:english_learning_app/views/screens/splash_screen.dart';
import 'package:english_learning_app/views/screens/student/chat_ai_screen.dart';
import 'package:english_learning_app/views/screens/student/course_screen.dart';
import 'package:english_learning_app/views/screens/login_screen.dart';
import 'package:english_learning_app/views/screens/student/home_student_screen.dart';
import 'package:english_learning_app/views/screens/student/my_vocabulary_screen.dart';
import 'package:english_learning_app/views/screens/profile_screen.dart';
import 'package:english_learning_app/views/screens/student/reminder_screen.dart';
import 'package:english_learning_app/views/screens/student/speaking_practice_screen.dart';
import 'package:english_learning_app/views/screens/student/statistics_screen.dart';
import 'package:english_learning_app/views/screens/student/translate_screen.dart';
import 'package:english_learning_app/views/screens/teacher/course_management_screen.dart';
import 'package:english_learning_app/views/screens/teacher/home_teacher_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  Gemini.init(apiKey: GEMINI_API_KEY);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TranslateViewModel()),
        ChangeNotifierProvider(create: (_) => MyCourseViewmodel()),
        ChangeNotifierProvider(create: (_) => LessonViewModel()),
        ChangeNotifierProvider(create: (_) => VocabularyViewmodel()),
        ChangeNotifierProvider(create: (_) => ExamListViewmodel()),
        ChangeNotifierProvider(create: (_) => StatisticsScoreViewmodel()),
        ChangeNotifierProvider(create: (_) => AttendanceViewModel()), // ✅ Thêm provider này
        Provider<ExamDetailViewmodel>(create: (_) => ExamDetailViewmodel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'English Learning App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/student': (context) => StudentNavigation(),
        '/teacher': (context) => TeacherNavigation(),
        '/my-vocabulary': (context) => MyVocabularyScreen(),
        '/speaking-practice': (context) => SpeakingPracticeScreen(),
        '/get-start': (context) => GetStartScreen(),
        '/reminder': (context) => ReminderScreen(),
        '/chat-ai': (context) => ChatAiScreen(),
      },
    );
  }
}

class StudentNavigation extends StatefulWidget {
  const StudentNavigation({super.key});

  @override
  _StudentNavigationState createState() => _StudentNavigationState();
}

class _StudentNavigationState extends State<StudentNavigation> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    HomeStudentScreen(),
    CourseScreen(),
    SpeakingPracticeScreen(),
    TranslateScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.white,
            indicatorColor: Colors.deepPurple.shade100,
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            iconTheme: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return const IconThemeData(color: Colors.deepPurple);
              }
              return const IconThemeData(color: Colors.grey);
            }),
            elevation: 3,
            height: 70,
            surfaceTintColor: Colors.white,
          ),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: "Trang chủ",
              ),
              NavigationDestination(
                icon: Icon(Icons.class_outlined),
                selectedIcon: Icon(Icons.class_rounded),
                label: "Khóa học",
              ),
              NavigationDestination(
                icon: Icon(Icons.record_voice_over_outlined),
                selectedIcon: Icon(Icons.record_voice_over),
                label: "Luyện nói",
              ),
              NavigationDestination(
                icon: Icon(Icons.translate_outlined),
                selectedIcon: Icon(Icons.translate_rounded),
                label: "Dịch",
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: "Hồ sơ",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeacherNavigation extends StatefulWidget {
  const TeacherNavigation({super.key});

  @override
  _TeacherNavigationState createState() => _TeacherNavigationState();
}

class _TeacherNavigationState extends State<TeacherNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeTeacherScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Trang chủ"),
          NavigationDestination(icon: Icon(Icons.person), label: "Hồ sơ"),
        ],
      ),
    );
  }
}
