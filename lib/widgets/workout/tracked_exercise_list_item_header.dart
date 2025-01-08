import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';
import '../../providers/config_provider.dart';

import '../../models/muscle_group_dto.dart';
import '../../models/tracked_exercise_dto.dart';
import '../general/pill_container.dart';
import '../general/text_style_templates.dart';
import './workout_history_list_item_breakdown_exercise_item.dart';
import './_tracked_exercise_history.dart';

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

  void _showExerciseHistory({
    required BuildContext context,
  }) async {
    var configProvider = Provider.of<ConfigProvider>(context, listen: false);
    var workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    var exerciseHistory =
        workoutProvider.getExerciseHistory(trackedExercise.exercise.id);
    await Helper.showPopUp(
      context: context,
      title: trackedExercise.exercise.name,
      // subTitle: MuscleGroupDto.getMuscleGroupName(
      //   trackedExercise.exercise.muscleGroupId,
      // ).toUpperCase(),
      content: TrackedExerciseHistory(
        exercise: trackedExercise.exercise,
        entries: exerciseHistory,
        isMetricSystemSelected: configProvider.isMetricSystemSelected,
      ),
    );
    // if (exerciseId != null && exerciseId.isNotEmpty) {
    //   if (context.mounted) {
    //     var workoutProvider =
    //         // ignore: use_build_context_synchronously
    //         Provider.of<WorkoutProvider>(context, listen: false);
    //     var exerciseProvider =
    //         // ignore: use_build_context_synchronously
    //         Provider.of<ExerciseProvider>(context, listen: false);
    //     var exercise = exerciseProvider.getExerciseById(exerciseId);

    //     if (exercise == null) return;

    //     workoutProvider.addTrackedExercise(exercise);
    //     print('FROM selector ${exerciseId}');
    //   }
    // }
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
          const Spacer(),
          if (!showAsSimplified)
            IconButton(
              icon: const Icon(
                // Icons.auto_graph_rounded,
                Icons.info_outline_rounded,
                color: ConfigProvider.mainColor,
                size: ConfigProvider.defaultIconSize,
              ),
              // style: _theme.iconButtonTheme.style,
              onPressed: () {
                _showExerciseHistory(context: context);
              },
            ),
          if (!showAsSimplified)
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
                MenuItemButton(
                  child: const Icon(
                    Icons.play_circle_fill_rounded,
                    color: ConfigProvider.mainColor,
                    size: ConfigProvider.defaultIconSize,
                  ),
                  onPressed: () {
                    Helper.navigateToYoutube(
                      youtubeId: exerciseData.youtubeId,
                      searchQuery: exerciseData.name,
                    );
                  },
                ),
                MenuItemButton(
                  child: const Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: ConfigProvider.mainColor,
                  ),
                  onPressed: () {
                    onReorder(-1);
                  },
                ),
                MenuItemButton(
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: ConfigProvider.mainColor,
                  ),
                  onPressed: () {
                    onReorder(1);
                  },
                ),
                MenuItemButton(
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
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
    );
  }
}
