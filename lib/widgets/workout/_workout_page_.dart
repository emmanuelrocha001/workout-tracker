import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/workout_provider.dart';

import './_tracked_exercise_list.dart';
import './_start_new_workout.dart';

class WorkoutPage extends StatelessWidget {
  final void Function() navigateToWorkoutHistory;
  const WorkoutPage({
    super.key,
    required this.navigateToWorkoutHistory,
  });

  @override
  Widget build(BuildContext context) {
    var workoutProvider = Provider.of<WorkoutProvider>(context);

    var isWorkoutInProgress = workoutProvider.isWorkoutInProgress();
    return isWorkoutInProgress
        ? TrackedExerciseList(
            navigateToWorkoutHistory: navigateToWorkoutHistory,
          )
        : const StartNewWorkout();
  }
}
