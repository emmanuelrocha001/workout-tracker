import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/widgets/general/default_container.dart';

import '../general/text_style_templates.dart';
import '../../providers/config_provider.dart';
import '../../providers/workout_provider.dart';

import '../../models/workout_dto.dart';
import '../../models/tracked_exercise_dto.dart';

import '../general/row_item.dart';
import '../general/default_menu_item_button.dart';
import './workout_history_list_item_summary.dart';
import './workout_history_list_item_breakdown.dart';

import '../helper.dart';

class WorkoutHistoryListItem extends StatelessWidget {
  final WorkoutDto workout;
  final bool isMetricSystemSelected;
  final void Function() navigateToWorkout;
  const WorkoutHistoryListItem({
    super.key,
    required this.workout,
    required this.navigateToWorkout,
    required this.isMetricSystemSelected,
  });

  List<Widget> _generateSimplifiedCompletedExerciseList(
      {required BuildContext context,
      required List<TrackedExerciseDto> trackedExercises}) {
    return trackedExercises.mapIndexed((index, trackedExercise) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RowItem(
            isCompact: true,
            alignment: Alignment.centerRight,
            maxWidth: 50,
            minWidth: 50,
            child: Padding(
              padding:
                  const EdgeInsets.only(right: ConfigProvider.defaultSpace),
              child: Text(
                '${trackedExercise.sets.length} x',
                style: TextStyleTemplates.defaultTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
            ),
          ),
          RowItem(
            hasCompactPadding: true,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  const EdgeInsets.only(right: ConfigProvider.defaultSpace),
              child: Text(
                trackedExercise.exercise.name,
                style: TextStyleTemplates.defaultTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
            ),
          ),
          if (trackedExercise.exercise.dimensions?.isWeightEnabled ?? true)
            RowItem(
              isCompact: true,
              alignment: Alignment.centerLeft,
              minWidth: 50.0,
              maxWidth: 50.0,
              child: Text(
                '${trackedExercise.sets.last.weight}',
                style: TextStyleTemplates.defaultTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
            ),
          if (trackedExercise.exercise.dimensions?.isWeightEnabled ?? true)
            RowItem(
              isCompact: true,
              alignment: Alignment.centerLeft,
              minWidth: 25.0,
              maxWidth: 25.0,
              child: Text(
                isMetricSystemSelected ? "kg" : "lb",
                style: TextStyleTemplates.defaultBoldTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
            ),
          if ((trackedExercise.exercise.dimensions?.isRepEnabled ?? true) &&
              !(trackedExercise.exercise.dimensions?.isWeightEnabled ?? true))
            const SizedBox(width: 75.0),
          if (trackedExercise.exercise.dimensions?.isRepEnabled ?? true)
            RowItem(
              isCompact: true,
              minWidth: 60.0,
              maxWidth: 60.0,
              alignment: Alignment.centerLeft,
              child: Text(
                'x ${trackedExercise.sets.last.reps}',
                style: TextStyleTemplates.defaultTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
            ),
          if ((trackedExercise.exercise.dimensions?.isDistanceEnabled ??
                  false) ||
              (trackedExercise.exercise.dimensions?.isTimeEnabled ?? false))
            Row(
              children: [
                RowItem(
                  isCompact: true,
                  alignment: Alignment.centerLeft,
                  minWidth: 40.0,
                  maxWidth: 40.0,
                  child:
                      (trackedExercise.exercise.dimensions?.isDistanceEnabled ??
                              false)
                          ? Text(
                              '${trackedExercise.sets.last.distance}',
                              style: TextStyleTemplates.defaultTextStyle(
                                ConfigProvider.mainTextColor,
                              ),
                            )
                          : const SizedBox(),
                ),
                (trackedExercise.exercise.dimensions?.isDistanceEnabled ??
                        false)
                    ? RowItem(
                        isCompact: true,
                        alignment: Alignment.centerLeft,
                        minWidth: 25.0,
                        maxWidth: 25.0,
                        child: Text(
                          ' ${isMetricSystemSelected ? "km" : "mi"} ',
                          style: TextStyleTemplates.defaultBoldTextStyle(
                            ConfigProvider.mainTextColor,
                          ),
                        ),
                      )
                    : const SizedBox(),
                (trackedExercise.exercise.dimensions?.isTimeEnabled ?? false)
                    ? RowItem(
                        isCompact: true,
                        alignment: Alignment.centerLeft,
                        minWidth: 70.0,
                        maxWidth: 70.0,
                        child: Text(
                          '${trackedExercise.sets.last.time}',
                          style: TextStyleTemplates.defaultTextStyle(
                            ConfigProvider.mainTextColor,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
        ],
      );
    }).toList();
    // Text(
    //               '${trackedExercise.sets.last.distance} ${isMetricSystemSelected ? "km" : "mi"} in ${trackedExercise.sets.last.time}',
    //               style: TextStyleTemplates.defaultTextStyle(
    //                 ConfigProvider.mainTextColor,
    //               ),
    //             ),
  }

  Widget _simplifiedCompletedExerciseListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RowItem(
          isCompact: true,
          minWidth: 50.0,
          maxWidth: 50.0,
          child: Text(
            '',
            style: TextStyleTemplates.defaultBoldTextStyle(
              ConfigProvider.mainTextColor,
            ),
          ),
        ),
        RowItem(
          hasCompactPadding: true,
          alignment: Alignment.centerLeft,
          child: Text(
            'Exercise',
            style: TextStyleTemplates.defaultBoldTextStyle(
              ConfigProvider.mainTextColor,
            ),
          ),
        ),
        RowItem(
          isCompact: true,
          alignment: Alignment.centerLeft,
          hasCompactPadding: true,
          minWidth: 135.0,
          maxWidth: 135.0,
          child: Text(
            'Last Set',
            style: TextStyleTemplates.defaultBoldTextStyle(
              ConfigProvider.mainTextColor,
            ),
          ),
        ),
      ],
    );
  }

  void _deleteWorkoutEntry(BuildContext context) async {
    var workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    var res = await Helper.showConfirmationDialogForm(
        context: context,
        message: ConfigProvider.deleteWorkoutEntryText,
        confimationButtonLabel: "CONFIRM",
        confirmationButtonColor: Colors.red,
        cancelButtonColor: ConfigProvider.backgroundColor,
        cancelButtonLabel: 'CANCEL');

    if (res ?? false) {
      workoutProvider.deleteWorkoutHistoryEntry(workout.id);
    }
  }

  void startWorkoutFromHistory({
    required BuildContext context,
    required bool startAsNew,
  }) async {
    var workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    var configProvider = Provider.of<ConfigProvider>(context, listen: false);
    var isUpdate = workoutProvider.updatingLoggedWorkout;
    var messge =
        'Are you sure you want to ${startAsNew ? "start from a past workout" : "start an update"}? There is ${!isUpdate ? "a workout" : "an update"} in progress. All progress will be lost.';
    bool? res = true;

    if (workoutProvider.isWorkoutInProgress()) {
      res = await Helper.showConfirmationDialogForm(
        context: context,
        message: messge,
        confimationButtonLabel: 'CONFIRM',
        confirmationButtonColor: Colors.red,
        cancelButtonColor: ConfigProvider.backgroundColor,
        cancelButtonLabel: 'RESUME IN PROGRESS',
      );

      if (res == null) {
        return;
      }
      if (res) {
        workoutProvider.startWorkoutFromHistory(
          workout: workout,
          shouldStartAsNew: startAsNew,
          showRestTimerAfterEachSet: configProvider.showRestTimerAfterEachSet,
        );
      }
    } else {
      workoutProvider.startWorkoutFromHistory(
        workout: workout,
        shouldStartAsNew: startAsNew,
        showRestTimerAfterEachSet: configProvider.showRestTimerAfterEachSet,
      );
    }
    navigateToWorkout();
  }

  @override
  Widget build(BuildContext context) {
    var endTimeString =
        DateFormat(ConfigProvider.defaulDateStampWithDayOfWeekFormat)
            .format(workout.endTime!)
            .toUpperCase();
    return DefaultContainer(
      onTap: () {
        Helper.showPopUp(
          context: context,
          title: workout.title != null && workout.title!.isNotEmpty
              ? workout.title!
              : endTimeString,
          content: SingleChildScrollView(
            child: Column(
              children: [
                WorkoutHistoryListItemSummary(
                  workout: workout,
                  isMetricSystemSelected: isMetricSystemSelected,
                ),
                WorkoutHistoryListItemBreakdown(
                  workout: workout,
                  isMetricSystemSelected: isMetricSystemSelected,
                )
              ],
            ),
          ),
        );
      },
      // color: ConfigProvider.backgroundColorSolid,
      // elevation: 0,
      // shape: const BorderDirectional(
      //   bottom: BorderSide(
      //     width: 1,
      //     color: ConfigProvider.slightContrastBackgroundColor,
      //   ),
      // ),

      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  workout.title != null && workout.title!.isNotEmpty
                      ? workout.title!
                      : endTimeString,
                  style: TextStyleTemplates.defaultBoldTextStyle(
                    ConfigProvider.mainTextColor,
                  ),
                ),
                const Spacer(),
                MenuAnchor(
                  style: const MenuStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                        ConfigProvider.backgroundColorSolid),
                    // elevation: WidgetStatePropertyAll<double>(0.0),
                  ),
                  builder: (BuildContext context, MenuController controller,
                      Widget? child) {
                    return IconButton(
                      icon: const Icon(
                        Icons.more_horiz_rounded,
                        color: ConfigProvider.mainColor,
                        size: ConfigProvider.defaultIconSize,
                      ),
                      // style: _theme.iconButtonTheme.style,
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                        // Provider.of<WorkoutProvider>(context, listen: false)
                        //     .deleteTrackedExercise(trackedExercise.id);
                      },
                    );
                  },
                  menuChildren: [
                    DefaultMenuItemButton(
                      icon: Icons.restart_alt_rounded,
                      label: 'REPEAT',
                      onPressed: () async {
                        startWorkoutFromHistory(
                          context: context,
                          startAsNew: true,
                        );
                      },
                    ),
                    DefaultMenuItemButton(
                      icon: Icons.edit_rounded,
                      label: 'UPDATE',
                      onPressed: () async {
                        startWorkoutFromHistory(
                          context: context,
                          startAsNew: false,
                        );
                      },
                    ),
                    DefaultMenuItemButton(
                        icon: Icons.delete_outline_rounded,
                        label: 'DELETE',
                        iconColor: Colors.red,
                        labelColor: Colors.red,
                        onPressed: () {
                          _deleteWorkoutEntry(context);
                        }),
                  ],
                ),
              ],
            ),
            WorkoutHistoryListItemSummary(
              workout: workout,
              isMetricSystemSelected: isMetricSystemSelected,
            ),
            _simplifiedCompletedExerciseListHeader(),
            ..._generateSimplifiedCompletedExerciseList(
              context: context,
              trackedExercises: workout.exercises,
            ),
            const SizedBox(height: ConfigProvider.defaultSpace),
          ],
        ),
      ),
    );
  }
}
