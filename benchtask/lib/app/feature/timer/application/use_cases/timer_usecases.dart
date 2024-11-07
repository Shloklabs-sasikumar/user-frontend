import 'package:benchtask/app/feature/timer/domain/repository/timer_repository.dart';

/// A class that encapsulates timer-related use cases and interacts with the timer repository.
class TimerUseCases {
  /// The repository responsible for timer data operations.
  final TimerRepository _timerRepository;

  /// Constructor that initializes the TimerUseCases with a TimerRepository instance.
  TimerUseCases(this._timerRepository);

  /// Starts the timer by delegating the call to the timer repository.
  Future<void> startTimer() {
    return _timerRepository.startTimer();
  }

  /// Pauses the timer by calling the [pauseTimer] method of the [_timerRepository].
  Future<void> pauseTimer() {
    return _timerRepository.pauseTimer();
  }

  /// Stops the timer by calling the [stopTimer] method of the [_timerRepository].
  Future<void> stopTimer() {
    return _timerRepository.stopTimer();
  }

  /// Fetches the elapsed time by calling the [fetchElapsedTime] method of the [_timerRepository].
  Future<Duration> fetchElapsedTime() {
    return _timerRepository.fetchElapsedTime();
  }

  Future<void> resumeTimer(){
    return _timerRepository.resumeTimer();
  }
}
