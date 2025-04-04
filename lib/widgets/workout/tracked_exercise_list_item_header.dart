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
  const TrackedExerciseListItemHeader({
    super.key,
    required this.trackedExercise,
    required this.onReorder,
  });

  void _showExerciseDetailsWithHistory({
    required BuildContext context,
  }) async {
    var workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    var exerciseHistory =
        workoutProvider.getExerciseHistory(trackedExercise.exercise.id);
    Helper.showPopUp(
      context: context,
      title: trackedExercise.exercise.name,
      content: ExerciseDetailsWithHistory(
        exercise: trackedExercise.exercise,
        exerciseHistory: exerciseHistory,
      ),
    );
  }

  void _replaceExercise({
    required BuildContext context,
  }) async {
    var exerciseProvider =
        Provider.of<ExerciseProvider>(context, listen: false);
    exerciseProvider.clearFilters();
    exerciseProvider
        .setAppliedMuscleGroupIdFilter(trackedExercise.exercise.muscleGroupId);

    dynamic exerciseId = await Helper.showPopUp(
      context: context,
      title: 'Exercises',
      content: const SelectableExerciseList(
        isReplacing: true,
      ),
    );
    if (exerciseId != null && exerciseId.isNotEmpty) {
      if (context.mounted) {
        var workoutProvider =
            // ignore: use_build_context_synchronously
            Provider.of<WorkoutProvider>(context, listen: false);
        var configProvider =
            // ignore: use_build_context_synchronously
            Provider.of<ConfigProvider>(context, listen: false);

        var exercise = exerciseProvider.getExerciseById(exerciseId);

        if (exercise == null) return;

        var res = workoutProvider.replaceTrackedExercise(
          originalTrackedExerciseId: trackedExercise.id,
          exercise: exercise,
          autoPopulateWorkoutFromSetsHistory:
              configProvider.autoPopulateWorkoutFromSetsHistory,
        );
        Helper.showMessageBar(
          context: context,
          message: '${res.message}',
          isError: !res.success,
        );
        print('FROM selector ${exerciseId}');
      }
    }
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
              DefaultMenuItemButton(
                icon: Icons.play_circle_outline_rounded,
                label: 'WATCH',
                onPressed: () {
                  Helper.navigateToYoutube(
                    context: context,
                    youtubeId: exerciseData.youtubeId,
                    searchQuery: exerciseData.name,
                  );
                },
              ),
              DefaultMenuItemButton(
                icon: Icons.repeat_rounded,
                label: 'REPLACE',
                onPressed: () => _replaceExercise(context: context),
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
