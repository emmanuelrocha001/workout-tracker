import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:workout_tracker/providers/config_provider.dart';

class ElapsedTimeTimer extends StatefulWidget {
  final DateTime startTime;
  const ElapsedTimeTimer({super.key, required this.startTime});

  @override
  State<ElapsedTimeTimer> createState() => _ElapsedTimeTimerState();
}

class _ElapsedTimeTimerState extends State<ElapsedTimeTimer> {
  Timer? timer;
  int elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    startElapsedTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startElapsedTimer() {
    elapsedSeconds = DateTime.now().difference(widget.startTime).inSeconds;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedSeconds++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO easier to init date time from seconds and then format it?
    var totalSeconds = elapsedSeconds;
    const secondsInDay = 60 * 60 * 24;
    var days = (totalSeconds / (secondsInDay)).floor();
    totalSeconds -= (days * secondsInDay);

    const secondsInHour = 60 * 60;
    var hours = (totalSeconds / (secondsInHour)).floor();
    totalSeconds -= (hours * secondsInHour);

    const secondsInMinute = 60;
    var minutes = (totalSeconds / (secondsInMinute)).floor();
    totalSeconds -= (minutes * secondsInMinute);

    var seconds = totalSeconds;

    var formatter = NumberFormat(ConfigProvider.twoDigitFormat);
    return Text(
        '${formatter.format(hours)}:${formatter.format(minutes)}:${formatter.format(seconds)}');
  }
}
