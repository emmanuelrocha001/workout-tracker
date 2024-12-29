import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/exercise_provider.dart';
import '../../providers/config_provider.dart';
import "../helper.dart";
import '../../models/exercise_dto.dart';
import '../../models/create_update_exercise_dto.dart';
import './create_update_exercise_form.dart';
import '../exercise/_exercise_filters_grid.dart';
import '../../class_extensions.dart';
import './exercise_list_item.dart';
import '../general/overlay_action_button.dart';
import './exercise_search_bar.dart';
import '_exercise_details.dart';

class EditableExerciseList extends StatefulWidget {
  final ScrollController scrollController;
  const EditableExerciseList({
    super.key,
    required this.scrollController,
  });

  @override
  State<EditableExerciseList> createState() => _EditableExerciseListState();
}

class _EditableExerciseListState extends State<EditableExerciseList> {
  void showDetails({
    required ExerciseDto exercise,
  }) async {
    Helper.showPopUp(
      title: exercise.name,
      context: context,
      content: ExerciseDetails(
        exercise: exercise,
      ),
    );
  }

  void updateExercise({
    required ExerciseDto exercise,
  }) async {
    var input = await Helper.showPopUp(
      title: 'Edit ${exercise.name}',
      context: context,
      content: SingleChildScrollView(
        child: CreateUpdateExerciseForm(
          exercise: exercise,
        ),
      ),
    );
    if (input != null && input is CreateUpdateExerciseDto && context.mounted) {
      var exerciseProvider = Provider.of<ExerciseProvider>(
        // ignore: use_build_context_synchronously
        context,
        listen: false,
      );
      var res = await exerciseProvider.updateUserDefinedExercise(
          exercise: exercise, input: input);
      if (context.mounted) {
        Helper.showMessageBar(
            // ignore: use_build_context_synchronously
            context: context,
            message: '${res.message}',
            isError: !res.success);
      }
    }
  }

  void deleteExercise({
    required ExerciseDto exercise,
  }) async {
    var confirm = await Helper.showConfirmationDialogForm(
        context: context,
        message:
            'Are you sure you want to delete "${exercise.name}"? This action cannot be undone.',
        confimationButtonLabel: "CONFIRM",
        confirmationButtonColor: Colors.red,
        cancelButtonColor: ConfigProvider.slightContrastBackgroundColor,
        cancelButtonLabel: 'CANCEL');

    if (!(confirm ?? false)) {
      return;
    }

    var exerciseProvider = Provider.of<ExerciseProvider>(
      // ignore: use_build_context_synchronously
      context,
      listen: false,
    );
    var res = await exerciseProvider.deleteUserDefinedExercise(
      exerciseId: exercise.id,
    );
    if (context.mounted) {
      Helper.showMessageBar(
        // ignore: use_build_context_synchronously
        context: context,
        message: '${res.message}',
        isError: !res.success,
      );
    }
  }

  void onFilter() {
    Helper.showPopUp(
      context: context,
      title: 'Filters',
      content: const ExerciseFiltersGrid(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var exerciseProvider = Provider.of<ExerciseProvider>(context);
    var exercises = exerciseProvider.exercises;
    return Scrollbar(
      controller: widget.scrollController,
      // thumbVisibility: true,
      radius: const Radius.circular(ConfigProvider.defaultSpace / 2),
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: <Widget>[
          ExerciseSearchBar(
            onFilter: onFilter,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ExerciseListItem(
                  data: exercises[index],
                  showDetails: showDetails,
                  updateExercise: updateExercise,
                  deleteExercise: deleteExercise,
                );
              },
              childCount: exercises.length,
            ),
          ),
        ],
      ),
    );
  }
}
