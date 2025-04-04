import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utility.dart';

import '../../providers/config_provider.dart';
import '../../providers/workout_provider.dart';

import '../../models/tracked_exercise_dto.dart';
import '../../models/muscle_group_dto.dart';
import 'tracked_exercise_list_item_header.dart';
import 'tracked_exercise_list_item_body.dart';
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
                  ),
                  if (!isCollapsed)
                    TrackedExerciseListItemBody(
                      trackedExerciseId: trackedExercise.id,
                      isMetricSystemSelected: isMetricSystemSelected,
                      exerciseDimensions: trackedExercise.exercise.dimensions,
                      sets: trackedExercise.sets
                          .map((x) => SetDto.getCopy(x))
                          .toList(),
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
                        trackedExercise.exercise.muscleGroupId,
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
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding:
                  const EdgeInsets.only(right: ConfigProvider.defaultSpace),
              child: PillContainer(
                height: ConfigProvider.defaultSpace * 4,
                outlineColor: ConfigProvider.mainColor,
                color: ConfigProvider.backgroundColorSolid,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        setCollapsedStatus(
                          trackedExercise.id,
                          !isCollapsed,
                        );
                      },
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        isCollapsed
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.keyboard_arrow_up_rounded,
                        color: ConfigProvider.mainColor,
                        size: ConfigProvider.mediumIconSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!isCollapsed)
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
