import 'package:benchtask/app/core/notification/notification_service.dart';
import 'package:benchtask/app/feature/timer/infrastructure/data/datasource/timer_local_datasource.dart';
import 'package:workmanager/workmanager.dart';


/// Top-level function for the callback dispatcher.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Initialize necessary services and data sources.
      TimerDataSource dataSource = TimerDataSource();
      TimerNotificationService notificationService = TimerNotificationService();
      await dataSource.initlize();
      notificationService.initializeNotification();

      // Check if the timer is running or paused.
      String? isRunning = await dataSource.getStoredData('isRunning');
      Duration elapsed = Duration(seconds: int.tryParse(await dataSource.getStoredData('elapsed') ?? '0') ?? 0);

      if (isRunning == 'true') {
        // Timer is running, show a running notification.
        notificationService.showTimerStatusNotification(
          status: 'Timer running: ${elapsed.inHours}:${elapsed.inMinutes.remainder(60)}:${elapsed.inSeconds.remainder(60)}',
          persist: true,
        );
      } else {
        // Timer is paused, show a paused notification.
        notificationService.showTimerStatusNotification(
          status: 'Timer paused at: ${elapsed.inHours}:${elapsed.inMinutes.remainder(60)}:${elapsed.inSeconds.remainder(60)}',
          persist: false,
        );
      }

      return Future.value(true); // Indicate the task ran successfully.
    } catch (e) {
      // Log the error and return false.
      return Future.value(false);
    }
  });
}

/// A class responsible for managing background tasks related to observation images.


class WorkManager {
  // Singleton instance of WorkManager.
  static final WorkManager _instance = WorkManager._internal();

  /// Private constructor for singleton pattern.
  WorkManager._internal();

  /// Factory constructor to return the singleton instance.
  factory WorkManager() {
    return _instance;
  }

  /// Initializes the WorkManager, setting up the callback dispatcher and registering tasks.
  void initialize() {
    // Initialize the Workmanager with the callback dispatcher.
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true, // Enable debug mode for testing; set to false in production.
    );

    // Register a periodic task to be executed every 15 minutes.
    Workmanager().registerPeriodicTask(
      "uniqueTaskName",
      "simpleTask",
      inputData: {
        'key': 'value',
      },
      frequency: const Duration(minutes: 15), // Minimum interval as allowed by the system.
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
}

