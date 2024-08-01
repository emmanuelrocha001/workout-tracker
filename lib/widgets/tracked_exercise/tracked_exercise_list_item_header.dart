import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import '../../providers/config_provider.dart';

import '../../models/muscle_group_dto.dart';
import '../../models/tracked_exercise_dto.dart';
import '../general/pill_container.dart';
import '../../widgets/general/text_style_templates.dart';

import '../../utility.dart';

class TrackedExerciseListItemHeader extends StatelessWidget {
  final TrackedExerciseDto trackedExercise;
  const TrackedExerciseListItemHeader({
    super.key,
    required this.trackedExercise,
  });

  @override
  Widget build(BuildContext context) {
    var data = trackedExercise.exercise;
    var _theme = Theme.of(context);
    var textTemplates = TextStyleTemplates();
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
        child: Column(
          children: [
            Row(
              children: [
                PillContainer(
                  color: Colors.orangeAccent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        MuscleGroupDto.getMuscleGroupName(data.muscleGroupId)
                            .toUpperCase(),
                        style: textTemplates.smallBoldTextStyle(
                          Utility.getTextColorBasedOnBackground(
                            backgroundColor: Colors.orangeAccent,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: const EdgeInsets.all(
                            ConfigProvider.defaultSpace / 2),
                        child: const Icon(
                          Feather.clock,
                          color: Colors.orange,
                          size: ConfigProvider.smallIconSize,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Feather.youtube,
                    color: ConfigProvider.mainColor,
                    size: ConfigProvider.defaultIconSize,
                  ),
                  // style: _theme.iconButtonTheme.style,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Feather.more_vertical,
                    color: ConfigProvider.mainTextColor,
                    size: ConfigProvider.defaultIconSize,
                  ),
                  // style: _theme.iconButtonTheme.style,
                  onPressed: () {},
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: textTemplates.defaultTextStyle(
                      ConfigProvider.mainTextColor,
                    ),
                  ),
                  Text(
                    data.exerciseType.toUpperCase(),
                    style: textTemplates.smallTextStyle(
                      ConfigProvider.alternateTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
