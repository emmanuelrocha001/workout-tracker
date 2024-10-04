import 'dart:ui';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker/widgets/workout/workout_history_list_item.dart';

import '../../providers/config_provider.dart';
import '../../providers/exercise_provider.dart';
import '../../providers/workout_provider.dart';

import '../exercise/_exercise_list.dart';
import 'tracked_exercise_list_item.dart';
import 'tracked_exercise_list_item_header.dart';
import 'elapsed_time_timer.dart';

import '../general/overlay_content.dart';
import '../general/text_style_templates.dart';
import '../helper.dart';
import '../../utility.dart';

class TrackedExerciseList extends StatefulWidget {
  const TrackedExerciseList({super.key});

  @override
  State<TrackedExerciseList> createState() => _TrackedExerciseListState();
}

class _TrackedExerciseListState extends State<TrackedExerciseList> {
  bool onReorderInProgress = false;

  void onAddExercise() async {
    dynamic exerciseId = await Helper.showPopUp(
      context: context,
      title: 'Exercises',
      content: const ExerciseList(),
    );
    if (exerciseId != null && exerciseId.isNotEmpty) {
      if (context.mounted) {
        var workoutProvider =
            // ignore: use_build_context_synchronously
            Provider.of<WorkoutProvider>(context, listen: false);
        var exerciseProvider =
            // ignore: use_build_context_synchronously
            Provider.of<ExerciseProvider>(context, listen: false);
        var exercise = exerciseProvider.getExerciseById(exerciseId);

        if (exercise == null) return;

        workoutProvider.addTrackedExercise(exercise);
        print('FROM selector ${exerciseId}');
      }
    }
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          borderRadius: BorderRadius.circular(ConfigProvider.defaultSpace),
          elevation: elevation,
          color: ConfigProvider.mainColor,
          shadowColor: ConfigProvider.mainColor,
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    var workoutProvider = Provider.of<WorkoutProvider>(
      context,
    );
    var trackedExercises = workoutProvider.trackedExercises;
    var title = DateFormat(ConfigProvider.simpleDateFormat)
        .format(DateTime.now())
        .toUpperCase();
    return OverlayContent(
      content: ReorderableListView(
        proxyDecorator: proxyDecorator,
        onReorderStart: (index) {
          setState(() {
            onReorderInProgress = true;
          });
        },
        onReorderEnd: (index) {
          Future.delayed(const Duration(milliseconds: 400), () {
            setState(() {
              onReorderInProgress = false;
            });
          });
        },
        children: <Widget>[
          for (int index = 0; index < trackedExercises.length; index += 1)
            TrackedExerciseListItem(
              key: ValueKey(trackedExercises[index].id),
              trackedExercise: trackedExercises[index],
              showAsSimplified: onReorderInProgress,
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          print('${oldIndex} ${newIndex}');

          if (oldIndex < newIndex) {
            //if moving up the list the new index provided by the call back is off by 1
            newIndex -= 1;
          }
          try {
            var exerciseProvider =
                Provider.of<WorkoutProvider>(context, listen: false);
            exerciseProvider.reorderTrackedExercises(oldIndex, newIndex);
          } catch (e) {
            print('from catch ${e}');
          }
        },
      ),
      padding: 100.0,
      overLayContent: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
                child: Text(
                  title,
                  style: TextStyleTemplates.mediumBoldTextStyle(
                      ConfigProvider.mainTextColor),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
                  child: MenuAnchor(
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
                          // TODO add more options
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
                      // MenuItemButton(
                      //   style: const ButtonStyle(
                      //     backgroundColor: WidgetStatePropertyAll<Color>(
                      //         ConfigProvider.mainColor),
                      //   ),
                      //   onPressed: onAddExercise,
                      //   child: Text(
                      //     "ADD EXERCISE",
                      //     style: TextStyleTemplates.defaultBoldTextStyle(
                      //         ConfigProvider.backgroundColor),
                      //   ),
                      // ),
                      MenuItemButton(
                        style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll<Color>(Colors.red),
                        ),
                        onPressed: workoutProvider.cancelInProgressWorkout,
                        child: Text(
                          "CANCEL WORKOUT",
                          style: TextStyleTemplates.defaultBoldTextStyle(
                              ConfigProvider.backgroundColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: ConfigProvider.defaultSpace / 4,
                    right: ConfigProvider.defaultSpace,
                    bottom: ConfigProvider.defaultSpace,
                    top: ConfigProvider.defaultSpace),
                child: TextButton(
                  onPressed: onAddExercise,
                  style: TextButton.styleFrom(
                    backgroundColor: ConfigProvider.mainColor,
                  ),
                  child: Text(
                    "ADD EXERCISE",
                    style: TextStyleTemplates.smallBoldTextStyle(
                      Utility.getTextColorBasedOnBackground(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (workoutProvider.inProgressWorkoutStartTime != null)
            Align(
              alignment: Alignment.center,
              child: ElapsedTimeTimer(
                  startTime: workoutProvider.inProgressWorkoutStartTime!),
            ),
        ],
      ),
      showActionButton: workoutProvider.isInProgressWorkoutReadyTofinish(),
      actionButtonLabel: "FINISH",
      onActionButtonPressed: () {
        workoutProvider.finishInProgressWorkout();
      },
    );
  }
}
