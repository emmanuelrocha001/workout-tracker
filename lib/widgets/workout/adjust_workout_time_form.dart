import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/adjust_workout_times_dto.dart';
import '../../providers/config_provider.dart';
import '../../utility.dart';
import './../../widgets/general/row_item.dart';
import '../../widgets/workout/elapsed_time_timer.dart';
import '../helper.dart';
import '../general/text_style_templates.dart';

class AdjustWorkoutTimeForm extends StatefulWidget {
  final AdjustWorkoutTimesDto initial;
  final bool canEnableAutoTiming;
  const AdjustWorkoutTimeForm({
    super.key,
    required this.initial,
    required this.canEnableAutoTiming,
  });

  @override
  State<AdjustWorkoutTimeForm> createState() => _AdjustWorkoutTimeFormState();
}

class _AdjustWorkoutTimeFormState extends State<AdjustWorkoutTimeForm> {
  bool autoTimingSelected = true;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    startDate = widget.initial.startTime;
    endDate = widget.initial.endTime ??
        DateTime.now().add(const Duration(minutes: 1));
    autoTimingSelected = widget.initial.autoTimingSelected;
  }

  void _onStartTimeUpdate() async {
    var newTime = await Helper.showTimePickerDefault(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startDate!),
      prompt: "SELECT START TIME",
    );

    print(newTime.toString());
    if (newTime != null && newTime != TimeOfDay.fromDateTime(startDate!)) {
      var newStartDateTime = DateTime(
        startDate!.year,
        startDate!.month,
        startDate!.day,
        newTime.hour,
        newTime.minute,
      );

      setState(() {
        startDate = newStartDateTime;
      });
    }
  }

  void _onEndTimeUpdate() async {
    var newTime = await Helper.showTimePickerDefault(
      context: context,
      initialTime: TimeOfDay.fromDateTime(endDate!),
      prompt: "SELECT END TIME",
    );

    print(newTime.toString());
    if (newTime != null && newTime != TimeOfDay.fromDateTime(endDate!)) {
      var newEndDateTime = DateTime(
        endDate!.year,
        endDate!.month,
        endDate!.day,
        newTime.hour,
        newTime.minute,
      );

      setState(() {
        endDate = newEndDateTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var startDateString =
        DateFormat(ConfigProvider.defaultShortenDateStampFormat)
            .format(startDate!)
            .toUpperCase();

    var startTimeString = DateFormat(
      ConfigProvider.defaultTimeFormat,
    ).format(startDate!).toUpperCase();

    var endTimeString = DateFormat(
      ConfigProvider.defaultTimeFormat,
    ).format(endDate!).toUpperCase();

    var elapsedTimeString = "";
    var errorMessage = "";
    if (!autoTimingSelected && startDate != null && endDate != null) {
      var diff =
          Utility.getTimeDifference(startTime: startDate!, endTime: endDate!);
      elapsedTimeString = Utility.getElapsedTimeString(
        timeDiff: diff,
        includeTimeUnits: true,
      );
      if (diff.isNegativeTimeDiff) {
        errorMessage = "Invalid time range.";
      }
    }
    if (errorMessage.isNotEmpty) {
      print('error message is not empty');
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.canEnableAutoTiming)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RowItem(
                isCompact: true,
                child: Text(
                  "AUTO TIMING",
                  style: TextStyleTemplates.defaultBoldTextStyle(
                      ConfigProvider.mainTextColor),
                ),
              ),
              const SizedBox(
                width: ConfigProvider.defaultSpace,
              ),
              RowItem(
                isCompact: true,
                child: Switch(
                  activeColor: ConfigProvider.mainColor,
                  thumbIcon: WidgetStatePropertyAll(
                    Icon(
                      autoTimingSelected ? Icons.check : Icons.close,
                      color: ConfigProvider.backgroundColor,
                    ),
                  ),
                  value: autoTimingSelected,
                  onChanged: (bool value) {
                    setState(() {
                      autoTimingSelected = value;
                    });
                  },
                ),
              ),
            ],
          ),
        Row(
          children: [
            RowItem(
              alignment: Alignment.centerRight,
              child: Text(
                "START TIME",
                style: TextStyleTemplates.defaultBoldTextStyle(
                    ConfigProvider.mainTextColor),
              ),
            ),
            const SizedBox(
              width: ConfigProvider.defaultSpace,
            ),
            RowItem(
              isCompact: true,
              child: Row(
                children: [
                  TextButton(
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                        EdgeInsets.zero,
                      ),
                    ),
                    onPressed: null,
                    child: Text(
                      startDateString,
                      style: TextStyleTemplates.defaultBoldTextStyle(
                          ConfigProvider.mainTextColor),
                    ),
                  ),
                  TextButton(
                    onPressed: _onStartTimeUpdate,
                    child: Text(
                      startTimeString,
                      style: TextStyleTemplates.defaultBoldTextStyle(
                          ConfigProvider.mainColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!autoTimingSelected)
          Row(
            children: [
              RowItem(
                alignment: Alignment.centerRight,
                child: Text(
                  "END TIME",
                  style: TextStyleTemplates.defaultBoldTextStyle(
                      ConfigProvider.mainTextColor),
                ),
              ),
              const SizedBox(
                width: ConfigProvider.defaultSpace,
              ),
              RowItem(
                isCompact: true,
                child: Row(
                  children: [
                    TextButton(
                      style: const ButtonStyle(
                        padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                          EdgeInsets.zero,
                        ),
                      ),
                      onPressed: null,
                      child: Text(
                        startDateString,
                        style: TextStyleTemplates.defaultBoldTextStyle(
                            ConfigProvider.mainTextColor),
                      ),
                    ),
                    TextButton(
                      onPressed: _onEndTimeUpdate,
                      child: Text(
                        endTimeString,
                        style: TextStyleTemplates.defaultBoldTextStyle(
                            ConfigProvider.mainColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
          child: Align(
            alignment: Alignment.center,
            child: !autoTimingSelected
                ? Text(
                    elapsedTimeString,
                    style: TextStyleTemplates.mediumBoldTextStyle(
                        ConfigProvider.mainTextColor),
                  )
                : ElapsedTimeTimer(
                    startTime: startDate!,
                    logTicker: false,
                  ),
          ),
        ),
        if (errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
            child: Text(
              errorMessage,
              style: TextStyleTemplates.smallTextStyle(Colors.red),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ConfigProvider.slightContrastBackgroundColor,
              ),
              child: Text(
                "CANCEL",
                style: TextStyleTemplates.smallBoldTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            const SizedBox(
              width: ConfigProvider.defaultSpace,
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ConfigProvider.mainColor,
              ),
              onPressed: errorMessage.isNotEmpty
                  ? null
                  : () {
                      var update = AdjustWorkoutTimesDto(
                        autoTimingSelected: autoTimingSelected,
                        startTime: startDate!,
                        endTime: autoTimingSelected ? null : endDate!,
                      );
                      Navigator.of(context).pop(update);
                    },
              child: Text(
                "UPDATE",
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
