import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/config_provider.dart';
import '../../providers/workout_provider.dart';

import '../general/custom_number_input_formatter.dart';
import '../general/row_item.dart';

import '../helper.dart';
import './rest_timer.dart';
import '../../utility.dart';
import '../general/text_style_templates.dart';

import '../../models/tracked_exercise_dto.dart';

class TrackedExerciseListItemBody extends StatefulWidget {
  final String trackedExerciseId;
  final List<SetDto> sets;
  const TrackedExerciseListItemBody({
    super.key,
    required this.trackedExerciseId,
    required this.sets,
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
    var headers = ['SET', 'WEIGHT', 'REPS', 'LOG'];
    return headers
        .map((text) => RowItem(
              child: Text(
                text,
                style: TextStyleTemplates.smallBoldTextStyle(
                  ConfigProvider.mainTextColor,
                ),
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
        fillColor: ConfigProvider.slightContrastBackgroundColor,
        hintStyle: TextStyleTemplates.defaultTextStyle(
          ConfigProvider.alternateTextColor.withOpacity(.5),
        ),
        filled: true,
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyleTemplates.defaultTextStyle(
        ConfigProvider.mainTextColor,
      ),
      inputFormatters: [
        allowDecimal
            ? FilteringTextInputFormatter.deny(RegExp(r'[^\d.]'))
            : FilteringTextInputFormatter.digitsOnly,
        CustomNumberInputFormatter(allowDecimals: allowDecimal),
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

  void _onLog({
    required String trackedExerciseId,
    required int index,
    required bool val,
    required double setWeight,
    required int setReps,
  }) {
    if (index >= 0 && index < sets.length) {
      var timerAlreadyShown = sets[index].restTimerShown;
      var tSet = SetDto.getCopy(sets[index]);
      tSet.weight = setWeight;
      tSet.reps = setReps;
      tSet.isLogged = val;
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

    return sets.mapIndexed((index, set) {
      var previousSetReps = getPreviousSetReps(index);
      var previousSetWeight = getPreviousSetWeight(index);

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
              RowItem(
                child: getNumberInput(
                  controller: _weightControllers[index],
                  save: (double number) {
                    print("saving weight for index $index");
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
              RowItem(
                child: getNumberInput(
                  controller: _repsControllers[index],
                  save: (double number) {
                    print("saving reps for index $index");
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

                      var canLog = weight != null && reps != null;
                      if (canLog) {
                        print("logging set $index");
                        _onLog(
                          trackedExerciseId: widget.trackedExerciseId,
                          index: index,
                          val: val ?? false,
                          setWeight: weight,
                          setReps: reps,
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
