import 'package:flutter/material.dart';
import 'exercise/_exercise_filters_grid.dart';
import 'exercise/_exercise_list.dart';
import './helper.dart';

class ExerciseSelectionButton extends StatelessWidget {
  const ExerciseSelectionButton({super.key});

  void onSelectExercise(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onSelectExercise(context);
      },
      child: const Text('Open exercise selection'),
    );
  }
}
