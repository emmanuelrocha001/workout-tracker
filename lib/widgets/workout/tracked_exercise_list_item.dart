import 'package:flutter/material.dart';
import '../../utility.dart';

import '../../providers/config_provider.dart';

import '../../models/tracked_exercise_dto.dart';
import 'tracked_exercise_list_item_header.dart';
import 'tracked_exercise_list_item_body.dart';

class TrackedExerciseListItem extends StatelessWidget {
  final TrackedExerciseDto trackedExercise;
  final bool showAsSimplified;
  final Function(int) onReorder;
  const TrackedExerciseListItem(
      {super.key,
      required this.trackedExercise,
      required this.onReorder,
      this.showAsSimplified = false});

  @override
  Widget build(BuildContext context) {
    // var sets = [
    //   SetDto(reps: 10, weight: 145),
    //   SetDto(reps: 10, weight: 155),
    //   SetDto(reps: 10, weight: 165),
    //   SetDto(reps: 10, weight: 145),
    //   SetDto(reps: 10, weight: 155),
    //   SetDto(reps: 10, weight: 165),
    // ];
    return Card(
      color: ConfigProvider.backgroundColor,
      elevation: 0,
      shape: const BorderDirectional(
        bottom: BorderSide(
          width: 1,
          color: ConfigProvider.slightContrastBackgroundColor,
        ),
      ),
      child: Column(
        children: [
          TrackedExerciseListItemHeader(
            trackedExercise: trackedExercise,
            onReorder: onReorder,
            showAsSimplified: showAsSimplified,
          ),
          if (!showAsSimplified)
            TrackedExerciseListItemBody(
              trackedExerciseId: trackedExercise.id,
              sets: trackedExercise.sets.map((x) => SetDto.getCopy(x)).toList(),
            )
        ],
      ),
    );
  }
}
