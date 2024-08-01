import 'package:flutter/material.dart';

import '../../models/tracked_exercise_dto.dart';
import './tracked_exercise_list_item_header.dart';
import './tracked_exercise_list_item_body.dart';

class TrackedExerciseListItem extends StatelessWidget {
  final TrackedExerciseDto trackedExercise;
  final showAsSimplified;
  const TrackedExerciseListItem(
      {super.key,
      required this.trackedExercise,
      this.showAsSimplified = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          TrackedExerciseListItemHeader(trackedExercise: trackedExercise),
          if (!showAsSimplified) const TrackedExerciseListItemBody()
        ],
      ),
    );
  }
}
