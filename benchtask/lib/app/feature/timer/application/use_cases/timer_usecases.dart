import 'package:benchtask/app/feature/timer/domain/repository/timer_repository.dart';

/// A class that encapsulates timer-related use cases and interacts with the timer repository.
class TimerUseCases {
  /// The repository responsible for timer data operations.
  final TimerRepository _timerRepository;

  /// Constructor that initializes the TimerUseCases with a TimerRepository instance.
  TimerUseCases(this._timerRepository);

  /// Starts the timer by delegating the call to the timer repository.
  ///
  /// This method records the current time as the start time and begins the timer operation.
  Future<void> startTimer() {
    return _timerRepository.startTimer();
  }

  /// Pauses the timer by calling the [pauseTimer] method of the [_timerRepository].
  ///
  /// This method stops the current timer operation and saves the elapsed duration up to that point.
  Future<void> pauseTimer() {
    return _timerRepository.pauseTimer();
  }

  /// Stops the timer by calling the [stopTimer] method of the [_timerRepository].
  ///
  /// This method ends the timer operation and resets the timer state.
  Future<void> stopTimer() {
    return _timerRepository.stopTimer();
  }

  /// Fetches the total elapsed time by calling the [fetchElapsedTime] method of the [_timerRepository].
  ///
  /// Returns a [Duration] representing the time accumulated while the timer was active.
  Future<Duration> fetchElapsedTime() {
    return _timerRepository.fetchElapsedTime();
  }

  /// Resumes the timer by calling the [resumeTimer] method of the [_timerRepository].
  ///
  /// This method continues the timer from where it was paused.
  Future<void> resumeTimer() {
    return _timerRepository.resumeTimer();
  }

  /// Retrieves the stored start time of the timer.
  ///
  /// Returns a [DateTime] representing when the timer was last started, or `null` if not available.
  Future<DateTime?> getStartTime() async {
    return await _timerRepository.getStoredStartTime();
  }

  /// Retrieves the stored elapsed duration of the timer.
  ///
  /// Returns a [Duration] representing the accumulated time before the timer was paused or stopped.
  Future<Duration> getElapsedTime() async {
    return await _timerRepository.getStoredElapsedTime();
  }

  /// Saves the elapsed duration of the timer.
  ///
  /// [elapsed] - The [Duration] to be stored, representing the accumulated time.
  Future<void> saveElapsedTime(Duration elapsed) async {
    await _timerRepository.saveElapsedTime(elapsed);
  }

  /// Clears the stored start time of the timer.
  ///
  /// Typically called when the timer is paused or stopped.
  Future<void> clearStartTime() async {
    await _timerRepository.clearStartTime();
  }

  /// Saves the start time of the timer.
  ///
  /// [startTime] - The [DateTime] representing when the timer started.
  Future<void> saveStartTime(DateTime startTime) {
    return _timerRepository.saveStartTime(startTime);
  }
  /// Returns `true` if the timer is running, otherwise `false`.
  Future<bool> isTimerRunning() async {
    return await _timerRepository.isTimerRunning();
  }
}