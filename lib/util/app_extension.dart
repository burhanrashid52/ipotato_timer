import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

extension DurationExt on Duration {
  Duration add(Duration duration) {
    return Duration(milliseconds: inMilliseconds + duration.inMilliseconds);
  }
}
