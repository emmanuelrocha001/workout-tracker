import 'dart:ui';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/adjust_workout_times_dto.dart';
import 'adjust_workout_details_form.dart';

import '../../providers/config_provider.dart';
import '../../providers/exercise_provider.dart';
import '../../providers/workout_provider.dart';

import '../../widgets/workout/rest_timer.dart';
import '../exercise/_selectable_exercise_list.dart';
import 'tracked_exercise_list_item.dart';
import 'elapsed_time_timer.dart';

import '../general/overlay_content.dart';
import '../general/text_style_templates.dart';
import '../general/default_menu_item_button.dart';
import '../helper.dart';
import '../../utility.dart';

class TrackedExerciseList extends StatefulWidget {
  final void Function() navigateToWorkoutHistory;
  const TrackedExerciseList({
    super.key,
    required this.navigateToWorkoutHistory,
  });

  @override
  State<TrackedExerciseList> createState() => _TrackedExerciseListState();
}

class _TrackedExerciseListState extends State<TrackedExerciseList> {
  final ScrollController _scrollController = ScrollController();
  bool onReorderInProgress = false;

  void onAddExercise() async {
    dynamic exerciseId = await Helper.showPopUp(
      context: context,
      title: 'Exercises',
      content: const SelectableExerciseList(),
    );
    if (exerciseId != null && exerciseId.isNotEmpty) {
      if (context.mounted) {
        var workoutProvider =
            // ignore: use_build_context_synchronously
            Provider.of<WorkoutProvider>(context, listen: false);
        var exerciseProvider =
            // ignore: use_build_context_synchronously
            Provider.of<ExerciseProvider>(context, listen: false);

        var configProvider =
            // ignore: use_build_context_synchronously
            Provider.of<ConfigProvider>(context, listen: false);

        var exercise = exerciseProvider.getExerciseById(exerciseId);

        if (exercise == null) return;

        workoutProvider.addTrackedExercise(
          exercise: exercise,
          autoPopulateWorkoutFromSetsHistory:
              configProvider.autoPopulateWorkoutFromSetsHistory,
        );
        print('FROM selector ${exerciseId}');
      }
    }
  }

  void onReorder(int oldIndex, int newIndex) {
    print('${oldIndex} ${newIndex}');
    try {
      var exerciseProvider =
          Provider.of<WorkoutProvider>(context, listen: false);
      exerciseProvider.reorderTrackedExercises(oldIndex, newIndex);
    } catch (e) {
      print('from catch ${e}');
    }
  }

  void _adjustWorkoutTimes() async {
    var workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    var maxContentWidth = Helper.getMaxContentWidth(context);
    var update = await Helper.showPopUp(
      context: context,
      title: 'Workout Details',
      content: SingleChildScrollView(
        child: AdjustWorkoutDetailsForm(
          maxFormWidth: maxContentWidth,
          initial: AdjustWorkoutTimesDto(
            startTime: workoutProvider.inProgressWorkoutStartTime,
            endTime: workoutProvider.inProgressWorkoutEndTime,
            autoTimingSelected:
                workoutProvider.inProgressWorkoutAutoTimingSelected,
            showRestTimerAfterEachSet:
                workoutProvider.showRestTimerAfterEachSet,
            workoutNickName: workoutProvider.inProgressWorkoutNickName,
          ),
          canEnableAutoTiming: !workoutProvider.updatingLoggedWorkout,
          isUpdatingWorkout: workoutProvider.updatingLoggedWorkout,
        ),
      ),
    );
    if (update != null && update is AdjustWorkoutTimesDto) {
      workoutProvider.updateInProgresssWorkoutTimes(update);
    }
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          borderRadius: BorderRadius.circular(ConfigProvider.defaultSpace / 2),
          elevation: elevation,
          color: ConfigProvider.mainColor.withOpacity(.75),
          shadowColor: ConfigProvider.mainColor.withOpacity(.75),
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: false);
    var workoutProvider = Provider.of<WorkoutProvider>(
      context,
    );
    var trackedExercises = workoutProvider.trackedExercises;
    var title = DateFormat(ConfigProvider.simpleDateFormat)
        .format(DateTime.now())
        .toUpperCase();

