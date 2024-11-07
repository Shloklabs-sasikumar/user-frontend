import 'package:benchtask/app/feature/timer/domain/repository/timer_repository.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerRepositoryImpl implements TimerRepository {
  late final FlutterBackgroundService service;

  TimerRepositoryImpl() {
    service = FlutterBackgroundService();
    initializeService();
  }

  Future<void> initializeService() async {
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onServiceStart, // Reference the top-level function
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onServiceStart,
      ),
    );
  }

  static Future<void> onServiceStart(ServiceInstance service) async {
    // Service entry point for background execution
    if (service is AndroidServiceInstance) {
      service.on('stopService').listen((event) {
        service.stopSelf();
      });
    }

    final prefs = await SharedPreferences.getInstance();
    DateTime? startTime;

    // Retrieve or initialize start time
    String? start = prefs.getString('startTime');
    if (start != null) {
      startTime = DateTime.parse(start);
    } else {
      startTime = DateTime.now();
      prefs.setString('startTime', startTime.toIso8601String());
    }

    // Periodically update elapsed time
    service.invoke('updateElapsed');
    service.on('updateElapsed').listen((event) async {
      DateTime now = DateTime.now();
      if (startTime != null) {
        Duration elapsed = now.difference(startTime);
        prefs.setInt('elapsed', elapsed.inSeconds);
      }
    });
  }

  @override
  Future<void> startTimer() async {
    final prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    prefs.setString('startTime', now.toIso8601String());

    // Ensure the background service starts if not already running
    if (!(await service.isRunning())) {
      await service.startService();
    }
    service.invoke('updateElapsed');
  }

  @override
  Future<void> pauseTimer() async {
    final prefs = await SharedPreferences.getInstance();
    Duration elapsed = await fetchElapsedTime();
    prefs.setInt('elapsed', elapsed.inSeconds);
    prefs.remove('startTime');
  }

  @override
  Future<void> stopTimer() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('startTime');
    prefs.remove('elapsed');
    service.invoke('stopService');
  }

  @override
  Future<Duration> fetchElapsedTime() async {
    final prefs = await SharedPreferences.getInstance();
    String? start = prefs.getString('startTime');
    if (start != null) {
      DateTime startTime = DateTime.parse(start);
      return DateTime.now().difference(startTime);
    } else {
      int? elapsed = prefs.getInt('elapsed');
      return Duration(seconds: elapsed ?? 0);
    }
  }

  @override
  Future<void> resumeTimer() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('startTime', DateTime.now().toIso8601String());
  }
}
