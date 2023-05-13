import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ipotato_timer/extension.dart';

class CountdownTimer extends StatefulWidget {
  final Duration duration;
  final Duration elapsedTime;
  final bool stop;
  final VoidCallback? onFinished;

  const CountdownTimer({
    Key? key,
    required this.duration,
    required this.elapsedTime,
    this.onFinished,
    this.stop = false,
  }) : super(key: key);

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    _remainingTime = widget.duration - widget.elapsedTime;
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final remainingTime = _toHHMMSS();
    return Text(
      remainingTime,
      style: context.theme.textTheme.headlineLarge?.copyWith(
        color: context.theme.primaryColor,
      ),
    );
  }

  void _updateTimer(Timer timer) {
    if (widget.stop) {
      _timer.cancel();
    } else {
      setState(() {
        if (_remainingTime.inSeconds == 0) {
          _timer.cancel();
          widget.onFinished?.call();
        } else {
          _remainingTime -= const Duration(seconds: 1);
        }
      });
    }
  }

  String _toHHMMSS() {
    final inHours = _remainingTime.inHours;
    final inMinutes = _remainingTime.inMinutes;
    final inSeconds = _remainingTime.inSeconds;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final twoDigitHours = twoDigits(inHours);
    final twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(inSeconds.remainder(60));

    return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
