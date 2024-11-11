import 'package:benchtask/app/feature/timer/domain/entities/timer_entity.dart';
import 'package:equatable/equatable.dart';


/// Enum representing the possible states of the timer.
/// - `idle`: Timer is not active.
/// - `running`: Timer is currently counting time.
/// - `paused`: Timer is paused but can be resumed.
/// - `stopped`: Timer has been stopped and reset.
/// - `error`: An error occurred in the timer.
enum TimerStatus { idle, running, paused, stopped, error }

/// Represents the state of the timer, including its current status, data, and potential error messages.
/// Extends `Equatable` to support easy comparison between instances.
class TimerState extends Equatable {
  /// The current status of the timer, represented by the `TimerStatus` enum.
  final TimerStatus status;

  /// The entity representing the timer's data (start time, elapsed duration, and running status).
  final TimerEntity timerEntity;

  /// An optional error message for handling any potential errors.
  final String? errorMessage;

  /// Constructor for `TimerState`, which takes the current [status], [timerEntity], and optional [errorMessage].
  const TimerState({
    required this.status,
    required this.timerEntity,
    this.errorMessage,
  });

  /// Factory constructor to initialize the timer to its default state.
  /// - `status`: Set to `TimerStatus.idle` indicating the timer is not running.
  /// - `timerEntity`: Set to initial values.
  factory TimerState.initial() {
    return TimerState(
      status: TimerStatus.idle,
      timerEntity: TimerEntity(startTime: null, elapsed: Duration.zero, isRunning: false),
    );
  }

  /// Creates a new instance of `TimerState` with optional updated properties.
  /// If [status], [timerEntity], or [errorMessage] are not provided, their existing values are retained.
  TimerState copyWith({
    TimerStatus? status,
    TimerEntity? timerEntity,
    String? errorMessage,
  }) {
    return TimerState(
      status: status ?? this.status,
      timerEntity: timerEntity ?? this.timerEntity,
      errorMessage: errorMessage,
    );
  }

  /// Properties used for comparing `TimerState` instances.
  /// Allows `Equatable` to check if two `TimerState` instances are equal.
  @override
  List<Object?> get props => [status, timerEntity, errorMessage];
}
