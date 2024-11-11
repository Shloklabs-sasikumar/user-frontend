import 'dart:async';
import 'package:benchtask/app/feature/timer/application/use_cases/timer_usecases.dart';
import 'package:benchtask/app/feature/timer/domain/entities/timer_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'timer_event.dart';
import 'timer_state.dart';

/// Bloc class for managing timer-related events and states.
/// This class handles logic for starting, pausing, resuming, and stopping the timer,
/// and interacts with [TimerUseCases] to persist and retrieve timer data.
class TimerBloc extends Bloc<TimerEvent, TimerState> with WidgetsBindingObserver {
  Timer? _ticker; // Timer instance for periodic updates.
  DateTime? _startTime; // The start time when the timer is running.
  Duration _accumulatedDuration = Duration.zero; // Total accumulated duration of the timer.
  final TimerUseCases _timerUseCases; // Use cases for interacting with the data layer.

  /// Constructor for [TimerBloc].
  /// Initializes the state and loads any previously saved timer state.
  TimerBloc(this._timerUseCases) : super(TimerState.initial()) {
    WidgetsBinding.instance.addObserver(this); // Observe app lifecycle events.
    _loadInitialState(); // Load the initial state when the bloc is created.

    // Event handlers for timer events.
    on<TimerStarted>(_onTimerStarted);
    on<TimerPaused>(_onTimerPaused);
    on<TimerResumed>(_onTimerResumed);
    on<TimerStopped>(_onTimerStopped);
    on<TimerTicked>(_onTimerTicked);
  }

  /// Handler for [TimerStarted] event.
  /// Starts the timer, saves the start time, and begins periodic updates.
  Future<void> _onTimerStarted(TimerStarted event, Emitter<TimerState> emit) async {
    try {
      _startTime = DateTime.now(); // Record the current time as the start time.
      await _timerUseCases.saveStartTime(_startTime!); // Persist the start time.
      await _timerUseCases.startTimer(); // Trigger the use case to start the timer.
      _startTicker(); // Start the periodic timer updates.

      // Emit the new state with updated timer information.
      emit(state.copyWith(
        timerEntity: state.timerEntity.copyWith(
          startTime: _startTime,
          isRunning: true,
        ),
        status: TimerStatus.running,
      ));
    } catch (e) {
      // Handle and emit any errors that occur while starting the timer.
      emit(state.copyWith(
        status: TimerStatus.error,
        errorMessage: "Failed to start the timer: $e",
      ));
    }
  }

  /// Handler for [TimerPaused] event.
  /// Pauses the timer, stops periodic updates, and saves the accumulated duration.
  Future<void> _onTimerPaused(TimerPaused event, Emitter<TimerState> emit) async {
    try {
      if (_startTime != null) {
        // Update the accumulated duration with the current elapsed time.
        _accumulatedDuration += DateTime.now().difference(_startTime!);
        _startTime = null; // Clear the start time to indicate the timer is paused.
      }
      _stopTicker(); // Stop the periodic ticker.
      await _timerUseCases.saveElapsedTime(_accumulatedDuration); // Persist the accumulated time.
      await _timerUseCases.clearStartTime(); // Clear the stored start time.

      // Emit the paused state with updated timer information.
      emit(state.copyWith(
        timerEntity: state.timerEntity.copyWith(
          elapsed: _accumulatedDuration,
          isRunning: false,
        ),
        status: TimerStatus.paused,
      ));
    } catch (e) {
      // Handle and emit any errors that occur while pausing the timer.
      emit(state.copyWith(
        status: TimerStatus.error,
        errorMessage: "Failed to pause the timer: $e",
      ));
    }
  }

  /// Handler for [TimerResumed] event.
  /// Resumes the timer by setting a new start time and restarting periodic updates.
  Future<void> _onTimerResumed(TimerResumed event, Emitter<TimerState> emit) async {
    try {
      _startTime = DateTime.now(); // Set the current time as the new start time.
      await _timerUseCases.saveStartTime(_startTime!); // Persist the new start time.
      await _timerUseCases.resumeTimer(); // Trigger the use case to resume the timer.
      _startTicker(); // Start the periodic ticker for updates.

      // Emit the running state with updated timer information.
      emit(state.copyWith(
        timerEntity: state.timerEntity.copyWith(
          startTime: _startTime,
          elapsed: _accumulatedDuration, // Maintain the accumulated duration.
          isRunning: true,
        ),
        status: TimerStatus.running,
      ));
    } catch (e) {
      // Handle and emit any errors that occur while resuming the timer.
      emit(state.copyWith(
        status: TimerStatus.error,
        errorMessage: "Failed to resume the timer: $e",
      ));
    }
  }

