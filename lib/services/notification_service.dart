import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  /// 🔹 Call ONCE in main()
  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidInit,
    );

    await _notifications.initialize(initSettings);

    // Android 13+
    await _notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // ============================================================
  // 🧪 TEST: Thông báo sau 1 phút (DEBUG – BẮT BUỘC TEST)
  // ============================================================
  static Future<void> testNotificationIn1Minute() async {
    final scheduledTime =
    tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1));

    await _notifications.zonedSchedule(
      999999,
      'TEST Notification',
      'Nếu thấy cái này là OK 🎉',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Channel',
          channelDescription: 'Channel dùng để test notification',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ============================================================
  // 🔔 ĐẶT LỊCH NHẮC HỌC HÀNG TUẦN
  // ============================================================
  static Future<void> scheduleReminder({
    required int hour,
    required int minute,
    required List<int> weekdays, // 1 = Mon ... 7 = Sun
  }) async {
    for (int day in weekdays) {
      final scheduledTime = _nextInstanceOfWeekday(day, hour, minute);

      await _notifications.zonedSchedule(
        day, // id = weekday (đủ dùng)
        'Đến giờ học tiếng Anh!',
        'Học một chút mỗi ngày sẽ rất khác đó 🚀',
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'study_reminder',
            'Study Reminder',
            channelDescription: 'Nhắc học tiếng Anh hằng tuần',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  // ============================================================
  // 🧠 TÍNH THỜI GIAN NHẮC HỌC CHUẨN
  // ============================================================
  static tz.TZDateTime _nextInstanceOfWeekday(
      int weekday,
      int hour,
      int minute,
      ) {
    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Tìm ngày đúng weekday
    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    // Nếu thời gian đã qua → sang tuần sau
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }

    return scheduled;
  }

  // ============================================================
  // ❌ HUỶ TOÀN BỘ NHẮC HỌC
  // ============================================================
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
