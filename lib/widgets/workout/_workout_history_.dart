import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import '../general/confetti_default.dart';
import '../general/default_container.dart';
import '../workout/workout_history_list_item_breakdown.dart';
import '../workout/workout_history_list_item_summary.dart';
import '../../providers/config_provider.dart';

import '../../providers/workout_provider.dart';
import '../../utility.dart';
import '../helper.dart';

import '../general/text_style_templates.dart';
import '../general/overlay_content.dart';
import '../general/default_tooltip.dart';

import 'workout_history_list_item.dart';

class WorkoutHistory extends StatefulWidget {
  final void Function() navigateToWorkout;
  const WorkoutHistory({
    super.key,
    required this.navigateToWorkout,
  });

  @override
  State<WorkoutHistory> createState() => _WorkoutHistoryState();
}

class _WorkoutHistoryState extends State<WorkoutHistory> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showCompletedWorkout();
    });
  }

  void showCompletedWorkout() {
    var workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    var configProvider = Provider.of<ConfigProvider>(context, listen: false);
    if (workoutProvider.showLatestWorkoutHistoryEntryAsFinished) {
      print("showCompletedWorkout");
      var workout = workoutProvider.latestWorkoutHistoryEntry;
      if (workout != null) {
        workoutProvider.resetShowLatestWorkoutHistoryEntryAsFinished();
        var title =
            DateFormat(ConfigProvider.defaulDateStampWithDayOfWeekFormat)
                .format(workout.endTime!)
                .toUpperCase();
        Helper.showPopUp(
          context: context,
          title: title,
          content: Center(
            child: Stack(
              children: [
                Column(
                  children: [
                    WorkoutHistoryListItemSummary(workout: workout),
                    WorkoutHistoryListItemBreakdown(
                      isMetricSystemSelected:
                          configProvider.isMetricSystemSelected,
                      workout: workout,
                    )
                  ],
                ),
                const Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiDefault(),
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var workoutProvider = Provider.of<WorkoutProvider>(
      context,
    );
    var configProvider = Provider.of<ConfigProvider>(context, listen: false);
    return OverlayContent(
      overLayContent: Container(
        color: ConfigProvider.backgroundColorSolid,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
              child: Text(
                "History",
                style: TextStyleTemplates.mediumBoldTextStyle(
                    ConfigProvider.mainTextColor),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: ConfigProvider.defaultSpace),
              child: DefaultTooltip(
                message: ConfigProvider.workoutHistoryToolTip,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      content: workoutProvider.workoutHistory.isNotEmpty
          ? ListView.builder(
              itemCount: workoutProvider.workoutHistory.length,
              padding: const EdgeInsets.all(ConfigProvider.defaultSpace / 2),
              itemBuilder: (context, index) {
                return WorkoutHistoryListItem(
                  isMetricSystemSelected: configProvider.isMetricSystemSelected,
                  workout: workoutProvider.workoutHistory[
                      workoutProvider.workoutHistory.length - index - 1],
                  navigateToWorkout: widget.navigateToWorkout,
                );
              },
            )
          : Center(
              child: Text(
                "No Workout History",
                style: TextStyleTemplates.defaultTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
            ),
    );
  }
}
