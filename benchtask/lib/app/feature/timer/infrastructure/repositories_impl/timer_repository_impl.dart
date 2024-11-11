import 'package:benchtask/app/feature/timer/domain/repository/timer_repository.dart';
import 'package:benchtask/app/feature/timer/infrastructure/data/datasource/timer_local_datasource.dart';
import 'dart:async';

/// Implementation of the [TimerRepository] that handles timer data operations
/// and background service management.
class TimerRepositoryImpl implements TimerRepository {
  /// Data source for handling storage operations related to the timer.
  final TimerDataSource _timerDataSource = TimerDataSource();

  @override
  Future<void> startTimer() async {
    try {
      // Store the current time as the start time in ISO 8601 format.
      DateTime now = DateTime.now();
      await _timerDataSource.storeData('startTime', now.toIso8601String());
      // Mark the timer as running.
      await _timerDataSource.storeData('isRunning', 'true');
    } catch (e) {
      // Log or handle any error that occurs during the start operation.
      throw Exception('Failed to start the timer: $e');
    }
  }

  @override
  Future<void> pauseTimer() async {
    try {
      // Fetch the current accumulated elapsed time and store it.
      Duration elapsed = await fetchElapsedTime();
      await _timerDataSource.storeData('elapsed', elapsed.inSeconds.toString());
      // Mark the timer as paused and remove the start time.
      await _timerDataSource.storeData('isRunning', 'false');
      await _timerDataSource.removeData('startTime');
    } catch (e) {
      // Handle any error that occurs during the pause operation.
      throw Exception('Failed to pause the timer: $e');
    }
  }

  @override
  Future<void> stopTimer() async {
    try {
      // Remove all stored data related to the timer.
      await _timerDataSource.removeData('startTime');
      await _timerDataSource.removeData('elapsed');
    } catch (e) {
      // Handle any error that occurs during the stop operation.
      throw Exception('Failed to stop the timer: $e');
    }
  }

  @override
  Future<Duration> fetchElapsedTime() async {
    try {
      // Retrieve the stored start time from the data source.
      String? start = await _timerDataSource.getStoredData('startTime');
      if (start != null && start.isNotEmpty) {
        // If a start time exists, calculate the elapsed time.
        DateTime startTime = DateTime.parse(start);
        return DateTime.now().difference(startTime);
      } else {
        // If no start time exists, retrieve the stored elapsed duration.
        String? elapsed = await _timerDataSource.getStoredData('elapsed');
        return Duration(seconds: int.tryParse(elapsed ?? '0') ?? 0);
      }
    } catch (e) {
      // Handle any error that occurs while fetching elapsed time.
      throw Exception('Failed to fetch elapsed time: $e');
    }
  }

  @override
  Future<void> resumeTimer() async {
    try {
      // Store the current time as the new start time in ISO 8601 format.
      DateTime now = DateTime.now();
      await _timerDataSource.storeData('startTime', now.toIso8601String());
      // Mark the timer as running.
      await _timerDataSource.storeData('isRunning', 'true');
    } catch (e) {
      // Handle any error that occurs during the resume operation.
      throw Exception('Failed to resume the timer: $e');
    }
  }

  @override
  Future<DateTime?> getStoredStartTime() async {
    try {
      // Retrieve and parse the stored start time.
      final startTimeString = await _timerDataSource.getStoredData('startTime');
      return startTimeString != null ? DateTime.parse(startTimeString) : null;
    } catch (e) {
      // Handle any error that occurs while retrieving the start time.
      throw Exception('Failed to get stored start time: $e');
    }
  }

  @override
  Future<Duration> getStoredElapsedTime() async {
    try {
      // Retrieve and parse the stored elapsed time.
      final elapsedString = await _timerDataSource.getStoredData('elapsed');
      return Duration(seconds: int.tryParse(elapsedString ?? '0') ?? 0);
    } catch (e) {
      // Handle any error that occurs while retrieving the elapsed time.
      throw Exception('Failed to get stored elapsed time: $e');
    }
  }

  @override
  Future<void> saveElapsedTime(Duration elapsed) async {
    try {
      // Store the provided elapsed time in seconds.
      await _timerDataSource.storeData('elapsed', elapsed.inSeconds.toString());
    } catch (e) {
      // Handle any error that occurs while saving elapsed time.
      throw Exception('Failed to save elapsed time: $e');
    }
  }

  @override
  Future<void> clearStartTime() async {
    try {
      // Remove the stored start time and mark the timer as not running.
      await _timerDataSource.removeData('startTime');
      await _timerDataSource.storeData('isRunning', 'false');
    } catch (e) {
      // Handle any error that occurs while clearing the start time.
      throw Exception('Failed to clear start time: $e');
    }
  }

  @override
  Future<void> saveStartTime(DateTime startTime) async {
    try {
      // Store the provided start time in ISO 8601 format and mark as running.
      await _timerDataSource.storeData('startTime', startTime.toIso8601String());
      await _timerDataSource.storeData('isRunning', 'true');
    } catch (e) {
      // Handle any error that occurs while saving the start time.
      throw Exception('Failed to save start time: $e');
    }
  }

  @override
  Future<bool> isTimerRunning() async {
    try {
      // Retrieve and check the running state.
      final isRunning = await _timerDataSource.getStoredData('isRunning');
      return isRunning == 'true';
    } catch (e) {
      // Handle any error that occurs while checking the running state.
      throw Exception('Failed to check if timer is running: $e');
    }
  }
}
