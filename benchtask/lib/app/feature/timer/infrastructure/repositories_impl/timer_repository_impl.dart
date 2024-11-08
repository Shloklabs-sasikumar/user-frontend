import 'package:benchtask/app/feature/timer/domain/repository/timer_repository.dart';
import 'package:benchtask/app/feature/timer/infrastructure/data/datasource/timer_local_datasource.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

/// Implementation of the [TimerRepository] that handles timer data operations
/// and background service management.
class TimerRepositoryImpl implements TimerRepository {
  /// Instance of the background service used for managing timer operations in the background.
  late final FlutterBackgroundService service;

  /// Data source for handling storage operations related to the timer.
  final TimerDataSource _timerDataSource = TimerDataSource();

  /// Constructor that initializes the background service and sets up the configuration.
  TimerRepositoryImpl() {
    service = FlutterBackgroundService();
    initializeService();
  }

  /// Configures the background service with platform-specific settings.
  Future<void> initializeService() async {
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onServiceStart, // Function to call when the service starts.
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onServiceStart,
      ),
    );
  }

  /// Entry point for the background service.
  ///
  /// Initializes the timer data source and handles background updates.
  static Future<void> onServiceStart(ServiceInstance service) async {
    TimerDataSource timerDataSource = TimerDataSource();
    await timerDataSource.initlize();

    if (service is AndroidServiceInstance) {
      service.on('stopService').listen((event) {
        service.stopSelf();
      });
    }

    DateTime? startTime;
    String? start = await timerDataSource.getStoredData('startTime');
    if (start != null && start.isNotEmpty) {
      startTime = DateTime.parse(start);
    } else {
      startTime = DateTime.now();
      await timerDataSource.storeData('startTime', startTime.toIso8601String());
    }

    service.invoke('updateElapsed');
    service.on('updateElapsed').listen((event) async {
      DateTime now = DateTime.now();
      if (startTime != null) {
        Duration elapsed = now.difference(startTime);
        await timerDataSource.storeData('elapsed', elapsed.inSeconds.toString());
      }
    });
  }

  @override
  /// Starts the timer by storing the current start time and initiating the background service.
  Future<void> startTimer() async {
    DateTime now = DateTime.now();
    await _timerDataSource.storeData('startTime', now.toIso8601String());
    if (!(await service.isRunning())) {
      await service.startService();
    }
    service.invoke('updateElapsed');
  }

  @override
  /// Pauses the timer by saving the elapsed time and clearing the start time.
  Future<void> pauseTimer() async {
    Duration elapsed = await fetchElapsedTime();
    await _timerDataSource.storeData('elapsed', elapsed.inSeconds.toString());
    await _timerDataSource.removeData('startTime');
  }

  @override
  /// Stops the timer and removes all stored data related to the timer.
  Future<void> stopTimer() async {
    await _timerDataSource.removeData('startTime');
    await _timerDataSource.removeData('elapsed');
    service.invoke('stopService');
  }

  @override
  /// Fetches the total elapsed time from the stored data.
  ///
  /// Returns a [Duration] representing the time elapsed since the start.
  Future<Duration> fetchElapsedTime() async {
    String? start = await _timerDataSource.getStoredData('startTime');
    if (start != null && start.isNotEmpty) {
      DateTime startTime = DateTime.parse(start);
      return DateTime.now().difference(startTime);
    } else {
      String? elapsed = await _timerDataSource.getStoredData('elapsed');
      return Duration(seconds: int.tryParse(elapsed ?? '0') ?? 0);
    }
  }

  @override
  /// Resumes the timer by storing the current start time and starting the background service if needed.
  Future<void> resumeTimer() async {
    DateTime now = DateTime.now();
    await _timerDataSource.storeData('startTime', now.toIso8601String());
    if (!(await service.isRunning())) {
      await service.startService();
    }
    service.invoke('updateElapsed');
  }

  @override
  /// Retrieves the stored start time of the timer.
  ///
  /// Returns a [DateTime] object or `null` if not available.
  Future<DateTime?> getStoredStartTime() async {
    final startTimeString = await _timerDataSource.getStoredData('startTime');
    return startTimeString != null ? DateTime.parse(startTimeString) : null;
  }

  @override
  /// Retrieves the stored elapsed time as a [Duration].
  Future<Duration> getStoredElapsedTime() async {
    final elapsedString = await _timerDataSource.getStoredData('elapsed');
    return Duration(seconds: int.tryParse(elapsedString ?? '0') ?? 0);
  }

  @override
  /// Saves the elapsed duration to the storage.
  ///
  /// [elapsed] - The [Duration] to be stored.
  Future<void> saveElapsedTime(Duration elapsed) async {
    await _timerDataSource.storeData('elapsed', elapsed.inSeconds.toString());
  }

  @override
  /// Clears the stored start time from the storage.
  Future<void> clearStartTime() async {
    await _timerDataSource.removeData('startTime');
  }

  @override
  /// Saves the start time to the storage.
  ///
  /// [startTime] - The [DateTime] representing the start time to be saved.
  Future<void> saveStartTime(DateTime startTime) async {
    await _timerDataSource.storeData('startTime', startTime.toIso8601String());
  }
}
