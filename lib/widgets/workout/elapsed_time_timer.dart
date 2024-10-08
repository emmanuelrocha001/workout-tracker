import 'dart:math';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../providers/config_provider.dart';
import '../general/text_style_templates.dart';

class ElapsedTimeTimer extends StatefulWidget {
  final DateTime startTime;
  const ElapsedTimeTimer({super.key, required this.startTime});

  @override
  State<ElapsedTimeTimer> createState() => _ElapsedTimeTimerState();
}

class _ElapsedTimeTimerState extends State<ElapsedTimeTimer>
    with WidgetsBindingObserver {
  Timer? timer;
  int elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    startElapsedTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (timer!.isActive) {
        print("timer unexpectedly active. cancelling");
        timer?.cancel();
      }
      // trigger a rebuild to avoid lag on resume.
      setState(() {});
      startElapsedTimer();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer?.cancel();
    super.dispose();
  }

  void startElapsedTimer() {
    elapsedSeconds = DateTime.now().difference(widget.startTime).inSeconds;
    var id = Random().nextInt(100000);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        print("increasing elapsed time from $id timer");
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
      '${formatter.format(hours)}:${formatter.format(minutes)}:${formatter.format(seconds)}',
      style:
          TextStyleTemplates.mediumBoldTextStyle(ConfigProvider.mainTextColor),
    );
  }
}
