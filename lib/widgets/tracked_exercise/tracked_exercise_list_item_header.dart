import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import '../../providers/config_provider.dart';

import '../../models/muscle_group_dto.dart';
import '../../models/tracked_exercise_dto.dart';
import '../general/pill_container.dart';
import '../../widgets/general/text_style_templates.dart';

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
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MuscleGroupDto.getMuscleGroupName(data.muscleGroupId).toUpperCase(),
            style: textTemplates.smallTextStyle(
              ConfigProvider.mainTextColor.withOpacity(
                ConfigProvider.mainTextColorWithOpacityPercent,
              ),
            ),
          ),
          Text(
            data.name,
            style: textTemplates.defaultTextStyle(
              ConfigProvider.mainTextColor,
            ),
          ),
        ],
      ),
      subtitle: Align(
        alignment: Alignment.centerLeft,
        child: PillContainer(
          color: ConfigProvider.slightContrastBackgroundColor,
          child: Text(
            data.exerciseType.toUpperCase(),
            style: textTemplates.defaultTextStyle(
              ConfigProvider.mainTextColor,
            ),
          ),
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Feather.youtube),
        style: _theme.iconButtonTheme.style,
        onPressed: () {},
      ),
    );
  }
}
