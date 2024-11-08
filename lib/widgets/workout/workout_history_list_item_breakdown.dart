import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:provider/provider.dart';
import '../../providers/config_provider.dart';

import '../general/row_item.dart';
import '../general/text_style_templates.dart';
import '../../models/workout_dto.dart';
import '../../models/tracked_exercise_dto.dart';

class WorkoutHistoryListItemBreakdown extends StatelessWidget {
  final WorkoutDto workout;
  const WorkoutHistoryListItemBreakdown({
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
              '${index + 1}',
              style: TextStyleTemplates.defaultTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
          ),
          RowItem(
            isCompact: true,
            child: Text(
              '${set.weight}',
              style: TextStyleTemplates.defaultTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
          ),
          RowItem(
            isCompact: true,
            child: Text(
              'x ${set.reps}',
              style: TextStyleTemplates.defaultTextStyle(
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
    return Column(
      children: [
        ..._generateCompletedExerciseList(
          workout.exercises,
        ),
      ],
    );
  }
}
