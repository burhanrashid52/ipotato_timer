import 'package:clock/clock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';

@freezed
class Task with _$Task {
  const Task._();

  const factory Task({
    required int id,
    required String title,
    required Duration duration,
    String? description,
    DateTime? startedAt,
    @Default(Duration.zero) Duration elapsedDuration,
  }) = _Task;

  bool get isFinished => totalElapsed.inSeconds >= duration.inSeconds;

  bool get isRunning => startedAt != null && !isFinished;

  Duration get totalElapsed {
    if (startedAt == null) {
      return elapsedDuration;
    }
    final diff = clock.now().difference(startedAt!);
    final milliseconds = diff.inMilliseconds + elapsedDuration.inMilliseconds;
    return Duration(milliseconds: milliseconds);
  }
}
