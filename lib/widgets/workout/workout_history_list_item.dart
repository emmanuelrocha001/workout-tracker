import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../general/text_style_templates.dart';
import '../../providers/config_provider.dart';

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
            Text(
              title,
              style: TextStyleTemplates.defaultBoldTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
            ..._generateCompletedExerciseList(
              workout.exercises,
            )
          ],
        ),
      ),
    );
  }
}
