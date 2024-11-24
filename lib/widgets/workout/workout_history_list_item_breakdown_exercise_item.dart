import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:provider/provider.dart';
import '../../providers/config_provider.dart';

import '../general/row_item.dart';
import '../general/text_style_templates.dart';
import '../../models/workout_dto.dart';
import '../../models/tracked_exercise_dto.dart';

class WorkoutHistoryListItemBreakdownExerciseItem extends StatelessWidget {
  final TrackedExerciseDto trackedExercise;
  final bool isMetricSystemSelected;
  const WorkoutHistoryListItemBreakdownExerciseItem({
    super.key,
    required this.trackedExercise,
    required this.isMetricSystemSelected,
  });

  Widget _getRowHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RowItem(
          alignment: Alignment.centerLeft,
          isCompact: true,
          minWidth: 45.0,
          maxWidth: 45.0,
          child: Text(
            'Set',
            style: TextStyleTemplates.defaultBoldTextStyle(
              ConfigProvider.mainTextColor,
            ),
          ),
        ),
        RowItem(
          isCompact: true,
          hasCompactPadding: true,
          minWidth: 100.0,
          maxWidth: 100.0,
          alignment: Alignment.centerLeft,
          child: Text(
            'Weight(${isMetricSystemSelected ? "kg" : "lb"})',
            style: TextStyleTemplates.defaultBoldTextStyle(
              ConfigProvider.mainTextColor,
            ),
          ),
        ),
        RowItem(
          isCompact: true,
          alignment: Alignment.centerLeft,
          hasCompactPadding: true,
          minWidth: 45.0,
          maxWidth: 45.0,
          child: Text(
            'Reps',
            style: TextStyleTemplates.defaultBoldTextStyle(
              ConfigProvider.mainTextColor,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _generateSetRows(List<SetDto> sets) {
    return sets.mapIndexed((index, set) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RowItem(
            alignment: Alignment.centerLeft,
            isCompact: true,
            maxWidth: 45.0,
            minWidth: 45.0,
            child: Text(
              '${index + 1}',
              style: TextStyleTemplates.defaultTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
          ),
          RowItem(
            isCompact: true,
            alignment: Alignment.centerLeft,
            minWidth: 100.0,
            maxWidth: 100.0,
            child: Text(
              '${set.weight}',
              style: TextStyleTemplates.defaultTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
          ),
          RowItem(
            isCompact: true,
            minWidth: 45.0,
            maxWidth: 45.0,
            alignment: Alignment.centerLeft,
            child: Text(
              'x ${set.reps}',
              style: TextStyleTemplates.defaultTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(vertical: ConfigProvider.defaultSpace),
          child: Text(
            trackedExercise.exercise.name,
            style: TextStyleTemplates.defaultTextStyle(
              ConfigProvider.mainTextColor,
            ),
          ),
        ),
        _getRowHeader(),
        ..._generateSetRows(trackedExercise.sets),
        const SizedBox(height: ConfigProvider.defaultSpace / 2),
      ],
    );
  }
}
