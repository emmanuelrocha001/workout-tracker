import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/workout_provider.dart';
import '../../utility.dart';

import '../general/text_style_templates.dart';
import '../general/overlay_content.dart';
import '../../providers/config_provider.dart';

class WorkoutActivity extends StatelessWidget {
  const WorkoutActivity({super.key});

  @override
  Widget build(BuildContext context) {
    var workoutProvider = Provider.of<WorkoutProvider>(
      context,
    );
    return OverlayContent(
      content: Placeholder(
        child: Text("placeholder"),
      ),
      overLayContent: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
            child: Text(
              "Workout Activity",
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
                  "Start Exercise",
                  style: TextStyleTemplates.smallBoldTextStyle(
                    Utility.getTextColorBasedOnBackground(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
