import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:provider/provider.dart';
import '../../providers/config_provider.dart';

import '../general/row_item.dart';
import '../general/text_style_templates.dart';
import '../../models/workout_dto.dart';
import '../../models/tracked_exercise_dto.dart';

import './workout_history_list_item_breakdown_exercise_item.dart';

class WorkoutHistoryListItemBreakdown extends StatelessWidget {
  final WorkoutDto workout;
  final bool isMetricSystemSelected;
  const WorkoutHistoryListItemBreakdown({
    super.key,
    required this.isMetricSystemSelected,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: workout.exercises
          .map(
            (trackedExercise) => WorkoutHistoryListItemBreakdownExerciseItem(
                trackedExercise: trackedExercise,
                isMetricSystemSelected: isMetricSystemSelected),
          )
          .toList(),
    );
  }
}
