import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../general/overlay_content.dart';
import '../../providers/config_provider.dart';
import '../../providers/workout_provider.dart';

import '../general/text_style_templates.dart';

import '../../utility.dart';

class StartNewWorkout extends StatelessWidget {
  const StartNewWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    var workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    return OverlayContent(
      overLayContent: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
            child: Text(
              "Workout",
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
                  "START WORKOUT",
                  style: TextStyleTemplates.smallBoldTextStyle(
                    Utility.getTextColorBasedOnBackground(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      content: Center(
        child: Text(
          'No In Progress Workout',
          style:
              TextStyleTemplates.defaultTextStyle(ConfigProvider.mainTextColor),
        ),
      ),
    );
  }
}
