// lib/presentation/widgets/timer_display.dart

import 'package:benchtask/app/feature/timer/presentation/bloc/timer_bloc.dart';
import 'package:benchtask/app/feature/timer/presentation/bloc/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class TimerDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        // Access the TimerEntity from the state
        final duration = state.timerEntity.elapsed ?? Duration.zero;

        final hours = duration.inHours.toString().padLeft(2, '0');
        final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
        final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

        return Text(
          '$hours:$minutes:$seconds',
          style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
        );
      },
    );

  }
}
