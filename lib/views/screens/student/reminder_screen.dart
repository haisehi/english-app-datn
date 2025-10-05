import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/models/reminder_model.dart';
import 'package:english_learning_app/services/reminder_service.dart';
import 'package:english_learning_app/views/component/section_header.dart';
import 'package:flutter/material.dart';


class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final ReminderViewModel _viewModel = ReminderViewModel();
  final TextEditingController _contentController = TextEditingController();
  final List<Reminder> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final reminders = await _viewModel.loadReminders();
    setState(() {
      _reminders.addAll(reminders);
    });
  }

  Future<void> _addReminder() async {
    if (_contentController.text.isEmpty) return;

    final now = DateTime.now();
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    final reminder = Reminder(
      id: DateTime.now().millisecondsSinceEpoch % 2147483647,
      content: _contentController.text,
      time: DateTime(now.year, now.month, now.day, time.hour, time.minute),
    );

    setState(() {
      _reminders.add(reminder);
    });

    _contentController.clear();
    await _viewModel.scheduleReminder(reminder);
    await _viewModel.saveReminders(_reminders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhắc nhở học tập', style: TextStyle(color: AppColors.background.withOpacity(0.8)),),
        backgroundColor: AppColors.primaryDark,
        iconTheme: IconThemeData(color: AppColors.background),
        centerTitle: true,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thêm nhắc nhở mới', style: TextStyle(color: AppColors.primaryDark, fontSize: 18, fontWeight: FontWeight.bold),),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      labelText: 'Nội dung nhắc nhở',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addReminder,
                  child: Text('Thêm nhắc nhở', style: TextStyle(color: AppColors.background),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(12),
                    
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Text('Danh sách nhắc nhở học tập', style: TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Expanded(

              child: ListView.builder(
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
                  final reminder = _reminders[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                          Border.all(color: Color(0xFF342771), width: 1.0),
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFF4F4F9),
                              Color(0xFF342771),
                            ],
                            stops: [0.96, 0],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )),
                      child: ListTile(
                        title: Text(
                          reminder.content,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          reminder.time.toString(),
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteReminder(index),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
  Future<void> _deleteReminder(int index) async {
    final reminder = _reminders[index];
    setState(() {
      _reminders.removeAt(index);
    });
    await _viewModel.cancelReminder(reminder.id); // Hủy thông báo
    await _viewModel.saveReminders(_reminders);
  }
}
