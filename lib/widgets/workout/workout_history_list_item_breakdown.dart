import 'package:flutter/material.dart';

import '../../models/workout_dto.dart';

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
                exercise: trackedExercise.exercise!,
                sets: trackedExercise.sets,
                isMetricSystemSelected: isMetricSystemSelected),
          )
          .toList(),
    );
  }
}
