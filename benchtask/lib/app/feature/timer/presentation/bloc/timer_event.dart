// lib/presentation/blocs/timer_bloc/timer_event.dart

import 'package:equatable/equatable.dart';

/// Abstract base class for all timer events, extending `Equatable`
/// to allow for easier comparison of event instances in Bloc.
abstract class TimerEvent extends Equatable {
  @override
  List<Object?> get props => []; // Default props for all TimerEvents
}

/// Event to indicate that the timer has been started.
/// Triggers the timer to begin counting time.
class TimerStarted extends TimerEvent {
  @override
  List<Object?> get props => []; // No additional properties to compare
}

/// Event to indicate that the timer has been paused.
/// Temporarily stops the timer and stores the elapsed duration.
class TimerPaused extends TimerEvent {
  @override
  List<Object?> get props => []; // No additional properties to compare
}

/// Event to indicate that the timer has been resumed from a paused state.
/// Continues the timer from where it left off.
class TimerResumed extends TimerEvent {
  @override
  List<Object?> get props => []; // No additional properties to compare
}

/// Event to indicate that the timer has been stopped.
/// Resets the timer and clears any accumulated duration.
class TimerStopped extends TimerEvent {
  @override
  List<Object?> get props => []; // No additional properties to compare
}

/// Event to indicate a tick in the timer.
/// Contains the current duration to be updated in the timer's state.
class TimerTicked extends TimerEvent {
  /// The elapsed duration at the time of this tick.
  final Duration duration;

  /// Constructor for `TimerTicked`, requiring a [duration] parameter.
  TimerTicked({required this.duration});

  @override
  List<Object?> get props => [duration]; // Include `duration` to compare instances
}
