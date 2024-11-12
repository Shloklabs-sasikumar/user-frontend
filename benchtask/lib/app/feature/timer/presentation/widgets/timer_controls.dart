
import 'package:benchtask/app/feature/timer/presentation/bloc/timer_bloc.dart';
import 'package:benchtask/app/feature/timer/presentation/bloc/timer_event.dart';
import 'package:benchtask/app/feature/timer/presentation/bloc/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class TimerControls extends StatelessWidget {
  const TimerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final timerBloc = context.read<TimerBloc>();

        switch (state.status) {
          case TimerStatus.idle:
          case TimerStatus.stopped:
            return ElevatedButton.icon(
              onPressed: () => timerBloc.add(TimerStarted()),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 50),
              ),
            );
          case TimerStatus.running:
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => timerBloc.add(TimerPaused()),
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () => timerBloc.add(TimerStopped()),
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                  ),
                ),
              ],
            );
          case TimerStatus.paused:
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => timerBloc.add(TimerResumed()),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Resume'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () => timerBloc.add(TimerStopped()),
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                  ),
                ),
              ],
            );
          default:
            return Container(); // Handles any unanticipated state
        }
      },
    );


  }
}
