import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/exercise_provider.dart';

import "../helper.dart";
import '../../models/exercise_dto.dart';
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
  void _showDetails({
    required ExerciseDto exercise,
    required bool inEditMode,
  }) async {
    Helper.showPopUp(
      title: exercise.name,
      context: context,
      content: ExerciseDetails(
        exercise: exercise,
        inEditMode: inEditMode,
      ),
    );
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
    return CustomScrollView(
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
                showDetails: _showDetails,
              );
            },
            childCount: exercises.length,
          ),
        ),
      ],
    );
  }
}
