import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/workout_provider.dart';

import './_tracked_exercise_list.dart';
import './_workout_activity_list.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    var workoutProvider = Provider.of<WorkoutProvider>(context);

    var isWorkoutInProgress = workoutProvider.isWorkoutInProgress();
    print("isWorkoutInProgress: $isWorkoutInProgress");
    return isWorkoutInProgress
        ? const TrackedExerciseList()
        : const WorkoutActivity();
  }
}
