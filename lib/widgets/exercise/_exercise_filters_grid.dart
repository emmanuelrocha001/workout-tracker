import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/exercise_provider.dart';

import '../../models/filters_dto.dart';
import '../../models/muscle_group_dto.dart';
import '../../models/exercise_type_dto.dart';

import '../general/filter_grid.dart';

class ExerciseFiltersGrid extends StatefulWidget {
  const ExerciseFiltersGrid({super.key});

  @override
  State<ExerciseFiltersGrid> createState() => _ExerciseFiltersGridState();
}

class _ExerciseFiltersGridState extends State<ExerciseFiltersGrid> {
  List<FiltersDto> filters = [];
  bool filtersUpdated = false;
  static const String authorFiltersName = "Author";

  @override
  void initState() {
    super.initState();
    var exerciseProvider =
        Provider.of<ExerciseProvider>(context, listen: false);
    var muscleGroups =
        MuscleGroupDto.toFiltersDto(MuscleGroupDto.getMuscleGroups());
    print('muscle group length: ${muscleGroups.filters.length}');
    if (exerciseProvider.appliedMuscleGroupIdFilter.isNotEmpty) {
      muscleGroups.selectedValue = exerciseProvider.appliedMuscleGroupIdFilter;
      muscleGroups.tempSelectedValue = muscleGroups.selectedValue;
    }

    var exerciseTypes =
        ExerciseTypeDto.toFiltersDto(ExerciseTypeDto.getExerciseTypes());
    if (exerciseProvider.appliedExerciseType.isNotEmpty) {
      exerciseTypes.selectedValue = exerciseProvider.appliedExerciseType;
      exerciseTypes.tempSelectedValue = exerciseTypes.selectedValue;
    }

    var authorFilters = getAuthorFilters();
    if (exerciseProvider.appliedAuthor.isNotEmpty) {
      authorFilters.selectedValue = exerciseProvider.appliedAuthor;
      authorFilters.tempSelectedValue = authorFilters.selectedValue;
    }
    setState(() {
      filters = [authorFilters, muscleGroups, exerciseTypes];
    });
  }

  FiltersDto getAuthorFilters() {
    return FiltersDto(
      name: authorFiltersName,
      filters: ["System", "User"]
          .map(
            (value) => FilterDto(
              displayValue: value,
              value: value,
            ),
          )
          .toList(),
    );
  }

  void onSelect(String filterName, FilterDto value) {
    var filterToUpdate = filters.where((x) => x.name == filterName).firstOrNull;
    if (filterToUpdate != null) {
      setState(() {
        filterToUpdate.tempSelectedValue =
            filterToUpdate.tempSelectedValue != value.value ? value.value : "";
        print('filterName: $filterName value: $value');
      });
    }
  }

  void onApply() {
    print("applying filter");
    var exerciseProvider =
        Provider.of<ExerciseProvider>(context, listen: false);

    for (var filter in filters) {
      if (filter.tempSelectedValue != filter.selectedValue) {
        switch (filter.name) {
          case MuscleGroupDto.filterName:
            exerciseProvider
                .setAppliedMuscleGroupIdFilter(filter.tempSelectedValue);
            break;
          case ExerciseTypeDto.filterName:
            exerciseProvider.setAppliedExerciseType(filter.tempSelectedValue);
            break;
          case authorFiltersName:
            exerciseProvider.setAppliedAuthor(filter.tempSelectedValue);
            break;
          default:
            print("filter not supported");
        }
      }
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return FilterGrid(
      filters: filters,
      onSelect: onSelect,
      onApply: onApply,
    );
  }
}
