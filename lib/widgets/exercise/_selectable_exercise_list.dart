import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/exercise_provider.dart';
import '../../providers/config_provider.dart';

import "../helper.dart";

import '../exercise/_exercise_filters_grid.dart';
import '../../class_extensions.dart';
import './exercise_list_item.dart';
import '../general/overlay_action_button.dart';
import './exercise_search_bar.dart';

class SelectableExerciseList extends StatefulWidget {
  const SelectableExerciseList({super.key});

  @override
  State<SelectableExerciseList> createState() => _SelectableExerciseListState();
}

class _SelectableExerciseListState extends State<SelectableExerciseList> {
  String _selectedId = "";

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

  @override
  Widget build(BuildContext context) {
    var exerciseProvider = Provider.of<ExerciseProvider>(context);
    var exercises = exerciseProvider.exercises;
    return OverlayActionButton(
      label: "ADD",
      showActionButton: _selectedId.isNotEmpty,
      onPressed: onAdd,
      content: Scrollbar(
        radius: const Radius.circular(ConfigProvider.defaultSpace / 2),
        child: CustomScrollView(
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
