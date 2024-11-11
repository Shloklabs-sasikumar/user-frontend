import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service class for handling local notifications related to timer status.
class TimerNotificationService {
  // Private constructor for singleton implementation.
  TimerNotificationService._notificationService();

  // The single instance of [TimerNotificationService].
  static final TimerNotificationService _instance = TimerNotificationService._notificationService();

  /// Factory constructor to return the single instance.
  factory TimerNotificationService() {
    return _instance;
  }

  // Instance of the Flutter local notifications plugin.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Initializes the local notification settings for the app.
  void initializeNotification() {
    // Define Android-specific initialization settings using the app's launcher icon.
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Define initialization settings for different platforms (only Android in this case).
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Initialize the local notifications plugin with the specified settings.
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Create the notification channel for Android.
    _createNotificationChannel();
  }

  /// Creates a notification channel for Android to send notifications with high importance.
  void _createNotificationChannel() {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'timer_notifications_channel', // Unique ID for the notification channel.
      'Timer Service Notifications', // Human-readable name for the channel.
      description: 'This channel is used for notifications related to the timer service.',
      importance: Importance.high, // Set the importance to high for prominent display.
    );

    // Create the notification channel on Android devices.
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Displays a notification showing the current status of the timer.
  ///
  /// [status]: The message to be displayed in the notification.
  /// [persist]: If true, the notification will be ongoing (sticky).
  Future<void> showTimerStatusNotification({
    required String status,
    bool persist = false,
  }) async {
    // Define the notification details for Android.
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'timer_notifications_channel', // Channel ID matching the created channel.
      'Timer Service Notifications', // Channel name for display purposes.
      channelDescription: 'Notifications for the timer service.',
      importance: Importance.max, // Maximum importance for visibility.
      priority: Priority.high, // High priority to show the notification immediately.
      ongoing: persist, // If true, the notification will be non-dismissible.
    );

    // Define platform-specific notification details.
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Show the notification with the provided details.
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID (unique identifier for this notification).
      'Timer Status', // Title of the notification.
      status, // Body of the notification showing the timer status.
      platformChannelSpecifics, // Details for platform-specific customization.
    );
  }
}
