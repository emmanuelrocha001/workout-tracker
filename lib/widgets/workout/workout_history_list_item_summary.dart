import 'package:flutter/material.dart';
import '../../providers/config_provider.dart';

import '../general/row_item.dart';
import '../general/text_style_templates.dart';

import '../../models/workout_dto.dart';

class WorkoutHistoryListItemSummary extends StatelessWidget {
  final WorkoutDto workout;
  const WorkoutHistoryListItemSummary({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    var duration = workout.endTime!.difference(workout.startTime!).inMinutes;
    var hours = (duration / 60).floor();
    var minutes = duration % 60;

    return Padding(
      padding: const EdgeInsets.only(
        left: ConfigProvider.defaultSpace / 2,
        right: ConfigProvider.defaultSpace / 2,
        bottom: ConfigProvider.defaultSpace,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RowItem(
                isCompact: true,
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: ConfigProvider.mainTextColor,
                      size: ConfigProvider.smallIconSize,
                    ),
                    const SizedBox(width: ConfigProvider.defaultSpace / 2),
                    Text(
                      '${hours}h ${minutes}m',
                      style: TextStyleTemplates.defaultBoldTextStyle(
                        ConfigProvider.mainTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
