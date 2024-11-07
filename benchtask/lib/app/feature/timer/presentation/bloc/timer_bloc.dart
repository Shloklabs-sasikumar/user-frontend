import 'dart:async';
import 'package:benchtask/app/feature/timer/application/use_cases/timer_usecases.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'timer_event.dart';
import 'timer_state.dart';

/// Bloc that manages the state of a timer using different events.
/// This class also observes app lifecycle changes to handle background behavior.
class TimerBloc extends Bloc<TimerEvent, TimerState> with WidgetsBindingObserver {
  Timer? _ticker; // Timer to manage periodic tick updates
  DateTime? _startTime; // The time when the timer was last started
  Duration _accumulatedDuration = Duration.zero; // Total duration accumulated across pauses
  final TimerUseCases _timerUseCases;

  /// Constructor for `TimerBloc`, initializing the timer state and adding app lifecycle observer.
  TimerBloc(this._timerUseCases) : super(TimerState.initial()) {
    WidgetsBinding.instance.addObserver(this); // Observe app lifecycle changes
    // Load previous state if the app is restarted
    _loadInitialState();
    // Handle TimerStarted event: Starts the timer and resets start time
    on<TimerStarted>((event, emit) async{
      _startTime = DateTime.now();
      await _timerUseCases.startTimer();// Record the current time as start time
      _startTicker(); // Start the periodic ticker
      emit(state.copyWith(status: TimerStatus.running)); // Update state to running
    });

    // Handle TimerPaused event: Pauses the timer and updates accumulated duration
    on<TimerPaused>((event, emit) async {
      // Ensure that _startTime is not null before calculating the elapsed time
      if (_startTime != null) {
        _accumulatedDuration += DateTime.now().difference(_startTime!); // Update accumulated duration
      }

      _stopTicker(); // Stop the periodic ticker

      // Save the accumulated duration to persistent storage to maintain the state
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('elapsed', _accumulatedDuration.inSeconds); // Save the accumulated duration
      prefs.remove('startTime'); // Remove the start time to indicate that the timer is paused

      await _timerUseCases.pauseTimer(); // Call the pause use case if needed

      // Emit the paused state with the current accumulated duration
      emit(state.copyWith(
        status: TimerStatus.paused,
        duration: _accumulatedDuration,
      ));
    });


    // Handle TimerResumed event: Resumes the timer from paused state
    on<TimerResumed>((event, emit) async{
      _startTime = DateTime.now(); // Reset start time
      await _timerUseCases.resumeTimer();
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
  Future<void> _loadInitialState() async {
    final prefs = await SharedPreferences.getInstance();
    final startTimeString = prefs.getString('startTime');
    final elapsedSeconds = prefs.getInt('elapsed') ?? 0;

    if (startTimeString != null) {
      // Timer was running when the app was killed or closed
      _startTime = DateTime.parse(startTimeString);
      final currentElapsed = DateTime.now().difference(_startTime!);
      _accumulatedDuration = Duration(seconds: elapsedSeconds) + currentElapsed;
      _startTicker();
      add(TimerTicked(duration: _accumulatedDuration));
      emit(TimerState(status: TimerStatus.running, duration: _accumulatedDuration));
    } else if (elapsedSeconds > 0) {
      // Timer was paused when the app was closed
      _accumulatedDuration = Duration(seconds: elapsedSeconds);
      emit(TimerState(status: TimerStatus.paused, duration: _accumulatedDuration));
    }
  }

}
