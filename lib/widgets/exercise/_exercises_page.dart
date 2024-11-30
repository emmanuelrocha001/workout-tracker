import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/config_provider.dart';

import '../general/overlay_content.dart';
import '_editable_exercise_list.dart';
import '../general/text_style_templates.dart';
import '../general/default_tooltip.dart';

class ExercisesPage extends StatelessWidget {
  const ExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlayContent(
        overLayContent: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
              child: Text(
                "Exercises",
                style: TextStyleTemplates.mediumBoldTextStyle(
                    ConfigProvider.mainTextColor),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: ConfigProvider.defaultSpace),
              child: DefaultTooltip(
                message: ConfigProvider.exercisesPageToolTip,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: ConfigProvider.mainColor,
                  ),
                  child: Text(
                    "NEW EXERCISE",
                    style: TextStyleTemplates.smallBoldTextStyle(
                      ConfigProvider.backgroundColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        content: const Padding(
          padding: EdgeInsets.all(
            ConfigProvider.defaultSpace,
          ),
          child: EditableExerciseList(),
        ));
  }
}
