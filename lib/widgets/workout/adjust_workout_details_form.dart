import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/adjust_workout_times_dto.dart';
import '../../providers/config_provider.dart';
import '../../utility.dart';
import './../../widgets/general/row_item.dart';
import '../../widgets/workout/elapsed_time_timer.dart';
import '../helper.dart';
import '../general/text_style_templates.dart';
import '../general/labeled_row.dart';

import '../general/edit_text_field_form.dart';
import '../general/action_button.dart';
import '../general/default_switch.dart';

class AdjustWorkoutDetailsForm extends StatefulWidget {
  final AdjustWorkoutTimesDto initial;
  final bool canEnableAutoTiming;
  final bool isUpdatingWorkout;
  final double maxFormWidth;
  const AdjustWorkoutDetailsForm({
    super.key,
    required this.initial,
    required this.canEnableAutoTiming,
    required this.isUpdatingWorkout,
    required this.maxFormWidth,
  });

  @override
  State<AdjustWorkoutDetailsForm> createState() =>
      _AdjustWorkoutDetailsFormState();
}

class _AdjustWorkoutDetailsFormState extends State<AdjustWorkoutDetailsForm> {
  bool autoTimingSelected = true;
  bool showRestTimerAfterEachSet = true;
  bool isEditingWorkoutNickName = false;
  String workoutNickName = "";
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    startDate = widget.initial.startTime;
    endDate = widget.initial.endTime ??
        DateTime.now().add(const Duration(minutes: 1));
    autoTimingSelected = widget.initial.autoTimingSelected;
    showRestTimerAfterEachSet = widget.initial.showRestTimerAfterEachSet;
    workoutNickName = widget.initial.workoutNickName;
  }

  void _onStartDateUpdate() async {
    var newStartDate = await Helper.showDatePickerDefault(
      context: context,
      initialDate: startDate!,
      prompt: "Select Start Date",
    );

    if (newStartDate != null) {
      setState(() {
        startDate = DateTime(
          newStartDate.year,
          newStartDate.month,
          newStartDate.day,
          startDate!.hour,
          startDate!.minute,
        );
      });
    }
  }

  void _onStartTimeUpdate() async {
    var newTime = await Helper.showTimePickerDefault(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startDate!),
      prompt: "Select Start Time",
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
      prompt: "Select End Time",
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

  void _onEndDateUpdate() async {
    var newEndDate = await Helper.showDatePickerDefault(
      context: context,
      initialDate: endDate!,
      prompt: "Select End Date",
    );

    if (newEndDate != null) {
      setState(() {
        endDate = DateTime(
          newEndDate.year,
          newEndDate.month,
          newEndDate.day,
          endDate!.hour,
          endDate!.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var startDateString =
        DateFormat(ConfigProvider.defaultShortenDateStampFormat)
            .format(startDate!)
            .toUpperCase();

    var endDateString = '';
    if (endDate != null) {
      endDateString = DateFormat(ConfigProvider.defaultShortenDateStampFormat)
          .format(endDate!)
          .toUpperCase();
    }

    var startTimeString = DateFormat(
      ConfigProvider.defaultTimeFormat,
    ).format(startDate!).toUpperCase();

    var endTimeString = DateFormat(
      ConfigProvider.defaultTimeFormat,
    ).format(endDate!).toUpperCase();

    var elapsedTimeString = "";
    var errorMessage = "";

    if (!autoTimingSelected) {
      if (startDate!.isAfter(endDate!)) {
        errorMessage = "Workout start time must come before end time.";
      } else if (endDate!.difference(startDate!).inSeconds >
          ConfigProvider.maxWorkoutDurationInSeconds) {
        errorMessage = "Max workout duration is 24 hours.";
      } else {
        var diff =
            Utility.getTimeDifference(startTime: startDate!, endTime: endDate!);
        elapsedTimeString = Utility.getElapsedTimeString(
          timeDiff: diff,
          includeTimeUnits: true,
        );
      }
    } else {
      // this checks if the start date has been updated
      if (widget.initial.startTime != startDate) {
        var now = DateTime.now();
        var lStartDate = now.subtract(const Duration(days: 1));

        if (!(startDate!.isAfter(lStartDate) && startDate!.isBefore(now))) {
          errorMessage =
              "When auto timing is selected, workout start time must be set within 24 hours of the current time, and cannot be set in the future.";
        }
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: ConfigProvider.defaultSpace / 2,
      children: [
        Column(
          children: [
            LabeledRow(
              label: 'Nickname',
              tooltip: ConfigProvider.workoutNickNameInputToolTip,
              children: [
                RowItem(
                  isCompact: false,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    workoutNickName,
                    style: TextStyleTemplates.defaultTextStyle(
                      ConfigProvider.mainTextColor,
                    ),
                  ),
                ),
                RowItem(
                  isCompact: true,
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      size: ConfigProvider.smallIconSize,
                      color: ConfigProvider.mainColor,
                    ),
                    onPressed: () async {
                      var input = await Helper.showPopUp(
                        title: 'Edit Nickname',
                        context: context,
                        specificHeight: 180.0,
                        content: EditTextFieldForm(
                          initialValue: workoutNickName,
                        ),
                      );
                      if (input != null && input is String) {
                        setState(() {
                          workoutNickName = input;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        if (!widget.isUpdatingWorkout)
          LabeledRow(
            label: 'Auto Rest Timer',
            tooltip:
                '${ConfigProvider.autoRestTimerToolTip} This overrides the global setting for this workout.',
            children: [
              RowItem(
                isCompact: true,
                alignment: Alignment.centerLeft,
                child: DefaultSwitch(
                  value: showRestTimerAfterEachSet,
                  onChanged: (bool value) {
                    setState(() {
                      showRestTimerAfterEachSet = value;
                    });
                  },
                ),
              ),
            ],
          ),
        if (widget.canEnableAutoTiming)
          LabeledRow(
            label: 'Auto Timing',
            tooltip: ConfigProvider.autoTimingToggleToolTip,
            children: [
              RowItem(
                isCompact: true,
                child: DefaultSwitch(
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
        LabeledRow(
          label: 'Start Time',
          children: [
            RowItem(
              isCompact: true,
              child: TextButton(
                style: const ButtonStyle(
                  padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                    EdgeInsets.zero,
                  ),
                ),
                onPressed: _onStartDateUpdate,
                child: Text(
                  startDateString,
                  style: TextStyleTemplates.defaultBoldTextStyle(
                    errorMessage.isEmpty
                        ? ConfigProvider.mainColor
                        : Colors.red,
                  ),
                ),
              ),
            ),
            RowItem(
              isCompact: true,
              child: TextButton(
                onPressed: _onStartTimeUpdate,
                child: Text(
                  startTimeString,
                  style: TextStyleTemplates.defaultBoldTextStyle(
                    errorMessage.isEmpty
                        ? ConfigProvider.mainColor
                        : Colors.red,
                  ),
                ),
              ),
            )
          ],
        ),
        if (!autoTimingSelected)
          LabeledRow(
            label: "End Time",
            children: [
              RowItem(
                isCompact: true,
                child: TextButton(
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                      EdgeInsets.zero,
                    ),
                  ),
                  onPressed: _onEndDateUpdate,
                  child: Text(
                    endDateString,
                    style: TextStyleTemplates.defaultBoldTextStyle(
                      errorMessage.isEmpty
                          ? ConfigProvider.mainColor
                          : Colors.red,
                    ),
                  ),
                ),
              ),
              RowItem(
                isCompact: true,
                child: TextButton(
                  onPressed: _onEndTimeUpdate,
                  child: Text(
                    endTimeString,
                    style: TextStyleTemplates.defaultBoldTextStyle(
                      errorMessage.isEmpty
                          ? ConfigProvider.mainColor
                          : Colors.red,
                    ),
                  ),
                ),
              )
            ],
          ),
        if (errorMessage.isEmpty)
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
        ActionButton(
          label: 'UPDATE',
          onPressed: errorMessage.isNotEmpty
              ? null
              : () {
                  var update = AdjustWorkoutTimesDto(
                    autoTimingSelected: autoTimingSelected,
                    startTime: startDate!,
                    endTime: autoTimingSelected ? null : endDate!,
                    showRestTimerAfterEachSet: showRestTimerAfterEachSet,
                    workoutNickName: workoutNickName,
                  );
                  Navigator.of(context).pop(update);
                },
        ),
      ],
    );
  }
}
