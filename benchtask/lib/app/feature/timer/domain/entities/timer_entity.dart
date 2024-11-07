import 'package:equatable/equatable.dart';

class TimerEntity extends Equatable{
  final DateTime? startTime;
  final Duration elapsed;
  final bool isRunning;

  TimerEntity({
    required this.startTime,
    required this.elapsed,
    required this.isRunning,
  });

  TimerEntity copyWith({DateTime? startTime, Duration? elapsed, bool? isRunning}) {
    return TimerEntity(
      startTime: startTime ?? this.startTime,
      elapsed: elapsed ?? this.elapsed,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props =>[startTime, elapsed, isRunning];
}
