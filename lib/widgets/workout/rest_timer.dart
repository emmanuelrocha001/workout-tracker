import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../providers/config_provider.dart';
import '../../utility.dart';
import '../general/text_style_templates.dart';

class RestTimer extends StatefulWidget {
  final int timeLenghtInSeconds;
  const RestTimer({
    super.key,
    this.timeLenghtInSeconds = 180,
  });

  @override
  State<RestTimer> createState() => _RestTimerState();
}

class _RestTimerState extends State<RestTimer> with WidgetsBindingObserver {
  Timer? timer;
  DateTime? endTime;
  int timeLenghtInSeconds = 0;
  int elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    timeLenghtInSeconds = widget.timeLenghtInSeconds;
    endTime = DateTime.now().add(Duration(seconds: timeLenghtInSeconds));
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
      if (elapsedSeconds <= timeLenghtInSeconds) {
        print('seconds remaining ${timeLenghtInSeconds - elapsedSeconds}');
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
    print('timeLenghtInSeconds: $timeLenghtInSeconds');
    print('endTime: $endTime');

    var secondsRemaining = DateTime.now().difference(endTime!).inSeconds;
    print('secondsRemaining: $secondsRemaining');
    elapsedSeconds = (timeLenghtInSeconds + secondsRemaining);
    print('elapsedSeconds: $elapsedSeconds');
    var id = Random().nextInt(100000);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // might need to do millisecond timer for smoother animation
      if (elapsedSeconds >= timeLenghtInSeconds) {
        print("timer done.cancelling timer $id");
        timer.cancel();
      }
      setState(() {
        // print("increasing elapsed time from $id timer");
        // print("elapsedSeconds: $elapsedSeconds");
        elapsedSeconds++;
      });
    });
  }

  void decreaseTimer(int seconds) {
    if (endTime == null || endTime!.isBefore(DateTime.now())) {
      return;
    }
    setState(() {
      endTime = endTime!.subtract(Duration(seconds: seconds));

      if (timeLenghtInSeconds - seconds < 0) {
        timeLenghtInSeconds = 0;
      } else {
        timeLenghtInSeconds -= seconds;
      }
    });
  }

  void increaseTimer(int seconds) {
    if (endTime == null) {
      return;
    }
    if (elapsedSeconds >= timeLenghtInSeconds) {
      endTime = DateTime.now().add(Duration(seconds: seconds));
      timeLenghtInSeconds = seconds;
      reInitializeTimer();
    } else {
      setState(() {
        endTime = endTime!.add(Duration(seconds: seconds));
        timeLenghtInSeconds += seconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO easier to init date time from seconds and then format it?
    var timeRemainingInSeconds = timeLenghtInSeconds - elapsedSeconds;
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
                value: timeRemainingInSeconds > 0
                    ? timeRemainingInSeconds / timeLenghtInSeconds
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
                  timeRemainingInSeconds >= 0
                      ? Utility.getElapsedTimeString(
                          timeDiff: Utility.getTimeDifferenceAsTimeDiff(
                              timeRemainingInSeconds, false),
                          includeHours: false)
                      : "00:00",
                  style: TextStyleTemplates.xLargeBoldTextStyle(
                      ConfigProvider.mainTextColor),
                ),
                Text(
                  Utility.getElapsedTimeString(
                      timeDiff: Utility.getTimeDifferenceAsTimeDiff(
                          timeLenghtInSeconds, false),
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
