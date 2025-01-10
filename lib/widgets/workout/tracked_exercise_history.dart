import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:collection/collection.dart';
import '../../models/exercise_dto.dart';
import '../../providers/config_provider.dart';
import '../../models/tracked_exercise_dto.dart';
import '../../models/tracked_exercise_history_entry_dto.dart';

import '../general/text_style_templates.dart';

import './workout_history_list_item_breakdown_exercise_item.dart';

class TrackedExerciseHistory extends StatelessWidget {
  final ExerciseDto exercise;
  final List<TrackedExerciseHistoryEntryDto>? entries;
  final bool isMetricSystemSelected;
  final ScrollController scrollController;

  const TrackedExerciseHistory({
    super.key,
    required this.exercise,
    required this.entries,
    required this.isMetricSystemSelected,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
      child: entries != null
          ? Scrollbar(
              controller: scrollController,
              // thumbVisibility: true,
              radius: const Radius.circular(ConfigProvider.defaultSpace / 2),
              child: ListView.builder(
                controller: scrollController,
                itemCount: entries!.length,
                itemBuilder: (context, index) {
                  return TrackedExerciseHistoryItem(
                    exercise: exercise,
                    sets: entries![entries!.length - 1 - index].sets,
                    timeStamp:
                        entries![entries!.length - 1 - index].workoutStartDate,
                    isMetricSystemSelected: isMetricSystemSelected,
                  );
                },
              ),
            )
          : Center(
              child: Text(
                "No history found",
                style: TextStyleTemplates.defaultTextStyle(
                    ConfigProvider.mainTextColor),
              ),
            ),
    );
  }
}

class TrackedExerciseHistoryItem extends StatelessWidget {
  final ExerciseDto exercise;
  final List<ISetDto> sets;
  final DateTime timeStamp;
  final bool isMetricSystemSelected;
  const TrackedExerciseHistoryItem({
    super.key,
    required this.exercise,
    required this.sets,
    required this.timeStamp,
    required this.isMetricSystemSelected,
  });

  @override
  Widget build(BuildContext context) {
    var startDateString =
        DateFormat(ConfigProvider.defaultDateStampFormatWithTime)
            .format(timeStamp)
            .toUpperCase();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: ConfigProvider.defaultSpace,
            bottom: ConfigProvider.defaultSpace / 2,
          ),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: ConfigProvider.slightContrastBackgroundColor,
              ),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              startDateString,
              style: TextStyleTemplates.defaultTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: ConfigProvider.defaultSpace / 2,
          ),
          child: WorkoutHistoryListItemBreakdownExerciseItemHeader(
              dimensions: exercise.dimensions,
              isMetricSystemSelected: isMetricSystemSelected),
        ),
        ...sets.mapIndexed(
          (index, set) => WorkoutHistoryListItemBreakdownExerciseItemSet(
            exercise: exercise,
            set: set,
            index: index,
            isMetricSystemSelected: isMetricSystemSelected,
          ),
        ),
      ],
    );
  }
}
