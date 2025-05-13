import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utility.dart';
import '../helper.dart';

import '../../providers/config_provider.dart';
import '../../providers/workout_provider.dart';
import '../../providers/exercise_provider.dart';

import '../../models/tracked_exercise_dto.dart';
import '../../models/muscle_group_dto.dart';
import 'tracked_exercise_list_item_header.dart';
import 'tracked_exercise_list_item_body.dart';
import '../exercise/_selectable_exercise_list.dart';
import '../general/default_container.dart';
import '../general/pill_container.dart';
import '../general/text_style_templates.dart';

class TrackedExerciseListItem extends StatelessWidget {
  final TrackedExerciseDto trackedExercise;
  final bool isCollapsed;
  final Function(int) onReorder;
  final Function(String, bool) setCollapsedStatus;
  final bool isMetricSystemSelected;
  const TrackedExerciseListItem({
    super.key,
    required this.trackedExercise,
    required this.isMetricSystemSelected,
    required this.isCollapsed,
    required this.onReorder,
    required this.setCollapsedStatus,
  });

  void onReplaceExercise({
    required BuildContext context,
  }) async {
    var exerciseProvider =
        Provider.of<ExerciseProvider>(context, listen: false);
    exerciseProvider.clearFilters();
    exerciseProvider.setAppliedMuscleGroupIdFilter(
      trackedExercise.exercise?.muscleGroupId ?? trackedExercise.muscleGroupId,
    );

    dynamic exerciseId = await Helper.showPopUp(
      context: context,
      title: 'Select Exercise',
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
    var areSetsLogged = trackedExercise.areSetsLogged();
    var areSetsLoggedColor = areSetsLogged ? Colors.green : Colors.orangeAccent;
    return Padding(
      padding: const EdgeInsets.only(top: ConfigProvider.defaultSpace / 2),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top:
                  ConfigProvider.defaultSpace + ConfigProvider.defaultSpace / 2,
              bottom: ConfigProvider.defaultSpace * 2,
            ),
            child: DefaultContainer(
              child: Column(
                children: [
                  TrackedExerciseListItemHeader(
                    trackedExercise: trackedExercise,
                    onReorder: onReorder,
                    onReplaceExercise: () =>
                        onReplaceExercise(context: context),
                  ),
                  if (!isCollapsed && trackedExercise.exercise != null)
                    TrackedExerciseListItemBody(
                      trackedExerciseId: trackedExercise.id,
                      isMetricSystemSelected: isMetricSystemSelected,
                      exerciseDimensions: trackedExercise.exercise!.dimensions,
                      sets: trackedExercise.sets
                          .map((x) => SetDto.getCopy(x))
                          .toList(),
                    ),
                  if (trackedExercise.exercise == null)
                    Padding(
                      padding: const EdgeInsets.only(
                        right: ConfigProvider.defaultSpace,
                        top: ConfigProvider.defaultSpace * 2,
                      ),
                      child: TextButton(
                        onPressed: () => onReplaceExercise(context: context),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ConfigProvider.defaultSpace / 2,
                            ),
                          ),
                          backgroundColor: ConfigProvider.backgroundColorSolid,
                          side: const BorderSide(
                            color: ConfigProvider.mainColor,
                            width: 2,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: Text(
                          "SELECT EXERCISE",
                          style: TextStyleTemplates.smallBoldTextStyle(
                            ConfigProvider.mainColor,
                          ),
                        ),
                      ),
                    ),
                  if (trackedExercise.exercise != null)
                    SizedBox(
                      width: 200.0,
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ConfigProvider.defaultSpace / 2,
                            ),
                          ),
                        ),
                        onPressed: () {
                          setCollapsedStatus(
                            trackedExercise.id,
                            !isCollapsed,
                          );
                        },
                        icon: Icon(
                          isCollapsed
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.keyboard_arrow_up_rounded,
                          color: ConfigProvider.mainColor,
                          size: ConfigProvider.defaultIconSize,
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: ConfigProvider.defaultSpace / 2,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: ConfigProvider.defaultSpace),
              child: PillContainer(
                height: ConfigProvider.defaultSpace * 4,
                outlineColor: areSetsLoggedColor,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      MuscleGroupDto.getMuscleGroupName(
                        trackedExercise.muscleGroupId,
                      ).toUpperCase(),
                      style: TextStyleTemplates.smallBoldTextStyle(
                        ConfigProvider.mainTextColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ConfigProvider.defaultSpace / 2,
                      ),
                      child: Icon(
                        areSetsLogged
                            ? Icons.check
                            : Icons.watch_later_outlined,
                        color: areSetsLoggedColor,
                        size: ConfigProvider.smallIconSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.topRight,
          //   child: Padding(
          //     padding:
          //         const EdgeInsets.only(right: ConfigProvider.defaultSpace),
          //     child: PillContainer(
          //       height: ConfigProvider.defaultSpace * 4,
          //       outlineColor: ConfigProvider.mainColor,
          //       color: ConfigProvider.backgroundColorSolid,
          //       child: Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           IconButton(
          //             onPressed: () {
          //               setCollapsedStatus(
          //                 trackedExercise.id,
          //                 !isCollapsed,
          //               );
          //             },
          //             visualDensity: VisualDensity.compact,
          //             icon: Icon(
          //               isCollapsed
          //                   ? Icons.keyboard_arrow_down_rounded
          //                   : Icons.keyboard_arrow_up_rounded,
          //               color: ConfigProvider.mainColor,
          //               size: ConfigProvider.mediumIconSize,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          if (!isCollapsed && trackedExercise.exercise != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: ConfigProvider.defaultSpace,
                  top: ConfigProvider.defaultSpace * 2,
                ),
                child: TextButton(
                  onPressed: () {
                    var set = SetDto();
                    var workoutProvider =
                        Provider.of<WorkoutProvider>(context, listen: false);

                    workoutProvider.addSetToTrackedExercise(
                        trackedExercise.id, set);
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ConfigProvider.defaultSpace / 2,
                      ),
                    ),
                    backgroundColor: ConfigProvider.backgroundColorSolid,
                    side: const BorderSide(
                      color: ConfigProvider.mainColor,
                      width: 2,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(
                    "ADD SET",
                    style: TextStyleTemplates.smallBoldTextStyle(
                      ConfigProvider.mainColor,
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
