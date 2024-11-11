/// Abstract class representing the contract for timer-related operations.
abstract class TimerRepository {
  /// Starts the timer and records the start time.
  Future<void> startTimer();

  /// Pauses the timer and saves the current elapsed duration.
  Future<void> pauseTimer();

  /// Stops the timer and resets the accumulated time.
  Future<void> stopTimer();

  /// Retrieves the total elapsed duration of the timer.
  Future<Duration> fetchElapsedTime();

  /// Resumes the timer from a paused state.
  Future<void> resumeTimer();

  /// Retrieves the stored start time of the timer.
  ///
  /// Returns a [DateTime] representing when the timer was started, or `null` if not available.
  Future<DateTime?> getStoredStartTime();

  /// Retrieves the stored elapsed duration of the timer.
  ///
  /// Returns a [Duration] representing the time accumulated before pausing or stopping.
  Future<Duration> getStoredElapsedTime();

  /// Saves the elapsed duration of the timer.
  ///
  /// [elapsed] - The duration to be stored.
  Future<void> saveElapsedTime(Duration elapsed);

  /// Clears the stored start time, typically used when the timer is paused or stopped.
  Future<void> clearStartTime();

  /// Saves the start time of the timer.
  ///
  /// [startTime] - The [DateTime] when the timer started.
  Future<void> saveStartTime(DateTime startTime);

  /// Checks if the timer is currently running.
  ///
  /// Returns `true` if the timer is running, otherwise `false`.
  Future<bool> isTimerRunning();
}
