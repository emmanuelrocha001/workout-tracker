import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:provider/provider.dart';
import '../../models/tracked_exercise_dto.dart';
import '../../providers/config_provider.dart';

import '../general/row_item.dart';
import '../general/text_style_templates.dart';
import '../general/default_tooltip.dart';
import '../../models/exercise_dto.dart';

class WorkoutHistoryListItemBreakdownExerciseItem extends StatelessWidget {
  final ExerciseDto exercise;
  final List<ISetDto> sets;
  final bool isMetricSystemSelected;
  const WorkoutHistoryListItemBreakdownExerciseItem({
    super.key,
    required this.exercise,
    required this.sets,
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
        if (exercise.dimensions?.isWeightEnabled ?? true)
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
        if (exercise.dimensions?.isRepEnabled ?? true)
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
        if (exercise.dimensions?.isDistanceEnabled ?? true)
          RowItem(
            isCompact: true,
            alignment: Alignment.centerLeft,
            hasCompactPadding: true,
            minWidth: 125.0,
            maxWidth: 125.0,
            child: Text(
              'Distance(${isMetricSystemSelected ? "km" : "mi"})',
              style: TextStyleTemplates.defaultBoldTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
          ),
        if (exercise.dimensions?.isTimeEnabled ?? true)
          RowItem(
            isCompact: true,
            alignment: Alignment.centerLeft,
            hasCompactPadding: true,
            minWidth: 100.0,
            maxWidth: 100.0,
            child: Row(
              children: [
                Text(
                  'Time',
                  style: TextStyleTemplates.defaultBoldTextStyle(
                    ConfigProvider.mainTextColor,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ConfigProvider.defaultSpace / 2),
                  child: DefaultTooltip(
                    message: 'hh:mm:ss',
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  List<Widget> _generateSetRows(List<ISetDto> sets) {
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
          if (exercise.dimensions?.isWeightEnabled ?? true)
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
          if (exercise.dimensions?.isRepEnabled ?? true)
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
          if (exercise.dimensions?.isDistanceEnabled ?? true)
            RowItem(
              isCompact: true,
              minWidth: 125.0,
              maxWidth: 125.0,
              alignment: Alignment.centerLeft,
              child: Text(
                set.distance.toString(),
                style: TextStyleTemplates.defaultTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
            ),
          if (exercise.dimensions?.isTimeEnabled ?? true)
            RowItem(
              isCompact: true,
              minWidth: 100.0,
              maxWidth: 100.0,
              alignment: Alignment.centerLeft,
              child: Text(
                set.time ?? "",
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
            exercise.name,
            style: TextStyleTemplates.defaultTextStyle(
              ConfigProvider.mainTextColor,
            ),
          ),
        ),
        _getRowHeader(),
        ..._generateSetRows(sets),
        const SizedBox(height: ConfigProvider.defaultSpace / 2),
      ],
    );
  }
}
