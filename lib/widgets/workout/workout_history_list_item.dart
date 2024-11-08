import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../general/text_style_templates.dart';
import '../../providers/config_provider.dart';
import '../../providers/workout_provider.dart';

import '../../models/workout_dto.dart';
import '../../models/tracked_exercise_dto.dart';

import '../general/row_item.dart';
import './workout_history_list_item_summary.dart';
import './workout_history_list_item_breakdown.dart';

import '../helper.dart';

class WorkoutHistoryListItem extends StatelessWidget {
  final WorkoutDto workout;
  final void Function() navigateToWorkout;
  const WorkoutHistoryListItem({
    super.key,
    required this.workout,
    required this.navigateToWorkout,
  });

  List<Widget> _generateSimplifiedCompletedExerciseList(
      List<TrackedExerciseDto> trackedExercises) {
    return trackedExercises.map((
      trackedExercise,
    ) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RowItem(
            isCompact: true,
            child: Text(
              '${trackedExercise.sets.length} x',
              style: TextStyleTemplates.defaultTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
          ),
          RowItem(
            hasCompactPadding: true,
            alignment: Alignment.centerLeft,
            child: Text(
              trackedExercise.exercise.name,
              style: TextStyleTemplates.defaultTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
          ),
          RowItem(
            isCompact: true,
            alignment: Alignment.centerLeft,
            minWidth: 70.0,
            child: Text(
              '${trackedExercise.sets.last.weight} lbs x ',
              style: TextStyleTemplates.defaultTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
          ),
          RowItem(
            isCompact: true,
            minWidth: 70.0,
            alignment: Alignment.centerLeft,
            child: Text(
              '${trackedExercise.sets.last.reps}',
              style: TextStyleTemplates.defaultTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _simplifiedCompletedExerciseListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RowItem(
          isCompact: true,
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
          minWidth: 140.0,
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
        cancelButtonColor: ConfigProvider.slightContrastBackgroundColor,
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
        cancelButtonColor: ConfigProvider.slightContrastBackgroundColor,
        cancelButtonLabel: 'RESUME IN PROGRESS',
      );

      if (res == null) {
        return;
      }
      if (res) {
        workoutProvider.startWorkoutFromHistory(
          workout: workout,
          shouldStartAsNew: startAsNew,
        );
      }
    } else {
      workoutProvider.startWorkoutFromHistory(
        workout: workout,
        shouldStartAsNew: startAsNew,
      );
    }
    navigateToWorkout();
  }

  @override
  Widget build(BuildContext context) {
    var title = DateFormat(ConfigProvider.defaultDateStampFormat)
        .format(workout.endTime!)
        .toUpperCase();
    return Card(
      color: ConfigProvider.backgroundColor,
      elevation: 0,
      shape: const BorderDirectional(
        bottom: BorderSide(
          width: 1,
          color: ConfigProvider.slightContrastBackgroundColor,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyleTemplates.defaultBoldTextStyle(
                    ConfigProvider.mainTextColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.fullscreen_rounded,
                    color: ConfigProvider.mainColor,
                    size: ConfigProvider.defaultIconSize,
                  ),
                  // style: _theme.iconButtonTheme.style,
                  onPressed: () {
                    Helper.showPopUp(
                      context: context,
                      title: title,
                      content: Center(
                        child: Column(
                          children: [
                            WorkoutHistoryListItemSummary(workout: workout),
                            WorkoutHistoryListItemBreakdown(workout: workout)
                          ],
                        ),
                      ),
                    );
                  },
                ),
                MenuAnchor(
                  style: const MenuStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                        ConfigProvider.backgroundColor),
                    // elevation: WidgetStatePropertyAll<double>(0.0),
                  ),
                  builder: (BuildContext context, MenuController controller,
                      Widget? child) {
                    return IconButton(
                      icon: const Icon(
                        Icons.more_horiz_rounded,
                        color: ConfigProvider.mainTextColor,
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
                    MenuItemButton(
                      child: const Tooltip(
                        message: 'Start from past workout',
                        child: Icon(
                          Icons.restart_alt_rounded,
                          color: ConfigProvider.mainColor,
                          size: ConfigProvider.defaultIconSize,
                        ),
                      ),
                      onPressed: () async {
                        startWorkoutFromHistory(
                          context: context,
                          startAsNew: true,
                        );
                      },
                    ),
                    MenuItemButton(
                      child: const Tooltip(
                        message: 'Update workout entry',
                        child: Icon(
                          Icons.edit_rounded,
                          color: ConfigProvider.mainColor,
                          size: ConfigProvider.defaultIconSize,
                        ),
                      ),
                      onPressed: () async {
                        startWorkoutFromHistory(
                          context: context,
                          startAsNew: false,
                        );
                      },
                    ),
                    MenuItemButton(
                        child: const Tooltip(
                          message: 'Delete workout entry',
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                            size: ConfigProvider.defaultIconSize,
                          ),
                        ),
                        onPressed: () {
                          _deleteWorkoutEntry(context);
                        }),
                  ],
                ),
              ],
            ),
            WorkoutHistoryListItemSummary(workout: workout),
            _simplifiedCompletedExerciseListHeader(),
            ..._generateSimplifiedCompletedExerciseList(
              workout.exercises,
            ),
            const SizedBox(height: ConfigProvider.defaultSpace),
          ],
        ),
      ),
    );
  }
}
