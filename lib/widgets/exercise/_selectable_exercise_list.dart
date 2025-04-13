import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/exercise_provider.dart';
import '../../providers/workout_provider.dart';
import '../../providers/config_provider.dart';

import "../helper.dart";

import '../../models/exercise_dto.dart';
import '../exercise/_exercise_filters_grid.dart';
import '../../class_extensions.dart';
import './exercise_list_item.dart';
import '../workout/_exercise_details_with_history.dart';
import '../general/overlay_action_button.dart';
import './exercise_search_bar.dart';

class SelectableExerciseList extends StatefulWidget {
  final bool isReplacing;
  const SelectableExerciseList({
    super.key,
    this.isReplacing = false,
  });

  @override
  State<SelectableExerciseList> createState() => _SelectableExerciseListState();
}

class _SelectableExerciseListState extends State<SelectableExerciseList> {
  String _selectedId = "";
  final ScrollController _scrollController = ScrollController();

  void _onSelect(String? id) {
    print(id);
    if (!id.isNullOrEmpty) {
      setState(() {
        _selectedId = id.toString();
      });
    }
  }

  void onFilter() {
    Helper.showPopUp(
      context: context,
      title: 'Filters',
      content: const ExerciseFiltersGrid(),
    );
  }

  void onAdd() {
    Navigator.of(context).pop(_selectedId);
  }

  void showDetails({
    required ExerciseDto exercise,
  }) async {
    var workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    var exerciseHistory = workoutProvider.getExerciseHistory(exercise.id);
    Helper.showPopUp(
      context: context,
      title: exercise.name,
      content: ExerciseDetailsWithHistory(
        exercise: exercise,
        exerciseHistory: exerciseHistory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var exerciseProvider = Provider.of<ExerciseProvider>(context);
    var exercises = exerciseProvider.exercises;
    return OverlayActionButton(
      label: !widget.isReplacing ? "ADD" : "REPLACE",
      showActionButton: _selectedId.isNotEmpty,
      onPressed: onAdd,
      content: Scrollbar(
        controller: _scrollController,
        radius: const Radius.circular(ConfigProvider.defaultSpace / 2),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            ExerciseSearchBar(
              onFilter: onFilter,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ExerciseListItem(
                    data: exercises[index],
                    selectedId: _selectedId,
                    onSelect: _onSelect,
                    showDetails: showDetails,
                  );
                },
                childCount: exercises.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
