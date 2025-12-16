import 'package:english_learning_app/constrants/app_constrants.dart';
import 'package:english_learning_app/models/exam_model.dart';
import 'package:english_learning_app/models/vocabulary_model.dart';
import 'package:english_learning_app/services/notification_service.dart';
import 'package:english_learning_app/view_model/exam_detail_viewmodel.dart';
import 'package:english_learning_app/view_model/exam_list_viewmodel.dart';
import 'package:english_learning_app/view_model/lesson_viewmodel.dart';
import 'package:english_learning_app/view_model/my_course_viewmodel.dart';
import 'package:english_learning_app/view_model/practice_2_viewmodel.dart';
import 'package:english_learning_app/view_model/practice_3_viewmodel.dart';
import 'package:english_learning_app/view_model/statistics_score_viewmodel.dart';
import 'package:english_learning_app/view_model/translate_viewmodel.dart';
import 'package:english_learning_app/view_model/vocabulary_viewmodel.dart';
import 'package:english_learning_app/view_model/attendance_viewmodel.dart';
import 'package:english_learning_app/views/screens/get_start_screen.dart';
import 'package:english_learning_app/views/screens/splash_screen.dart';
import 'package:english_learning_app/views/screens/student/chat_ai_screen.dart';
import 'package:english_learning_app/views/screens/student/course_screen.dart';
import 'package:english_learning_app/views/screens/login_screen.dart';
import 'package:english_learning_app/views/screens/student/home_student_screen.dart';
import 'package:english_learning_app/views/screens/student/my_vocabulary_screen.dart';
import 'package:english_learning_app/views/screens/profile_screen.dart';
import 'package:english_learning_app/views/screens/student/reminder_screen.dart';
import 'package:english_learning_app/views/screens/student/speaking_topic_screen.dart';
import 'package:english_learning_app/views/screens/student/statistics_screen.dart';
import 'package:english_learning_app/views/screens/student/translate_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'localization/app_localizations.dart';
import 'localization/locale_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService.init();
  Gemini.init(apiKey: GEMINI_API_KEY);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => TranslateViewModel()),
        ChangeNotifierProvider(create: (_) => MyCourseViewmodel()),
        ChangeNotifierProvider(create: (_) => LessonViewModel()),
        ChangeNotifierProvider(create: (_) => VocabularyViewmodel()),
        ChangeNotifierProvider(create: (_) => ExamListViewmodel()),
        ChangeNotifierProvider(create: (_) => StatisticsScoreViewmodel()),
        ChangeNotifierProvider(create: (_) => AttendanceViewModel()), // Thêm provider này
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
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'English Learning App',
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
        Locale('ko'),
        Locale('ja'),
      ],
      localizationsDelegates: const [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/student': (context) => StudentNavigation(),
        '/my-vocabulary': (context) => MyVocabularyScreen(),
        '/speaking-practice': (context) => SpeakingTopicScreen(),
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
    SpeakingTopicScreen(),
    TranslateScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    var loc = AppLocalizations.of(context);
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
            onDestinationSelected: (i) => setState(() => _selectedIndex = i),
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: loc.tr("home"),
              ),
              NavigationDestination(
                icon: Icon(Icons.class_),
                label: loc.tr("course"),
              ),
              NavigationDestination(
                icon: Icon(Icons.mic),
                label: loc.tr("speaking"),
              ),
              NavigationDestination(
                icon: Icon(Icons.translate),
                label: loc.tr("translate"),
              ),
              NavigationDestination(
                icon: Icon(Icons.person),
                label: loc.tr("profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
