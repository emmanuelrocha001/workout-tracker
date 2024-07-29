import 'package:flutter/material.dart';
import 'exercise/_exercise_filters_grid.dart';
import 'exercise/_exercise_list_updated.dart';
import './helper.dart';

class ExerciseSelectionButton extends StatelessWidget {
  const ExerciseSelectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async => {
        await Helper.showPopUp(
          context: context,
          title: 'Exercises',
          content: const ExerciseListUpdated(),
        ),
      },
      child: const Text('Open exercise selection'),
    );
  }
}