    var elapsedTimeString = "";
    if (!workoutProvider.inProgressWorkoutAutoTimingSelected &&
        workoutProvider.inProgressWorkoutStartTime != null &&
        workoutProvider.inProgressWorkoutEndTime != null) {
      var diff = Utility.getTimeDifference(
          startTime: workoutProvider.inProgressWorkoutStartTime!,
          endTime: workoutProvider.inProgressWorkoutEndTime!);
      elapsedTimeString =
          Utility.getElapsedTimeString(timeDiff: diff, includeTimeUnits: true);
    }
    return OverlayContent(
      content: Scrollbar(
        controller: _scrollController,
        radius: const Radius.circular(ConfigProvider.defaultSpace / 2),
        child: ReorderableListView(
          scrollController: _scrollController,
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
          onReorder: (int oldIndex, int newIndex) {
            print('${oldIndex} ${newIndex}');

            if (oldIndex < newIndex) {
              //if moving up the list, the new index provided by the call back is off by 1
              newIndex -= 1;
            }

            onReorder(oldIndex, newIndex);
          },
          padding: const EdgeInsets.symmetric(
              vertical: ConfigProvider.defaultSpace / 2),
          children: <Widget>[
            for (int index = 0; index < trackedExercises.length; index += 1)
              TrackedExerciseListItem(
                key: ValueKey(trackedExercises[index].id),
                onReorder: (int increment) {
                  // -1 means move up, 1 means move down
                  onReorder(index, index + increment);
                },
                trackedExercise: trackedExercises[index],
                isMetricSystemSelected: configProvider.isMetricSystemSelected,
                showAsSimplified: onReorderInProgress,
              ),
          ],
        ),
      ),
      padding: 115.0,
      overLayContent: Container(
        color: ConfigProvider.backgroundColorSolid,
        child: Column(
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
                        DefaultMenuItemButton(
                          icon: Icons.edit_rounded,
                          label: 'ADJUST DETAILS',
                          onPressed: _adjustWorkoutTimes,
                        ),
                        DefaultMenuItemButton(
                          icon: Icons.delete_outline_rounded,
                          label: !workoutProvider.updatingLoggedWorkout
                              ? "CANCEL WORKOUT"
                              : "CANCEL UPDATE",
                          iconColor: Colors.red,
                          labelColor: Colors.red,
                          onPressed: () async {
                            var res = await Helper.showConfirmationDialogForm(
                                context: context,
                                message: !workoutProvider.updatingLoggedWorkout
                                    ? ConfigProvider.cancelInProgressWorkoutText
                                    : ConfigProvider.cancelUpdateWorkoutText,
                                confimationButtonLabel: "CONFIRM",
                                confirmationButtonColor: Colors.red,
                                cancelButtonColor:
                                    ConfigProvider.backgroundColor,
                                cancelButtonLabel: 'RESUME');

                            if (res ?? false) {
                              workoutProvider.cancelInProgressWorkout();
                            }
                          },
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
                      visualDensity: VisualDensity.compact,
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
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: ConfigProvider.defaultSpace,
                ),
                decoration: const BoxDecoration(
                  // color: ConfigProvider.mainColor,
                  border: Border(
                    top: BorderSide(
                        width: 1, color: ConfigProvider.backgroundColor),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.center,
                        margin:
                            const EdgeInsets.all(ConfigProvider.defaultSpace),
                        child: elapsedTimeString.isNotEmpty
                            ? Text(
                                elapsedTimeString,
                                style: TextStyleTemplates.mediumBoldTextStyle(
                                    ConfigProvider.mainTextColor),
                              )
                            : ElapsedTimeTimer(
                                startTime: workoutProvider
                                    .inProgressWorkoutStartTime!),
                      ),
                    ),
                    if (!workoutProvider.updatingLoggedWorkout)
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(
                            Icons.timer_outlined,
                            color: ConfigProvider.mainColor,
                            size: ConfigProvider.defaultIconSize,
                          ),
                          onPressed: () {
                            Helper.showDialogForm(
                              context: context,
                              barrierDismissible: false,
                              content: const Center(child: RestTimer()),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
      showActionButton: workoutProvider.isInProgressWorkoutReadyTofinish(),
      actionButtonLabel:
          !workoutProvider.updatingLoggedWorkout ? "FINISH" : "UPDATE",
      onActionButtonPressed: () async {
        if (!workoutProvider.updatingLoggedWorkout) {
          workoutProvider.finishInProgressWorkout();
        } else {
          var res = await workoutProvider.finishUpdatingWorkoutHistoryEntry();
          if (context.mounted) {
            Helper.showMessageBar(
                context: context,
                message: '${res.message}',
                isError: !res.success);
          }
        }
        widget.navigateToWorkoutHistory();
      },
    );
  }
}
