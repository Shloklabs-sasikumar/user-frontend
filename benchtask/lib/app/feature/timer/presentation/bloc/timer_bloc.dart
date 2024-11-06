import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'timer_event.dart';
import 'timer_state.dart';

/// Bloc that manages the state of a timer using different events.
/// This class also observes app lifecycle changes to handle background behavior.
class TimerBloc extends Bloc<TimerEvent, TimerState> with WidgetsBindingObserver {
  Timer? _ticker; // Timer to manage periodic tick updates
  DateTime? _startTime; // The time when the timer was last started
  Duration _accumulatedDuration = Duration.zero; // Total duration accumulated across pauses

  /// Constructor for `TimerBloc`, initializing the timer state and adding app lifecycle observer.
  TimerBloc() : super(TimerState.initial()) {
    WidgetsBinding.instance.addObserver(this); // Observe app lifecycle changes

    // Handle TimerStarted event: Starts the timer and resets start time
    on<TimerStarted>((event, emit) {
      _startTime = DateTime.now(); // Record the current time as start time
      _startTicker(); // Start the periodic ticker
      emit(state.copyWith(status: TimerStatus.running)); // Update state to running
    });

    // Handle TimerPaused event: Pauses the timer and updates accumulated duration
    on<TimerPaused>((event, emit) {
      _stopTicker(); // Stop the periodic ticker
      _accumulatedDuration += DateTime.now().difference(_startTime!); // Add elapsed time to accumulated duration
      emit(state.copyWith(
          status: TimerStatus.paused, duration: _accumulatedDuration)); // Update state to paused with new duration
    });

    // Handle TimerResumed event: Resumes the timer from paused state
    on<TimerResumed>((event, emit) {
      _startTime = DateTime.now(); // Reset start time
      _startTicker(); // Start the ticker again
      emit(state.copyWith(status: TimerStatus.running)); // Update state to running
    });

    // Handle TimerStopped event: Stops the timer and resets all values
    on<TimerStopped>((event, emit) {
      _stopTicker(); // Stop the ticker
      _accumulatedDuration = Duration.zero; // Reset accumulated duration
      _startTime = null; // Clear start time
      emit(TimerState.initial()); // Reset to initial state
    });

    // Handle TimerTicked event: Updates the timer's duration on each tick
    on<TimerTicked>((event, emit) {
      emit(state.copyWith(duration: event.duration)); // Update state with the current duration
    });
  }

  /// Starts a periodic ticker that updates the timer every second.
  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final currentDuration = _accumulatedDuration +
          DateTime.now().difference(_startTime!); // Calculate current duration
      add(TimerTicked(duration: currentDuration)); // Emit TimerTicked event with updated duration
    });
  }

  /// Stops the periodic ticker if it's running.
  void _stopTicker() {
    _ticker?.cancel(); // Cancel the ticker
    _ticker = null; // Reset ticker reference
  }

  /// Override close method to stop ticker and remove lifecycle observer when Bloc is closed.
  @override
  Future<void> close() {
    _stopTicker(); // Ensure ticker is stopped
    WidgetsBinding.instance.removeObserver(this); // Remove lifecycle observer
    return super.close();
  }

/*
  // Handle app lifecycle changes for pausing and resuming the timer
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive && this.state.status == TimerStatus.running) {
      // Pause the timer if the app goes to the background
      _stopTicker();
    } else if (state == AppLifecycleState.resumed && this.state.status == TimerStatus.running) {
      // Resume the timer if the app returns to the foreground
      _startTime = DateTime.now();
      _startTicker();
    }
  }
  */
}
