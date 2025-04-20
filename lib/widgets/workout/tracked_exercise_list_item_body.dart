import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_tracker/models/exercise_type_dto.dart';
import 'package:workout_tracker/widgets/general/time_based_indicator.dart';

import '../../providers/config_provider.dart';
import '../../providers/workout_provider.dart';

import '../general/action_button.dart';
import '../general/custom_number_input_formatter.dart';
import '../general/time_input_formatter.dart';
import '../general/row_item.dart';
import '../general/default_tooltip.dart';

import '../helper.dart';
import './rest_timer.dart';
import '../../utility.dart';
import '../general/text_style_templates.dart';

import '../../models/tracked_exercise_dto.dart';

class TrackedExerciseListItemBody extends StatefulWidget {
  final String trackedExerciseId;
  final ExerciseDimensionsDto? exerciseDimensions;
  final List<SetDto> sets;
  final bool isMetricSystemSelected;
  const TrackedExerciseListItemBody({
    super.key,
    required this.trackedExerciseId,
    required this.exerciseDimensions,
    required this.sets,
    required this.isMetricSystemSelected,
  });

  @override
  State<TrackedExerciseListItemBody> createState() =>
      _TrackedExerciseListItemBodyState();
}

class _TrackedExerciseListItemBodyState
    extends State<TrackedExerciseListItemBody> {
  List<SetDto> sets = [];
  List<TextEditingController> _weightControllers = [];
  List<TextEditingController> _repsControllers = [];
  List<TextEditingController> _distanceControllers = [];
  List<TextEditingController> _timeControllers = [];
  int? updateRestOfSetsElligibleIndex;
  int? updateRestOfSetsIndex;
  int updateRestOfSetsPromptTimerAllowedSeconds = 3;
  Timer? updateRestOfSetsPromptTimer;

  @override
  void initState() {
    super.initState();
    sets = [...widget.sets];
    print("init state");
    // _repsControllers = widget.sets.mapIndexed((index, set) {
    //   return TextEditingController(
    //     text: set.reps != null ? set.reps.toString() : '',
    //   );n
    // }).toList();
  }

  @override
  void didUpdateWidget(covariant TrackedExerciseListItemBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sets.length != widget.sets.length) {
      print('number of sets changed');
      setState(() {
        sets = [...widget.sets];
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (updateRestOfSetsPromptTimer != null) {
      print("cancelling timer");
      updateRestOfSetsPromptTimer!.cancel();
    }
  }

  void updateRestOfSetsPrompt(
    int currentSetIndex,
    SetDto currentSet,
  ) {
    print("cancelling timer if active");
    if (updateRestOfSetsPromptTimer != null &&
        updateRestOfSetsPromptTimer!.isActive) {
      updateRestOfSetsPromptTimer!.cancel();
    }
    var elapsedSeconds = 0;
    setState(
      () {
        updateRestOfSetsIndex = currentSetIndex;
        updateRestOfSetsPromptTimer =
            Timer.periodic(const Duration(seconds: 1), (timer) {
          elapsedSeconds++;
          if (elapsedSeconds >= updateRestOfSetsPromptTimerAllowedSeconds ||
              updateRestOfSetsIndex == null) {
            // reached 24 hours
            print('elapsed time is more than 24 hours, stopping current timer');
            timer.cancel();
            setState(() {
              updateRestOfSetsIndex = null;
              updateRestOfSetsElligibleIndex = null;
            });
          }
        });
      },
    );
  }

  void updateRestOfSets() {
    if (updateRestOfSetsIndex == null) {
      print("invalid call to update rest of sets");
      return;
    }
    var indexes = List.generate(
      sets.length - updateRestOfSetsIndex! - 1,
      (i) => updateRestOfSetsIndex! + i + 1,
    );

    print(indexes);
    var workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    workoutProvider.updateSetsBasedOnSetInTrackedExercise(
      trackedExerciseId: widget.trackedExerciseId,
      set: sets[updateRestOfSetsIndex!],
      indexes: indexes,
    );

    setState(() {
      // local update
      for (var index in indexes) {
        var tempSet = SetDto.getCopy(sets[updateRestOfSetsIndex!]);
        tempSet.isLogged = false;
        sets[index] = tempSet;
      }
      updateRestOfSetsIndex = null;
    });

    if (updateRestOfSetsPromptTimer != null &&
        updateRestOfSetsPromptTimer!.isActive) {
      updateRestOfSetsPromptTimer!.cancel();
    }
  }

  List<Widget> generateHeaderRow() {
    var headers = [];
    List<String?> toolTipMessage = [];

    headers.add("SET");
    toolTipMessage.add(null);

    if (widget.exerciseDimensions?.isWeightEnabled ?? true) {
      headers.add('WEIGHT');
      toolTipMessage.add(null);
    }
    if (widget.exerciseDimensions?.isRepEnabled ?? true) {
      headers.add("REPS");
      toolTipMessage.add(null);
    }
    if (widget.exerciseDimensions!.isDistanceEnabled) {
      headers.add('DISTANCE');
      toolTipMessage.add(null);
    }
    if (widget.exerciseDimensions!.isTimeEnabled) {
      headers.add("TIME");
      toolTipMessage.add("hh:mm:ss");
    }

    headers.add("LOG");
    toolTipMessage.add(null);
    return headers
        .mapIndexed((index, text) => RowItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyleTemplates.smallBoldTextStyle(
                      ConfigProvider.mainTextColor,
                    ),
                  ),
                  if (toolTipMessage[index] != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: ConfigProvider.defaultSpace / 2),
                      child: DefaultTooltip(
                        message: toolTipMessage[headers.indexOf(text)]!,
                      ),
                    ),
                ],
              ),
            ))
        .toList();
  }

  Widget getNumberInput({
    required TextEditingController controller,
    required Function(double) save,
    required bool allowDecimal,
    required bool canEdit,
    String hintText = '',
  }) {
    return TextField(
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      textInputAction: TextInputAction.done,
      cursorColor: ConfigProvider.mainColor,
      onTap: () {},
      onChanged: (value) {
        save(double.tryParse(value) ?? 0);
      },
      enabled: canEdit,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: ConfigProvider.defaultSpace,
          horizontal: ConfigProvider.defaultSpace,
        ),
        fillColor: ConfigProvider.backgroundColor,
        hintStyle: TextStyleTemplates.defaultTextStyle(
          ConfigProvider.alternateTextColor.withOpacity(.5),
        ),
        filled: true,
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(ConfigProvider.defaultSpace / 2),
        ),
      ),
      style: TextStyleTemplates.defaultTextStyle(
        ConfigProvider.mainTextColor,
      ),
      inputFormatters: [
        allowDecimal
            ? FilteringTextInputFormatter.deny(RegExp(r'[^\d.]'))
            : FilteringTextInputFormatter.digitsOnly,
        CustomNumberInputFormatter(allowDecimals: allowDecimal)
      ],
    );
  }

  Widget getTimeInput({
    required TextEditingController controller,
    required Function(String) save,
    required bool canEdit,
    String hintText = '',
  }) {
    return TextField(
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      cursorColor: ConfigProvider.mainColor,
      onTap: () {},
      onChanged: (value) {
        save(value);
      },
      enabled: canEdit,
      controller: controller,
      // textAlign: TextAlign.start,
      // textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: ConfigProvider.defaultSpace,
          horizontal: ConfigProvider.defaultSpace,
        ),
        fillColor: ConfigProvider.backgroundColor,
        hintStyle: TextStyleTemplates.defaultTextStyle(
          ConfigProvider.alternateTextColor.withOpacity(.5),
        ),
        filled: true,
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(ConfigProvider.defaultSpace / 2),
        ),
      ),
      style: TextStyleTemplates.defaultTextStyle(
        ConfigProvider.mainTextColor,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        TimeInputFormatter(),
      ],
    );
  }

  String getPreviousSetWeight(index) {
    if (index > 0 && index <= sets.length - 1) {
      for (var i = index; i >= 0; i--) {
        if (sets[i].weight != null) {
          return sets[i].weight.toString();
        }
      }
    }
    return '';
  }

  String getPreviousSetReps(index) {
    if (index > 0 && index <= sets.length - 1) {
      for (var i = index; i >= 0; i--) {
        if (sets[i].reps != null) {
          return sets[i].reps.toString();
        }
      }
    }
    return '';
  }

  String getPreviousSetDistance(index) {
    if (index > 0 && index <= sets.length - 1) {
      for (var i = index; i >= 0; i--) {
        if (sets[i].distance != null) {
          return sets[i].distance.toString();
        }
      }
    }
    return '';
  }

  String getPreviousSetTime(index) {
    if (index > 0 && index <= sets.length - 1) {
      for (var i = index; i >= 0; i--) {
        if (sets[i].time != null) {
          return sets[i].time.toString();
        }
      }
    }
    return '';
  }

  void _onLog({
    required String trackedExerciseId,
    required int index,
    required bool val,
    required double? setWeight,
    required int? setReps,
    required double? setDistance,
    required String? setTime,
  }) {
    if (index >= 0 && index < sets.length) {
      var workoutProvider =
          Provider.of<WorkoutProvider>(context, listen: false);
      var configProvider = Provider.of<ConfigProvider>(context, listen: false);
      var timerAlreadyShown = sets[index].restTimerShown;
      var tSet = SetDto.getCopy(sets[index]);
      print("on log $index");
      tSet.weight = setWeight;
      tSet.reps = setReps;
      tSet.isLogged = val;
      tSet.distance = setDistance;
      tSet.time = setTime;
      tSet.restTimerShown = true;

      var isSetUpdated = workoutProvider.updateSetInTrackedExercise(
        trackedExerciseId: trackedExerciseId,
        index: index,
        set: tSet,
        autoCollapseTrackedExercises:
            configProvider.autoCollapseTrackedExercises &&
                !workoutProvider.updatingLoggedWorkout,
      );

      if (isSetUpdated) {
        setState(() {
          sets[index] = tSet;
        });
      }

      /*
      * Trigger user prompt to apply changes to rest of the sets if
      * - marking a set as logged
      * - there are more sets
      */

      if (!workoutProvider.updatingLoggedWorkout &&
          tSet.isLogged &&
          index < sets.length - 1 &&
          index == updateRestOfSetsElligibleIndex) {
        updateRestOfSetsPrompt(index, tSet);
      } else if (!tSet.isLogged && index == updateRestOfSetsIndex) {
        setState(() {
          updateRestOfSetsIndex = null;
        });
        if (updateRestOfSetsPromptTimer != null &&
            updateRestOfSetsPromptTimer!.isActive) {
          updateRestOfSetsPromptTimer!.cancel();
        }
      }

      /**
       * Show rest timer after each set if
       * - not updating a logged workout
       * - setting is enabled for this workout instance
       * - set isLogged to true
       * - timer has not already been shown
       */
      if (!workoutProvider.updatingLoggedWorkout &&
          workoutProvider.showRestTimerAfterEachSet &&
          tSet.isLogged &&
          !timerAlreadyShown) {
        Helper.showDialogForm(
          context: context,
          barrierDismissible: false,
          content: const Center(child: RestTimer()),
        );
      }
    }
  }

  void _onRemoveSet(trackedExcerciseId, int index) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: false);
    var workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    var setRemoved = workoutProvider.deleteSetFromTrackedExercise(
      trackedExerciseId: trackedExcerciseId,
      index: index,
      autoCollapseTrackedExercises:
          configProvider.autoCollapseTrackedExercises &&
              !workoutProvider.updatingLoggedWorkout,
    );
    if (setRemoved) {
      setState(() {
        sets.removeAt(index);
      });
    }
  }

  List<Widget> generateSetRows() {
    _weightControllers = sets.mapIndexed((index, set) {
      return TextEditingController(
        text: set.weight != null ? set.weight.toString() : '',
      );
    }).toList();
    _repsControllers = sets.mapIndexed((index, set) {
      return TextEditingController(
        text: set.reps != null ? set.reps.toString() : '',
      );
    }).toList();

    _distanceControllers = sets.mapIndexed((index, set) {
      return TextEditingController(
        text: set.distance != null ? set.distance.toString() : '',
      );
    }).toList();

    _timeControllers = sets.mapIndexed((index, set) {
      return TextEditingController(
        text: set.time != null ? set.time.toString() : '',
      );
    }).toList();

    return sets.mapIndexed((index, set) {
      var previousSetReps = getPreviousSetReps(index);
      var previousSetWeight = getPreviousSetWeight(index);
      var previousSetDistance = getPreviousSetDistance(index);
      var previousSetTime = getPreviousSetTime(index);

      return Dismissible(
        key: Key('${widget.trackedExerciseId}_${index}_${const Uuid().v4()}'),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: const Padding(
            padding: EdgeInsets.all(ConfigProvider.defaultSpace),
            child: Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
            ),
          ),
        ),
        onDismissed: (direction) {
          _onRemoveSet(widget.trackedExerciseId, index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: ConfigProvider.defaultSpace,
          ),
          decoration: BoxDecoration(
            border: index < sets.length - 1
                ? const Border(
                    bottom: BorderSide(
                      width: 1,
                      color: ConfigProvider.backgroundColor,
                    ),
                  )
                : null,
          ),
          // color: set.isLogged ? Colors.green : Colors.transparent,
          child: Column(
            children: [
              Row(
                children: [
                  RowItem(
                      child: Text(
                    '${index + 1}',
                    style: TextStyleTemplates.defaultTextStyle(
                      ConfigProvider.mainTextColor,
                    ),
                  )),
                  if (widget.exerciseDimensions?.isWeightEnabled ?? true)
                    RowItem(
                      child: getNumberInput(
                        controller: _weightControllers[index],
                        save: (double number) {
                          var weightBeforeUpdate = sets[index].weight;
                          sets[index].weight = number;
                          var isSetUpdated = Provider.of<WorkoutProvider>(
                                  context,
                                  listen: false)
                              .updateSetInTrackedExercise(
                            trackedExerciseId: widget.trackedExerciseId,
                            index: index,
                            set: sets[index],
                          );

                          if (!isSetUpdated) {
                            sets[index].weight = weightBeforeUpdate;
                          } else {
                            updateRestOfSetsElligibleIndex = index;
                          }
                        },
                        allowDecimal: true,
                        canEdit: !set.isLogged,
                        hintText: previousSetWeight,
                      ),
                    ),
                  if (widget.exerciseDimensions?.isRepEnabled ?? true)
                    RowItem(
                      child: getNumberInput(
                        controller: _repsControllers[index],
                        save: (double number) {
                          var repsBeforeUpdate = sets[index].reps;
                          sets[index].reps = number.toInt();
                          var isSetUpdated = Provider.of<WorkoutProvider>(
                                  context,
                                  listen: false)
                              .updateSetInTrackedExercise(
                            trackedExerciseId: widget.trackedExerciseId,
                            index: index,
                            set: sets[index],
                          );

                          if (!isSetUpdated) {
                            sets[index].reps = repsBeforeUpdate;
                          } else {
                            updateRestOfSetsElligibleIndex = index;
                          }
                        },
                        allowDecimal: false,
                        canEdit: !set.isLogged,
                        hintText: previousSetReps,
                      ),
                    ),
                  if (widget.exerciseDimensions?.isDistanceEnabled ?? false)
                    RowItem(
                      child: getNumberInput(
                        controller: _distanceControllers[index],
                        save: (double number) {
                          var distanceBeforeUpdate = sets[index].distance;
                          sets[index].distance = number;
                          var isSetUpdated = Provider.of<WorkoutProvider>(
                                  context,
                                  listen: false)
                              .updateSetInTrackedExercise(
                            trackedExerciseId: widget.trackedExerciseId,
                            index: index,
                            set: sets[index],
                          );

                          if (!isSetUpdated) {
                            sets[index].distance = distanceBeforeUpdate;
                          } else {
                            updateRestOfSetsElligibleIndex = index;
                          }
                        },
                        allowDecimal: true,
                        canEdit: !set.isLogged,
                        hintText: previousSetDistance,
                      ),
                    ),
                  if (widget.exerciseDimensions?.isTimeEnabled ?? false)
                    RowItem(
                      child: getTimeInput(
                        controller: _timeControllers[index],
                        save: (String value) {
                          var timeBeforeUpdate = sets[index].time;
                          sets[index].time = value;
                          var isSetUpdated = Provider.of<WorkoutProvider>(
                                  context,
                                  listen: false)
                              .updateSetInTrackedExercise(
                            trackedExerciseId: widget.trackedExerciseId,
                            index: index,
                            set: sets[index],
                          );

                          if (!isSetUpdated) {
                            sets[index].time = timeBeforeUpdate;
                          } else {
                            updateRestOfSetsElligibleIndex = index;
                          }
                        },
                        canEdit: !set.isLogged,
                        hintText: previousSetTime,
                      ),
                    ),
                  RowItem(
                    child: Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: set.isLogged,
                        activeColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              ConfigProvider.defaultSpace / 2),
                        ),
                        onChanged: (val) {
                          // can log based on current values
                          double? weight;
                          if (widget.exerciseDimensions?.isWeightEnabled ??
                              true) {
                            weight = sets[index].weight ??
                                double.tryParse(previousSetWeight);
                            weight ??= 0.0;
                          }
                          int? reps;
                          if (widget.exerciseDimensions?.isRepEnabled ?? true) {
                            reps = sets[index].reps ??
                                int.tryParse(previousSetReps);
                            reps ??= 0;
                          }
                          double? distance;
                          if (widget.exerciseDimensions?.isDistanceEnabled ??
                              false) {
                            distance = sets[index].distance ??
                                double.tryParse(previousSetDistance);
                            distance ??= 0.0;
                          }

                          String? time;
                          if (widget.exerciseDimensions?.isTimeEnabled ??
                              false) {
                            time = TimeInputFormatter.padFormattedTimeInput(
                                    sets[index].time) ??
                                previousSetTime;
                            if (time.isEmpty) {
                              time = "00:00:00";
                            }
                          }
                          // var canLog = true weight != null && reps != null;
                          var canLog = true;

                          if (canLog) {
                            print("logging set $index");
                            _onLog(
                              trackedExerciseId: widget.trackedExerciseId,
                              index: index,
                              val: val ?? false,
                              setWeight: weight,
                              setReps: reps,
                              setDistance: distance,
                              setTime: time,
                            );
                          } else {
                            print("Cannot log set $index");
                          }
                        }),
                  ),
                ],
              ),
              if (index == updateRestOfSetsIndex)
                TextButton(
                  onPressed: updateRestOfSets,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Apply this change to the remaining sets?",
                        style: TextStyleTemplates.smallTextStyle(
                            ConfigProvider.mainColor),
                      ),
                      TimeBasedIndicator(
                          timeLenghtInMilliseconds:
                              updateRestOfSetsPromptTimerAllowedSeconds * 1000),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header row
          Row(children: generateHeaderRow()),
          ...generateSetRows(),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: TextButton(
          //     onPressed: () {
          //       var set = SetDto();

          //       var setAdded =
          //           Provider.of<WorkoutProvider>(context, listen: false)
          //               .addSetToTrackedExercise(widget.trackedExerciseId, set);
          //       if (setAdded) {
          //         setState(() {
          //           sets.add(set);
          //         });
          //       }
          //     },
          //     style: TextButton.styleFrom(
          //         backgroundColor: ConfigProvider.mainColor,
          //         visualDensity: VisualDensity.compact),
          //     child: Text(
          //       "ADD SET",
          //       style: TextStyleTemplates.smallBoldTextStyle(
          //         Utility.getTextColorBasedOnBackground(),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
