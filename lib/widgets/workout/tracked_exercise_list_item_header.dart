import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';
import '../../providers/config_provider.dart';

import '../../models/muscle_group_dto.dart';
import '../../models/tracked_exercise_dto.dart';
import '../general/pill_container.dart';
import '../general/text_style_templates.dart';

import '../helper.dart';
import '../../utility.dart';

class TrackedExerciseListItemHeader extends StatelessWidget {
  final TrackedExerciseDto trackedExercise;
  final Function(int) onReorder;
  final bool showAsSimplified;
  const TrackedExerciseListItemHeader({
    super.key,
    required this.trackedExercise,
    required this.onReorder,
    this.showAsSimplified = false,
  });

  @override
  Widget build(BuildContext context) {
    var exerciseData = trackedExercise.exercise;
    return Padding(
      padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
      child: Column(
        children: [
          Row(
            children: [
              PillContainer(
                color: trackedExercise.areSetsLogged()
                    ? Colors.green
                    : Colors.orangeAccent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      MuscleGroupDto.getMuscleGroupName(
                              exerciseData.muscleGroupId)
                          .toUpperCase(),
                      style: TextStyleTemplates.smallBoldTextStyle(
                        Utility.getTextColorBasedOnBackground(
                          backgroundColor: trackedExercise.areSetsLogged()
                              ? Colors.green
                              : Colors.orangeAccent,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.all(ConfigProvider.defaultSpace / 2),
                      child: Icon(
                        trackedExercise.areSetsLogged()
                            ? Icons.check
                            : Icons.watch_later_outlined,
                        color: Colors.white,
                        size: ConfigProvider.smallIconSize,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (!showAsSimplified)
                MenuAnchor(
                  style: const MenuStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                        ConfigProvider.backgroundColor),
                    // elevation: WidgetStatePropertyAll<double>(0.0),
                  ),
                  builder: (BuildContext context, MenuController controller,
                      Widget? child) {
                    return IconButton(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: ConfigProvider.mainTextColor,
                        size: ConfigProvider.defaultIconSize,
                      ),
                      // style: _theme.iconButtonTheme.style,
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                        // Provider.of<WorkoutProvider>(context, listen: false)
                        //     .deleteTrackedExercise(trackedExercise.id);
                      },
                    );
                  },
                  menuChildren: [
                    MenuItemButton(
                      child: const Tooltip(
                        message: 'Watch exercise video',
                        child: Icon(
                          Icons.play_circle_fill_rounded,
                          color: ConfigProvider.mainColor,
                          size: ConfigProvider.defaultIconSize,
                        ),
                      ),
                      onPressed: () {
                        Helper.navigateToYoutube(
                          youtubeId: exerciseData.youtubeId,
                          searchQuery: exerciseData.name,
                        );
                      },
                    ),
                    MenuItemButton(
                      child: const Tooltip(
                        message: 'Move exercise up',
                        child: Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: ConfigProvider.mainColor,
                        ),
                      ),
                      onPressed: () {
                        onReorder(-1);
                      },
                    ),
                    MenuItemButton(
                      child: const Tooltip(
                        message: 'Move exercise down',
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: ConfigProvider.mainColor,
                        ),
                      ),
                      onPressed: () {
                        onReorder(1);
                      },
                    ),
                    MenuItemButton(
                      child: const Tooltip(
                        message: 'Remove exercise',
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () {
                        Provider.of<WorkoutProvider>(context, listen: false)
                            .deleteTrackedExercise(trackedExercise.id);
                      },
                    ),
                  ],
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
                  style: TextStyleTemplates.defaultTextStyle(
                    ConfigProvider.mainTextColor,
                  ),
                ),
                if (!showAsSimplified)
                  Text(
                    exerciseData.exerciseType.toUpperCase(),
                    style: TextStyleTemplates.smallTextStyle(
                      ConfigProvider.alternateTextColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