  /// Handler for [TimerStopped] event.
  /// Stops the timer, resets the accumulated duration, and clears the start time.
  Future<void> _onTimerStopped(TimerStopped event, Emitter<TimerState> emit) async {
    try {
      _stopTicker(); // Stop the periodic ticker.
      _accumulatedDuration = Duration.zero; // Reset the accumulated duration.
      _startTime = null; // Clear the start time.
      await _timerUseCases.stopTimer(); // Trigger the use case to stop the timer.

      // Emit the initial state to reset the timer.
      emit(TimerState.initial());
    } catch (e) {
      // Handle and emit any errors that occur while stopping the timer.
      emit(state.copyWith(
        status: TimerStatus.error,
        errorMessage: "Failed to stop the timer: $e",
      ));
    }
  }

  /// Handler for [TimerTicked] event.
  /// Updates the state with the current elapsed duration.
  void _onTimerTicked(TimerTicked event, Emitter<TimerState> emit) {
    // Emit the updated state with the total elapsed time.
    emit(state.copyWith(
      timerEntity: state.timerEntity.copyWith(
        elapsed: event.duration,
      ),
    ));
  }

  /// Starts the periodic ticker to update elapsed time.
  void _startTicker() {
    // Cancel any existing ticker before starting a new one.
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_startTime != null) {
        // Calculate the current duration since the timer started/resumed.
        final currentDuration = DateTime.now().difference(_startTime!);
        final totalElapsed = _accumulatedDuration + currentDuration;

        // Emit the TimerTicked event with the updated elapsed time.
        add(TimerTicked(duration: totalElapsed));
      }
    });
  }

  /// Stops the periodic ticker.
  void _stopTicker() {
    _ticker?.cancel(); // Cancel the ticker.
    _ticker = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Save the current state when the app is paused.
    if (state == AppLifecycleState.paused) {
      _saveCurrentTimerState();
      _ticker?.cancel(); // Stop the ticker when the app goes into the background.
    }
  }

  /// Saves the current state of the timer to persistent storage.
  Future<void> _saveCurrentTimerState() async {
    if (_startTime != null) {
      // Update the accumulated duration with the current elapsed time.
      _accumulatedDuration += DateTime.now().difference(_startTime!);
      await _timerUseCases.saveElapsedTime(_accumulatedDuration); // Save the accumulated time.
      await _timerUseCases.saveStartTime(_startTime!); // Save the current start time.
      _startTime = null; // Clear the start time to indicate the timer is paused.
    }
  }

  @override
  Future<void> close() {
    _stopTicker(); // Stop the ticker when the bloc is closed.
    WidgetsBinding.instance.removeObserver(this); // Remove the lifecycle observer.
    return super.close();
  }

  /// Loads the initial state of the timer from persistent storage.
  Future<void> _loadInitialState() async {
    try {
      // Retrieve the stored start time and accumulated elapsed time.
      final storedStartTime = await _timerUseCases.getStartTime();
      final storedElapsed = await _timerUseCases.getElapsedTime();

      if (storedStartTime != null && await _timerUseCases.isTimerRunning()) {
        // Calculate the time difference if the timer was running when last saved.
        final currentTime = DateTime.now();
        final timeDifference = currentTime.difference(storedStartTime);

        // Combine the stored duration with the time difference for the total.
        _startTime = storedStartTime;
        _accumulatedDuration = storedElapsed + timeDifference;

        // Emit the running state and start the ticker.
        emit(state.copyWith(
          timerEntity: TimerEntity(
            startTime: _startTime,
            elapsed: _accumulatedDuration,
            isRunning: true,
          ),
          status: TimerStatus.running,
        ));
        _startTicker();
      } else if (storedElapsed > Duration.zero) {
        // Restore the paused state if the timer was not running.
        _accumulatedDuration = storedElapsed;
        emit(state.copyWith(
          timerEntity: TimerEntity(
            startTime: null,
            elapsed: _accumulatedDuration,
            isRunning: false,
          ),
          status: TimerStatus.paused,
        ));
      } else {
        // If no data exists, reset to the initial state.
        emit(TimerState.initial());
      }
    } catch (e) {
      // Handle and emit any errors that occur while loading the initial state.
      emit(state.copyWith(
        status: TimerStatus.error,
        errorMessage: "Failed to load initial state: $e",
      ));
    }
  }
}
