import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import '../../providers/config_provider.dart';
import '../../utility.dart';
import '../general/text_style_templates.dart';

class RestTimer extends StatefulWidget {
  final int timeLenghtInSeconds;
  const RestTimer({
    super.key,
    this.timeLenghtInSeconds = 90,
  });

  @override
  State<RestTimer> createState() => _RestTimerState();
}

class _RestTimerState extends State<RestTimer> with WidgetsBindingObserver {
  final int _millisecondInterval = 100;
  Timer? timer;
  DateTime? endTime;
  int timeLenghtInMilliseconds = 0;
  int elapsedMilliseconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    timeLenghtInMilliseconds = widget.timeLenghtInSeconds * 1000;
    endTime = DateTime.now().add(Duration(seconds: widget.timeLenghtInSeconds));
    // startTime = DateTime.now();
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
      if (elapsedMilliseconds <= timeLenghtInMilliseconds) {
        print(
            'seconds remaining ${timeLenghtInMilliseconds - elapsedMilliseconds}');
        reInitializeTimer();
      } else {
        print("timer already done. not reinitializing");
      }
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      timer?.cancel();
    }
  }

  @override
  void didUpdateWidget(covariant RestTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (endTime == endTime) return;
    print(
        "didUpdateWidget, reinitializing timer ${endTime?.toIso8601String()}");
    reInitializeTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer?.cancel();
    super.dispose();
  }

  void startElapsedTimer() {
    print("starting timer");
    print('timeLenghtInSeconds: $timeLenghtInMilliseconds');
    print('endTime: $endTime');

    var timeRemainingInMilliseconds =
        DateTime.now().difference(endTime!).inMilliseconds;
    print('remaining: $timeRemainingInMilliseconds');
    elapsedMilliseconds =
        (timeLenghtInMilliseconds + timeRemainingInMilliseconds);
    print('elapsed: $elapsedMilliseconds');
    var id = Random().nextInt(100000);
    timer =
        Timer.periodic(Duration(milliseconds: _millisecondInterval), (timer) {
      // might need to do millisecond timer for smoother animation
      if (elapsedMilliseconds >= timeLenghtInMilliseconds) {
        print("timer done.cancelling timer $id");
        timer.cancel();
      }
      setState(() {
        // print("increasing elapsed time from $id timer");
        // print("elapsedSeconds: $elapsedSeconds");
        elapsedMilliseconds += _millisecondInterval;
      });
    });
  }

  void decreaseTimer(int seconds) {
    if (endTime == null || endTime!.isBefore(DateTime.now())) {
      return;
    }
    final milliseconds = seconds * 1000;

    setState(() {
      endTime = endTime!.subtract(Duration(seconds: seconds));

      if (timeLenghtInMilliseconds - milliseconds < 0) {
        timeLenghtInMilliseconds = 0;
      } else {
        timeLenghtInMilliseconds -= milliseconds;
      }
    });
  }

  void increaseTimer(int seconds) {
    if (endTime == null) {
      return;
    }
    final milliseconds = seconds * 1000;
    if (elapsedMilliseconds >= timeLenghtInMilliseconds) {
      endTime = DateTime.now().add(Duration(seconds: seconds));
      timeLenghtInMilliseconds = milliseconds;
      reInitializeTimer();
    } else {
      setState(() {
        endTime = endTime!.add(Duration(seconds: seconds));
        timeLenghtInMilliseconds += milliseconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO easier to init date time from seconds and then format it?
    var timeRemainingInMilliseconds =
        timeLenghtInMilliseconds - elapsedMilliseconds;
    var timeRemainingInSeconds = (timeRemainingInMilliseconds / 1000).floor();
    // var formatter = NumberFormat(ConfigProvider.twoDigitFormat);
    // var centiSeconds = formatter.format(
    //     ((timeRemainingInMilliseconds - (timeRemainingInSeconds * 1000))));
    // print('millisecondsRemainder: $centiSeconds');
    // print('centiSeconds: $centiSeconds');
    return Column(
      children: [
        const SizedBox(
          height: ConfigProvider.defaultSpace * 2,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 200.0,
              width: 200.0,
              child: CircularProgressIndicator(
                // color: ConfigProvider.backgroundColor,
                value: timeRemainingInMilliseconds > 0
                    ? timeRemainingInMilliseconds / timeLenghtInMilliseconds
                    : 0,
                backgroundColor: ConfigProvider.slightContrastBackgroundColor,
                valueColor: const AlwaysStoppedAnimation<Color>(
                    ConfigProvider.mainColor), //ConfigProvider.mainColor),
                strokeWidth: 6.0,
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              children: [
                Text(
                  timeRemainingInMilliseconds >= 0
                      ? '${Utility.getElapsedTimeString(timeDiff: Utility.getTimeDifferenceAsTimeDiff(timeRemainingInSeconds, false), includeHours: false)}'
                      : "00:00",
                  style: TextStyleTemplates.xLargeBoldTextStyle(
                      ConfigProvider.mainTextColor),
                ),
                Text(
                  Utility.getElapsedTimeString(
                      timeDiff: Utility.getTimeDifferenceAsTimeDiff(
                          (timeLenghtInMilliseconds / 1000).floor(), false),
                      includeHours: false),
                  style: TextStyleTemplates.mediumBoldTextStyle(Colors.grey),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: ConfigProvider.defaultSpace * 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ConfigProvider.slightContrastBackgroundColor,
              ),
              child: Text(
                "-30",
                style: TextStyleTemplates.mediumBoldTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
              onPressed: () {
                decreaseTimer(30);
              },
            ),
            const SizedBox(
              width: ConfigProvider.defaultSpace,
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ConfigProvider.slightContrastBackgroundColor,
              ),
              child: Text(
                "+30",
                style: TextStyleTemplates.mediumBoldTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
              onPressed: () {
                increaseTimer(30);
              },
            ),
            const SizedBox(
              width: ConfigProvider.defaultSpace,
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ConfigProvider.mainColor,
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "SKIP",
                style: TextStyleTemplates.smallBoldTextStyle(
                  ConfigProvider.backgroundColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
