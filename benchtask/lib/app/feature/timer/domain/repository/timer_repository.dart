abstract class TimerRepository {
  Future<void> startTimer();
  Future<void> pauseTimer();
  Future<void> stopTimer();
  Future<Duration> fetchElapsedTime();
  Future<void> resumeTimer();
}
