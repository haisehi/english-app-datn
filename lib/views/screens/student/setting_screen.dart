import 'package:english_learning_app/localization/locale_provider.dart';
import 'package:english_learning_app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_learning_app/localization/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TimeOfDay _selectedTime = const TimeOfDay(hour: 19, minute: 0);
  List<int> _selectedDays = [];
  bool _reminderEnabled = false;
  bool _loaded = false;

  final Map<int, String> weekdays = {
    1: "Mon",
    2: "Tue",
    3: "Wed",
    4: "Thu",
    5: "Fri",
    6: "Sat",
    7: "Sun",
  };

  @override
  void initState() {
    super.initState();
    _loadReminderSetting();
  }

  /// 🔄 LOAD SETTING
  Future<void> _loadReminderSetting() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _reminderEnabled = prefs.getBool('reminder_enabled') ?? false;
      final hour = prefs.getInt('reminder_hour') ?? 19;
      final minute = prefs.getInt('reminder_minute') ?? 0;
      _selectedTime = TimeOfDay(hour: hour, minute: minute);
      _selectedDays =
          prefs.getStringList('reminder_days')?.map(int.parse).toList() ?? [];
      _loaded = true;
    });
  }

  /// 💾 SAVE SETTING
  Future<void> _saveReminderSetting() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminder_enabled', _reminderEnabled);
    await prefs.setInt('reminder_hour', _selectedTime.hour);
    await prefs.setInt('reminder_minute', _selectedTime.minute);
    await prefs.setStringList(
      'reminder_days',
      _selectedDays.map((e) => e.toString()).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    var loc = AppLocalizations.of(context);
    final provider = Provider.of<LocaleProvider>(context);

    String getLanguageName(String code) {
      switch (code) {
        case "vi":
          return "Tiếng Việt";
        case "en":
          return "English";
        case "ja":
          return "日本語";
        case "ko":
          return "한국어";
        default:
          return "English";
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(loc.tr("setting"))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// ===== LANGUAGE =====
            ListTile(
              title: Text(loc.tr("choose_language")),
              subtitle: Text(getLanguageName(provider.locale.languageCode)),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text("Tiếng Việt"),
                        onTap: () => provider.setLocale(const Locale('vi')),
                      ),
                      ListTile(
                        title: const Text("English"),
                        onTap: () => provider.setLocale(const Locale('en')),
                      ),
                      ListTile(
                        title: const Text("日本語"),
                        onTap: () => provider.setLocale(const Locale('ja')),
                      ),
                      ListTile(
                        title: const Text("한국어"),
                        onTap: () => provider.setLocale(const Locale('ko')),
                      ),
                    ],
                  ),
                );
              },
            ),

            const Divider(),

            /// ===== REMINDER =====
            SwitchListTile(
              title: const Text("Nhắc học tiếng Anh"),
              value: _reminderEnabled,
              onChanged: (val) async {
                setState(() => _reminderEnabled = val);
                await _saveReminderSetting();

                if (!val) {
                  await NotificationService.cancelAll();
                }
              },
            ),

            ListTile(
              title: const Text("Chọn giờ học"),
              subtitle: Text(_selectedTime.format(context)),
              onTap: !_reminderEnabled
                  ? null
                  : () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (time != null) {
                  setState(() => _selectedTime = time);
                  await _saveReminderSetting();
                }
              },
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                children: weekdays.entries.map((e) {
                  final selected = _selectedDays.contains(e.key);
                  return FilterChip(
                    label: Text(e.value),
                    selected: selected,
                    onSelected: !_reminderEnabled
                        ? null
                        : (val) async {
                      setState(() {
                        val
                            ? _selectedDays.add(e.key)
                            : _selectedDays.remove(e.key);
                      });
                      await _saveReminderSetting();
                    },
                  );
                }).toList(),
              ),
            ),

            ElevatedButton(
              onPressed: _reminderEnabled && _selectedDays.isNotEmpty
                  ? () async {
                await NotificationService.scheduleReminder(
                  hour: _selectedTime.hour,
                  minute: _selectedTime.minute,
                  weekdays: _selectedDays,
                );

                await _saveReminderSetting();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Đã bật nhắc học thành công"),
                  ),
                );
              }
                  : null,
              child: const Text("Lưu nhắc học"),
            ),
          ],
        ),
      ),
    );
  }
}
