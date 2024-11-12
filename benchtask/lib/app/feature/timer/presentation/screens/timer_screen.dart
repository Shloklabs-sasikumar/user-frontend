
import 'package:benchtask/app/feature/timer/presentation/widgets/timer_controls.dart';
import 'package:benchtask/app/feature/timer/presentation/widgets/timer_display.dart';
import 'package:flutter/material.dart';


class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Task Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimerDisplay(),
            const SizedBox(height: 50),
            TimerControls(),
          ],
        ),
      ),
    );
  }
}
