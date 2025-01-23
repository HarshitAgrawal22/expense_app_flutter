import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return; // Prevent re-initialization

    // Prepare Android initialization settings
    const initSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const initSettings = InitializationSettings(android: initSettingsAndroid);

    await notificationPlugin.initialize(
      initSettings,
    );
    _isInitialized = true; // Mark as initialized
    print("NotificationService initialized");
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "daily_channel_id", // Channel ID
        "Daily Notifications", // Channel name
        channelDescription: "Daily Notification Channel", // Channel description
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    if (!_isInitialized) {
      await initNotification(); // Ensure notifications are initialized
    }

    print("Attempting to show notification: $title - $body");
    return notificationPlugin.show(
      id,
      title,
      body,
      notificationDetails(), // Use the configured notification details
    );
  }

  Future<void> scheduleReminderNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // Ensure the scheduled time is in the future
    final now = DateTime.now();
    if (scheduledTime.isBefore(now)) {
      throw ArgumentError(
        'Scheduled time must be in the future: $scheduledTime',
      );
    }

    // Initialize time zones if not already done
    tz.initializeTimeZones();

    // Schedule the notification
    await notificationPlugin.zonedSchedule(
      0, // Notification ID
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel', // Channel ID
          'Reminders', // Channel Name
          channelDescription: 'This channel is for reminder notifications.',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      final status = await Permission.scheduleExactAlarm.request();
      if (!status.isGranted) {
        throw Exception('Exact alarms permission not granted');
      }
    }
  }
}



                // Padding(
                //   padding: EdgeInsets.symmetric(
                //     vertical: MediaQuery.sizeOf(context).height / 30,
                //   ),
                //   child: MaterialButton(
                //     onPressed: () {
                //       NotificationService()
                //           .showNotification(title: "billo", body: "rani");
                //     },
                //     // height: MediaQuery.sizeOf(context).height / 5,
                //     color: Colors.grey[800],
                //     child: Text(
                //       "See All Transactions ->",
                //       style: TextStyle(color: Colors.white),
                //     ),
                //   ),
                // ),