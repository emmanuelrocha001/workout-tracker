import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

import '../../utility.dart';

import '../../providers/config_provider.dart';
import '../general/text_style_templates.dart';

class ElapsedTimeTimer extends StatefulWidget {
  final DateTime startTime;
  final DateTime? endTime;
  final bool logTicker;
  const ElapsedTimeTimer({
    super.key,
    required this.startTime,
    this.endTime,
    this.logTicker = false,
  });

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

  void reInitializeTimer() {
    if (timer!.isActive) {
      print("timer unexpectedly active. cancelling");
      timer?.cancel();
    }
    // trigger a rebuild to avoid lag on resume.
    setState(() {});
    startElapsedTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // if (timer!.isActive) {
      //   print("timer unexpectedly active. cancelling");
      //   timer?.cancel();
      // }
      // // trigger a rebuild to avoid lag on resume.
      // setState(() {});
      // startElapsedTimer();
      reInitializeTimer();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      timer?.cancel();
    }
  }

  @override
  void didUpdateWidget(covariant ElapsedTimeTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startTime == widget.startTime) return;
    print(
        "didUpdateWidget, reinitializing timer ${widget.startTime.toIso8601String()}");
    reInitializeTimer();
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
        if (widget.logTicker) print("increasing elapsed time from $id timer");
        elapsedSeconds++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO easier to init date time from seconds and then format it?
    return Text(
      Utility.getElapsedTimeString(
          timeDiff: Utility.getTimeDifferenceAsTimeDiff(elapsedSeconds, false)),
      style:
          TextStyleTemplates.mediumBoldTextStyle(ConfigProvider.mainTextColor),
    );
  }
}
