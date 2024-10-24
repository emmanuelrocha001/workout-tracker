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

class WorkoutHistoryListItem extends StatelessWidget {
  final WorkoutDto workout;
  const WorkoutHistoryListItem({
    super.key,
    required this.workout,
  });

  List<Widget> _generateSetRows(List<SetDto> sets) {
    return sets.mapIndexed((index, set) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RowItem(
            isCompact: true,
            child: Text(
              '$index',
              style: TextStyleTemplates.smallTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
          ),
          RowItem(
            isCompact: true,
            child: Text(
              '${set.weight}',
              style: TextStyleTemplates.smallTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
          ),
          RowItem(
            isCompact: true,
            child: Text(
              'x ${set.reps}',
              style: TextStyleTemplates.smallTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  List<Widget> _generateCompletedExerciseList(
      List<TrackedExerciseDto> trackedExercises) {
    return trackedExercises.map((trackedExercise) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trackedExercise.exercise.name,
            style: TextStyleTemplates.defaultTextStyle(
              ConfigProvider.mainTextColor,
            ),
          ),
          ..._generateSetRows(trackedExercise.sets),
          const SizedBox(height: ConfigProvider.defaultSpace / 2),
        ],
      );
    }).toList();
  }

  Widget _getWorkoutSummary() {
    var duration = workout.endTime!.difference(workout.startTime!).inMinutes;
    var hours = (duration / 60).floor();
    var minutes = duration % 60;

    return Padding(
      padding: const EdgeInsets.only(
        left: ConfigProvider.defaultSpace / 2,
        right: ConfigProvider.defaultSpace / 2,
        bottom: ConfigProvider.defaultSpace,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RowItem(
                isCompact: true,
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: ConfigProvider.mainTextColor,
                      size: ConfigProvider.smallIconSize,
                    ),
                    const SizedBox(width: ConfigProvider.defaultSpace / 2),
                    Text(
                      '${hours}h ${minutes}m',
                      style: TextStyleTemplates.defaultBoldTextStyle(
                        ConfigProvider.mainTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              // RowItem(
              //   isCompact: true,
              //   child: Text(
              //     '${set.weight}',
              //     style: TextStyleTemplates.smallTextStyle(
              //       ConfigProvider.mainTextColor,
              //     ),
              //   ),
              // ),
              // RowItem(
              //   isCompact: true,
              //   child: Text(
              //     'x ${set.reps}',
              //     style: TextStyleTemplates.smallTextStyle(
              //       ConfigProvider.mainTextColor,
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
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
                      onPressed: () {
                        workoutProvider.startWorkoutFromHistory(
                            workout: workout, shouldStartAsNew: true);
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
                      onPressed: () {
                        workoutProvider.startWorkoutFromHistory(
                          workout: workout,
                          shouldStartAsNew: false,
                        );
                      },
                    ),
                    // MenuItemButton(
                    //   child: const Tooltip(
                    //     message: 'Delete workout entry',
                    //     child: Icon(
                    //       Icons.delete_outline_rounded,
                    //       color: Colors.red,
                    //       size: ConfigProvider.defaultIconSize,
                    //     ),
                    //   ),
                    //   onPressed: () {},
                    // ),
                  ],
                ),
              ],
            ),
            _getWorkoutSummary(),
            ..._generateCompletedExerciseList(
              workout.exercises,
            )
          ],
        ),
      ),
    );
  }
}
