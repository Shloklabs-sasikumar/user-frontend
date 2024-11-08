import 'dart:async';
import 'package:benchtask/app/feature/timer/application/use_cases/timer_usecases.dart';
import 'package:benchtask/app/feature/timer/domain/entities/timer_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'timer_event.dart';
import 'timer_state.dart';

/// Bloc class for managing timer-related events and states.
/// This class handles the logic for starting, pausing, resuming, and stopping the timer,
/// and interacts with the [TimerUseCases] to persist and retrieve timer data.
class TimerBloc extends Bloc<TimerEvent, TimerState> with WidgetsBindingObserver {
  Timer? _ticker;
  DateTime? _startTime;
  Duration _accumulatedDuration = Duration.zero;
  final TimerUseCases _timerUseCases;

  /// Constructor for [TimerBloc].
  /// Initializes the state and loads any previously saved timer state.
  TimerBloc(this._timerUseCases) : super(TimerState.initial()) {
    WidgetsBinding.instance.addObserver(this);
    _loadInitialState();

    on<TimerStarted>((event, emit) async {
      try {
        _startTime = DateTime.now();
        await _timerUseCases.saveStartTime(_startTime!); // Record the current time as start time
        await _timerUseCases.startTimer(); // Call the start use case
        _startTicker(); // Start the periodic ticker
        emit(state.copyWith(
          timerEntity: state.timerEntity.copyWith(
            startTime: _startTime,
            isRunning: true,
          ),
          status: TimerStatus.running,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: TimerStatus.error,
          errorMessage: "Failed to start the timer: $e",
        ));
      }
    });

    on<TimerPaused>((event, emit) async {
      try {
        if (_startTime != null) {
          _accumulatedDuration += DateTime.now().difference(_startTime!);
        }

        _stopTicker(); // Stop the ticker
        await _timerUseCases.saveElapsedTime(_accumulatedDuration); // Save the accumulated duration
        await _timerUseCases.clearStartTime(); // Clear start time to mark as paused

        emit(state.copyWith(
          timerEntity: state.timerEntity.copyWith(
            elapsed: _accumulatedDuration,
            isRunning: false,
          ),
          status: TimerStatus.paused, // Ensure the paused state is set
        ));
      } catch (e) {
        emit(state.copyWith(
          status: TimerStatus.error,
          errorMessage: "Failed to pause the timer: $e",
        ));
      }
    });

    on<TimerResumed>((event, emit) async {
      try {
        _startTime = DateTime.now();
        await _timerUseCases.saveStartTime(_startTime!); // Save resumed start time
        await _timerUseCases.resumeTimer(); // Resume use case
        _startTicker();
        emit(state.copyWith(
          timerEntity: state.timerEntity.copyWith(
            startTime: _startTime,
            isRunning: true,
          ),
          status: TimerStatus.running,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: TimerStatus.error,
          errorMessage: "Failed to resume the timer: $e",
        ));
      }
    });

    on<TimerStopped>((event, emit) async {
      try {
        _stopTicker();
        _accumulatedDuration = Duration.zero;
        _startTime = null;
        await _timerUseCases.stopTimer(); // Stop use case
        emit(TimerState.initial());
      } catch (e) {
        emit(state.copyWith(
          status: TimerStatus.error,
          errorMessage: "Failed to stop the timer: $e",
        ));
      }
    });

    on<TimerTicked>((event, emit) {
      emit(state.copyWith(
        timerEntity: state.timerEntity.copyWith(
          elapsed: event.duration,
        ),
      ));
    });
  }

  /// Starts the ticker to update elapsed time periodically.
  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_startTime != null) {
        final currentDuration = _accumulatedDuration +
            DateTime.now().difference(_startTime!);
        add(TimerTicked(duration: currentDuration));
      }
    });
  }

  /// Stops the ticker.
  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Save state when app goes to background
      _saveCurrentTimerState();
    }
  }

  /// Saves the current state of the timer.
  /// This function stores the current start time and accumulated duration in persistent storage.
  Future<void> _saveCurrentTimerState() async {
    if (_startTime != null) {
      await _timerUseCases.saveStartTime(_startTime!);
      await _timerUseCases.saveElapsedTime(_accumulatedDuration);
    }
  }

  @override
  Future<void> close() {
    _stopTicker();
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  /// Loads the initial state of the timer from stored data.
  /// This function checks if the timer was running or paused and restores the state accordingly.
  Future<void> _loadInitialState() async {
    try {
      final storedStartTime = await _timerUseCases.getStartTime();
      final storedElapsed = await _timerUseCases.getElapsedTime();

      if (storedStartTime != null && storedElapsed > Duration.zero) {
        // Check if the timer was paused. If `storedStartTime` is old or not cleared properly,
        // but there's only `storedElapsed`, treat it as paused.
        final currentTime = DateTime.now();
        final timeDifference = currentTime.difference(storedStartTime);

        if (timeDifference.inSeconds > storedElapsed.inSeconds) {
          // This means that the start time is old, and the timer was paused.
          _accumulatedDuration = storedElapsed;
          emit(state.copyWith(
            timerEntity: TimerEntity(
              startTime: null,
              elapsed: _accumulatedDuration,
              isRunning: false,
            ),
            status: TimerStatus.paused, // Set status to paused.
          ));
        } else {
          // The timer was running, so resume it.
          _startTime = storedStartTime;
          final currentElapsed = timeDifference;
          _accumulatedDuration = storedElapsed + currentElapsed;
          _startTicker(); // Start the ticker to continue the timer.
          emit(state.copyWith(
            timerEntity: TimerEntity(
              startTime: _startTime,
              elapsed: _accumulatedDuration,
              isRunning: true,
            ),
            status: TimerStatus.running,
          ));
        }
      } else if (storedElapsed > Duration.zero) {
        // If there is no start time but there is an elapsed duration, it means the timer was paused.
        _accumulatedDuration = storedElapsed;
        emit(state.copyWith(
          timerEntity: TimerEntity(
            startTime: null,
            elapsed: _accumulatedDuration,
            isRunning: false,
          ),
          status: TimerStatus.paused, // Set status to paused without starting the ticker.
        ));
      } else {
        // No timing data exists, so emit the initial idle state.
        emit(state.copyWith(
          status: TimerStatus.idle,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: TimerStatus.error,
        errorMessage: "Failed to load initial state: $e",
      ));
    }
  }
}
