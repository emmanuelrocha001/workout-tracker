import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/config_provider.dart';

import '../../providers/workout_provider.dart';
import '../../utility.dart';
import '../helper.dart';

import '../general/text_style_templates.dart';
import '../general/overlay_content.dart';

import 'workout_history_list_item.dart';

class WorkoutHistory extends StatefulWidget {
  const WorkoutHistory({super.key});

  @override
  State<WorkoutHistory> createState() => _WorkoutHistoryState();
}

class _WorkoutHistoryState extends State<WorkoutHistory> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // showCompletedWorkout();
    });
  }

  void showCompletedWorkout() {
    var workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    if (workoutProvider.showLatestWorkoutHistoryEntryAsFinished) {
      print("showCompletedWorkout");
      var workout = workoutProvider.latestWorkoutHistoryEntry;
      if (workout != null) {
        Helper.showPopUp(
          context: context,
          title: "Workout Completed",
          content: Center(
            child: WorkoutHistoryListItem(
              workout: workout,
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
    return OverlayContent(
      overLayContent: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
            child: Text(
              "Workout History",
              style: TextStyleTemplates.mediumBoldTextStyle(
                  ConfigProvider.mainTextColor),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
              child: TextButton(
                onPressed: () {
                  workoutProvider.startWorkout();
                },
                style: TextButton.styleFrom(
                  backgroundColor: ConfigProvider.mainColor,
                ),
                child: Text(
                  "Start Workout",
                  style: TextStyleTemplates.smallBoldTextStyle(
                    Utility.getTextColorBasedOnBackground(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      content: workoutProvider.workoutHistory.isNotEmpty
          ? ListView.builder(
              itemCount: workoutProvider.workoutHistory.length,
              itemBuilder: (context, index) {
                return WorkoutHistoryListItem(
                  workout: workoutProvider.workoutHistory[
                      workoutProvider.workoutHistory.length - index - 1],
                );
              },
            )
          : Center(
              child: Text(
                "No workout history",
                style: TextStyleTemplates.defaultTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
            ),
    );
  }
}
