import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/exercise_provider.dart';
import '../../providers/config_provider.dart';
import './search_form.dart';
import './filtered_by.dart';

import '../../models/muscle_group_dto.dart';

class ExerciseSearchBar extends StatelessWidget {
  final void Function() onFilter;
  const ExerciseSearchBar({super.key, required this.onFilter});

  @override
  Widget build(BuildContext context) {
    var exerciseProvider = Provider.of<ExerciseProvider>(context);
    return SliverAppBar(
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
    );
  }
}
