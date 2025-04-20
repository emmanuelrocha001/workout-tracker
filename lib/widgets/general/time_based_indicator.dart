import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import '../../providers/config_provider.dart';

class TimeBasedIndicator extends StatefulWidget {
  final int timeLenghtInMilliseconds;
  const TimeBasedIndicator({
    super.key,
    required this.timeLenghtInMilliseconds,
  });

  @override
  State<TimeBasedIndicator> createState() => _TimeBasedIndicatorState();
}

class _TimeBasedIndicatorState extends State<TimeBasedIndicator>
    with WidgetsBindingObserver {
  final int _millisecondInterval = 100;
  Timer? timer;
  int elapsedMilliseconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    startTimer();
  }

  void startTimer() {
    Timer.periodic(Duration(milliseconds: _millisecondInterval), (timer) {
      // might need to do millisecond timer for smoother animation
      if (elapsedMilliseconds >= widget.timeLenghtInMilliseconds) {
        print("timer done.cancelling timer");
        timer.cancel();
      }
      print("calling setState from time based indicator");
      if (mounted) {
        setState(() {
          elapsedMilliseconds += _millisecondInterval;
        });
      } else {
        print("Running after being dismounted. Cancelling unexpected timer.");
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    var timeRemainingInMilliseconds =
        widget.timeLenghtInMilliseconds - elapsedMilliseconds;

    return Padding(
      padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
      child: SizedBox(
        height: ConfigProvider.defaultSpace,
        width: ConfigProvider.defaultSpace,
        child: CircularProgressIndicator(
          // color: ConfigProvider.backgroundColor,
          value: timeRemainingInMilliseconds > 0
              ? timeRemainingInMilliseconds / widget.timeLenghtInMilliseconds
              : 0,
          backgroundColor: ConfigProvider.slightContrastBackgroundColor,
          valueColor: const AlwaysStoppedAnimation<Color>(
              ConfigProvider.mainColor), //ConfigProvider.mainColor),
          strokeCap: StrokeCap.round,
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}
