import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';
import '../../providers/exercise_provider.dart';
import '../../providers/config_provider.dart';

import '../../models/tracked_exercise_dto.dart';
import '../general/default_menu_item_button.dart';

import '../general/text_style_templates.dart';
import '_exercise_details_with_history.dart';
import '../exercise/_selectable_exercise_list.dart';

import '../helper.dart';

class TrackedExerciseListItemHeader extends StatelessWidget {
  final TrackedExerciseDto trackedExercise;
  final Function(int) onReorder;
  final Function() onReplaceExercise;

  const TrackedExerciseListItemHeader({
    super.key,
    required this.trackedExercise,
    required this.onReorder,
    required this.onReplaceExercise,
  });

  void _showExerciseDetailsWithHistory({
    required BuildContext context,
  }) async {
    var workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    var exerciseHistory =
        workoutProvider.getExerciseHistory(trackedExercise.exercise!.id);
    Helper.showPopUp(
      context: context,
      title: trackedExercise.exercise!.name,
      content: ExerciseDetailsWithHistory(
        exercise: trackedExercise.exercise!,
        exerciseHistory: exerciseHistory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var exerciseData = trackedExercise.exercise;
    return Container(
      padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
      decoration: const BoxDecoration(
        color: ConfigProvider.backgroundColorSolid,
        border: Border(
          bottom: BorderSide(width: 1, color: ConfigProvider.backgroundColor),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (exerciseData != null)
            Container(
              constraints: BoxConstraints(
                maxWidth: Helper.getMaxContentWidth(context,
                        maxContentWidthOverride: 600.0) -
                    150.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exerciseData!.name,
                    style: TextStyleTemplates.defaultTextStyle(
                      ConfigProvider.mainTextColor,
                    ),
                  ),
                  Text(
                    exerciseData.exerciseType.toUpperCase(),
                    style: TextStyleTemplates.smallTextStyle(
                      ConfigProvider.alternateTextColor,
                    ),
                  ),
                ],
              ),
            ),
          const Spacer(),
          if (exerciseData != null)
            IconButton(
              icon: const Icon(
                // Icons.auto_graph_rounded,
                Icons.info_outline_rounded,
                color: ConfigProvider.mainColor,
                size: ConfigProvider.defaultIconSize,
              ),
              // style: _theme.iconButtonTheme.style,
              onPressed: () {
                _showExerciseDetailsWithHistory(context: context);
              },
            ),
          MenuAnchor(
            style: const MenuStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(
                  ConfigProvider.backgroundColorSolid),
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
              if (exerciseData != null)
                DefaultMenuItemButton(
                  icon: Icons.play_circle_outline_rounded,
                  label: 'WATCH',
                  onPressed: () {
                    Helper.navigateToYoutube(
                      context: context,
                      youtubeId: exerciseData!.youtubeId,
                      searchQuery: exerciseData.name,
                    );
                  },
                ),
              if (exerciseData != null)
                DefaultMenuItemButton(
                  icon: Icons.repeat_rounded,
                  label: 'REPLACE',
                  onPressed: onReplaceExercise,
                ),
              DefaultMenuItemButton(
                icon: Icons.keyboard_arrow_up_rounded,
                label: 'MOVE UP',
                onPressed: () {
                  onReorder(-1);
                },
              ),
              DefaultMenuItemButton(
                icon: Icons.keyboard_arrow_down_rounded,
                label: 'MOVE DOWN',
                onPressed: () {
                  onReorder(1);
                },
              ),
              DefaultMenuItemButton(
                icon: Icons.delete_outline_rounded,
                label: 'DELETE',
                iconColor: Colors.red,
                labelColor: Colors.red,
                onPressed: () {
                  Provider.of<WorkoutProvider>(context, listen: false)
                      .deleteTrackedExercise(trackedExercise.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
