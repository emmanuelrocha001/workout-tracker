import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/config_provider.dart';

import '../../providers/exercise_provider.dart';

import "../helper.dart";
import '../exercise/_exercise_filters_grid.dart';
import '../../models/muscle_group_dto.dart';
import '../../class_extensions.dart';
import './search_form.dart';
import 'exercise_list_item.dart';
import './filtered_by.dart';

class ExerciseListUpdated extends StatefulWidget {
  const ExerciseListUpdated({super.key});

  @override
  State<ExerciseListUpdated> createState() => _ExerciseListUpdatedState();
}

class _ExerciseListUpdatedState extends State<ExerciseListUpdated> {
  String _selectedId = "";

  void _onSelect(String? id) {
    print(id);
    if (!id.isNullOrEmpty) {
      setState(() {
        _selectedId = id.toString();
      });
    }
  }

  void _updateSearchTerm(String term) {
    Provider.of<ExerciseProvider>(context, listen: false)
        .setAppliedSearchFilter(term);
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
      slivers: <Widget>[
        SliverAppBar(
          surfaceTintColor: ConfigProvider.backgroundColor,
          shadowColor: ConfigProvider.slightContrastBackgroundColor,
          foregroundColor: ConfigProvider.backgroundColor,
          backgroundColor: ConfigProvider.backgroundColor,
          forceMaterialTransparency: false,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.none,
            expandedTitleScale: 1.0,
            titlePadding: EdgeInsets.zero,
            title: Column(
              children: [
                const SearchForm(),
                FilteredBy(
                  filters: [
                    exerciseProvider.appliedMuscleGroupIdFilter.isEmpty
                        ? exerciseProvider.appliedMuscleGroupIdFilter
                        : MuscleGroupDto.getMuscleGroupName(
                            exerciseProvider.appliedMuscleGroupIdFilter),
                    exerciseProvider.appliedExerciseType,
                  ],
                  onClearFilters: () {
                    exerciseProvider.clearFilters();
                  },
                  onFilter: onFilter,
                ),
                const Divider(
                  height: ConfigProvider.defaultSpace / 2,
                  color: ConfigProvider.slightContrastBackgroundColor,
                  // thickness: 1.0,
                ),
              ],
            ),
          ),
          expandedHeight: 100.0,
          collapsedHeight: 100.0,
          actions: [],
          centerTitle: true,
          pinned: true,
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
    );
  }
}
