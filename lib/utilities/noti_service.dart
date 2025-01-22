import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
}
