// lib/presentation/blocs/timer_bloc/timer_state.dart

import 'package:equatable/equatable.dart';

/// Enum representing the possible states of the timer.
/// - `idle`: Timer is not active.
/// - `running`: Timer is currently counting time.
/// - `paused`: Timer is paused but can be resumed.
/// - `stopped`: Timer has been stopped and reset.
enum TimerStatus { idle, running, paused, stopped }

/// Represents the state of the timer, including its current status and duration.
/// Extends `Equatable` to support easy comparison between instances.
class TimerState extends Equatable {
  /// The current status of the timer, represented by the `TimerStatus` enum.
  final TimerStatus status;

  /// The total duration tracked by the timer.
  final Duration duration;

  /// Constructor for `TimerState`, which takes the current [status] and [duration].
  const TimerState({
    required this.status,
    required this.duration,
  });

  /// Factory constructor to initialize the timer to its default state.
  /// - `status`: Set to `TimerStatus.idle` indicating the timer is not running.
  /// - `duration`: Set to `Duration.zero` as the timer has not started.
  factory TimerState.initial() {
    return const TimerState(
      status: TimerStatus.idle,
      duration: Duration.zero,
    );
  }

  /// Creates a new instance of `TimerState` with optional updated properties.
  /// If [status] or [duration] are not provided, their existing values are retained.
  TimerState copyWith({
    TimerStatus? status,
    Duration? duration,
  }) {
    return TimerState(
      status: status ?? this.status,
      duration: duration ?? this.duration,
    );
  }

  /// Properties used for comparing `TimerState` instances.
  /// Allows `Equatable` to check if two `TimerState` instances are equal.
  @override
  List<Object> get props => [status, duration];
}
