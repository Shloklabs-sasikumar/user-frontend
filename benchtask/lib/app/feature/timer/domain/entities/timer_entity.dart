// lib/domain/entities/task.dart
import 'package:equatable/equatable.dart';

class Task extends Equatable{
  final String name;
  final DateTime startTime;
  final Duration duration;

  Task({
    required this.name,
    required this.startTime,
    required this.duration,
  });

  Task copyWith({String? name, DateTime? startTime, Duration? duration}) {
    return Task(
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [name, startTime, duration];
}
