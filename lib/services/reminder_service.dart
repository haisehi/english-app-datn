import 'package:english_learning_app/models/reminder_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class ReminderViewModel {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  ReminderViewModel() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleReminder(Reminder reminder) async {
    final androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Channel for reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      0, // ID của thông báo
      'Nhắc nhở',
      reminder.content,
      _convertToTZDateTime(reminder.time), // Sử dụng hàm chuyển đổi
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
  Future<void> initTimezone() async {
    tz.initializeTimeZones();
  }

  tz.TZDateTime _convertToTZDateTime(DateTime dateTime) {
    final location = tz.local;
    return tz.TZDateTime.from(dateTime, location);
  }
  Future<void> saveReminders(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final reminderList = reminders.map((r) => r.toJson()).toList();
    prefs.setString('reminders', jsonEncode(reminderList));
  }

  Future<List<Reminder>> loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersString = prefs.getString('reminders');
    if (remindersString == null) return [];
    final reminderList = jsonDecode(remindersString) as List;
    return reminderList.map((json) => Reminder.fromJson(json)).toList();
  }
  Future<void> cancelReminder(int notificationId) async {
    await _notificationsPlugin.cancel(notificationId);
  }
}
