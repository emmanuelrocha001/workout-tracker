import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_tracker/models/exercise_type_dto.dart';

import '../../providers/config_provider.dart';
import '../../providers/workout_provider.dart';

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
  void dispose() {
    super.dispose();
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
    required double setWeight,
    required int setReps,
    required double setDistance,
    required String setTime,
  }) {
    if (index >= 0 && index < sets.length) {
      var timerAlreadyShown = sets[index].restTimerShown;
      var tSet = SetDto.getCopy(sets[index]);
      print("on log $index");
      tSet.weight = setWeight;
      tSet.reps = setReps;
      tSet.isLogged = val;
      tSet.distance = setDistance;
      tSet.time = setTime;
      tSet.restTimerShown = true;
      _onUpdateSet(trackedExerciseId, index, tSet);
      // erocha todo - need to check if timer has already been shown and if setting is enabled
      var workoutProvider =
          Provider.of<WorkoutProvider>(context, listen: false);

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
    var setRemoved = Provider.of<WorkoutProvider>(context, listen: false)
        .deleteSetFromTrackedExercise(trackedExcerciseId, index);
    if (setRemoved) {
      setState(() {
        sets.removeAt(index);
      });
    }
  }

  void _onUpdateSet(String trackedExerciseId, int index, SetDto set) {
    var setUpdated = Provider.of<WorkoutProvider>(context, listen: false)
        .updateSetInTrackedExercise(trackedExerciseId, index, set);

    if (setUpdated) {
      setState(() {
        sets[index] = set;
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
          // color: set.isLogged ? Colors.green : Colors.transparent,
          child: Row(
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
                      var isUpdated =
                          Provider.of<WorkoutProvider>(context, listen: false)
                              .updateSetInTrackedExercise(
                                  widget.trackedExerciseId, index, sets[index]);

                      if (!isUpdated) {
                        sets[index].weight = weightBeforeUpdate;
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
                      var isUpdated =
                          Provider.of<WorkoutProvider>(context, listen: false)
                              .updateSetInTrackedExercise(
                                  widget.trackedExerciseId, index, sets[index]);

                      if (!isUpdated) {
                        sets[index].reps = repsBeforeUpdate;
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
                      var isUpdated =
                          Provider.of<WorkoutProvider>(context, listen: false)
                              .updateSetInTrackedExercise(
                                  widget.trackedExerciseId, index, sets[index]);

                      if (!isUpdated) {
                        sets[index].distance = distanceBeforeUpdate;
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
                      var isUpdated =
                          Provider.of<WorkoutProvider>(context, listen: false)
                              .updateSetInTrackedExercise(
                                  widget.trackedExerciseId, index, sets[index]);

                      if (!isUpdated) {
                        sets[index].time = timeBeforeUpdate;
                      }
                    },
                    canEdit: !set.isLogged,
                    hintText: previousSetTime,
                  ),
                ),
              RowItem(
                child: Checkbox(
                    value: set.isLogged,
                    activeColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          ConfigProvider.defaultSpace / 2),
                    ),
                    onChanged: (val) {
                      // can log based on current values
                      var weight = sets[index].weight ??
                          double.tryParse(previousSetWeight);
                      var reps =
                          sets[index].reps ?? int.tryParse(previousSetReps);
                      var distance = sets[index].distance ??
                          double.tryParse(previousSetDistance);

                      var time = TimeInputFormatter.padFormattedTimeInput(
                              sets[index].time) ??
                          previousSetTime;
                      // var canLog = true weight != null && reps != null;
                      var canLog = true;

                      if (canLog) {
                        print("logging set $index");
                        _onLog(
                          trackedExerciseId: widget.trackedExerciseId,
                          index: index,
                          val: val ?? false,
                          setWeight: weight ?? 0.0,
                          setReps: reps ?? 0,
                          setDistance: distance ?? 0.0,
                          setTime: time,
                        );
                      } else {
                        print("Cannot log set $index");
                      }
                    }),
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
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
              child: TextButton(
                onPressed: () {
                  var set = SetDto();

                  var setAdded = Provider.of<WorkoutProvider>(context,
                          listen: false)
                      .addSetToTrackedExercise(widget.trackedExerciseId, set);
                  if (setAdded) {
                    setState(() {
                      sets.add(set);
                    });
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: ConfigProvider.mainColor,
                ),
                child: Text(
                  "ADD SET",
                  style: TextStyleTemplates.smallBoldTextStyle(
                    Utility.getTextColorBasedOnBackground(),
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
