import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import '../../providers/exercise_provider.dart';
import '../../providers/config_provider.dart';

import '../../models/muscle_group_dto.dart';
import '../../models/tracked_exercise_dto.dart';
import '../general/pill_container.dart';
import '../../widgets/general/text_style_templates.dart';

import '../helper.dart';
import '../../utility.dart';

class TrackedExerciseListItemHeader extends StatelessWidget {
  final TrackedExerciseDto trackedExercise;
  final bool showAsSimplified;
  const TrackedExerciseListItemHeader({
    super.key,
    required this.trackedExercise,
    this.showAsSimplified = false,
  });

  @override
  Widget build(BuildContext context) {
    var exerciseData = trackedExercise.exercise;
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
                        MuscleGroupDto.getMuscleGroupName(
                                exerciseData.muscleGroupId)
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
                if (!showAsSimplified)
                  IconButton(
                    icon: const Icon(
                      Feather.youtube,
                      color: ConfigProvider.mainColor,
                      size: ConfigProvider.defaultIconSize,
                    ),
                    // style: _theme.iconButtonTheme.style,
                    onPressed: () {
                      Helper.navigateToYoutube(
                        youtubeId: exerciseData.youtubeId,
                        searchQuery: exerciseData.name,
                      );
                    },
                  ),
                if (!showAsSimplified)
                  IconButton(
                    icon: const Icon(
                      Feather.more_vertical,
                      color: ConfigProvider.mainTextColor,
                      size: ConfigProvider.defaultIconSize,
                    ),
                    // style: _theme.iconButtonTheme.style,
                    onPressed: () {
                      // TODO add more options
                      Provider.of<ExerciseProvider>(context, listen: false)
                          .deleteTrackedExercise(trackedExercise.id);
                    },
                  ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exerciseData.name,
                    style: textTemplates.defaultTextStyle(
                      ConfigProvider.mainTextColor,
                    ),
                  ),
                  if (!showAsSimplified)
                    Text(
                      exerciseData.exerciseType.toUpperCase(),
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
