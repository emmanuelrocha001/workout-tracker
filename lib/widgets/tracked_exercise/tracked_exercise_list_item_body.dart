import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/exercise_provider.dart';

import '../../providers/config_provider.dart';

import '../../utility.dart';
import '../../widgets/general/text_style_templates.dart';

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
  List<String> currentlyEditingTextFieldHistory = [];
  int? currentEditingTextFieldIndex;
  List<TextEditingController> _weightControllers = [];
  List<TextEditingController> _repsControllers = [];

  @override
  void initState() {
    super.initState();
    sets = [...widget.sets];

    // _repsControllers = widget.sets.mapIndexed((index, set) {
    //   return TextEditingController(
    //     text: set.reps != null ? set.reps.toString() : '',
    //   );
    // }).toList();
  }

  Widget rowItem(Widget content) {
    return Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(ConfigProvider.defaultSpace / 2),
          child: content,
        ),
      ),
    );
  }

  List<Widget> generateHeaderRow() {
    var headers = ['SET', 'WEIGHT', 'REPS', 'LOG'];
    var textStyleTemplates = TextStyleTemplates();
    return headers
        .map((text) => rowItem(
              Text(
                text,
                style: textStyleTemplates.smallBoldTextStyle(
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
    var textStyleTemplates = TextStyleTemplates();
    // TODO fix and account for jumping around different text fields
    void formatAndSaveValue() {
      if (controller.text.isEmpty) {
        save(0.0);
        controller.text = '0';
      } else {
        var parsedValue = double.parse(controller.text);
        save(parsedValue);

        var formattedValue = parsedValue.toStringAsFixed(
            parsedValue.truncateToDouble() == parsedValue ? 0 : 2);

        controller.text = formattedValue;
      }
    }

    return TextField(
      keyboardType: const TextInputType.numberWithOptions(signed: true),
      textInputAction: TextInputAction.done,
      cursorColor: ConfigProvider.mainColor,
      onSubmitted: (value) {
        print("on submitted");
      },
      onTapOutside: (event) {
        // save on tap outside
        if (controller.text.isEmpty) {
          save(0.0);
          controller.text = '0';
        } else {
          var parsedValue = double.parse(controller.text);
          save(parsedValue);

          var formattedValue = parsedValue.toStringAsFixed(
              parsedValue.truncateToDouble() == parsedValue ? 0 : 2);

          controller.text = formattedValue;
        }
      },
      onTap: () {
        // reset history
        print("on text field tap, restting history");
        currentlyEditingTextFieldHistory = [controller.text];
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          RegExp pattern = RegExp(allowDecimal
              ? ConfigProvider.decimalRegexPattern
              : ConfigProvider.digitRegexPattern);
          if (pattern.hasMatch(value)) {
            currentlyEditingTextFieldHistory.add(value);
          } else {
            controller.text = currentlyEditingTextFieldHistory.last;
          }
        }
      },
      enabled: canEdit,
      controller: controller,
      decoration: InputDecoration(
        fillColor: ConfigProvider.slightContrastBackgroundColor,
        hintStyle: textStyleTemplates.defaultTextStyle(
          ConfigProvider.alternateTextColor.withOpacity(.5),
        ),
        filled: true,
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: textStyleTemplates.defaultTextStyle(
        ConfigProvider.mainTextColor,
      ),
      inputFormatters: [
        allowDecimal
            ? FilteringTextInputFormatter.deny(RegExp(r'[^\d.]'))
            : FilteringTextInputFormatter.digitsOnly,
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
    double? previousSetWeight,
    int? previousSetReps,
  }) {
    if (index >= 0 && index < sets.length) {
      var tSet = SetDto.getCopy(sets[index]);
      if (previousSetWeight != null) {
        tSet.weight = previousSetWeight;
      }
      if (previousSetReps != null) {
        tSet.reps = previousSetReps;
      }
      tSet.isLogged = val;
      _onUpdateSet(trackedExerciseId, index, tSet);
    }
  }

  void _onRemoveSet(trackedExcerciseId, int index) {
    var setRemoved = Provider.of<ExerciseProvider>(context, listen: false)
        .removeSetFromTrackedExercise(trackedExcerciseId, index);
    if (setRemoved) {
      setState(() {
        sets.removeAt(index);
      });
    }
  }

  void _onUpdateSet(String trackedExerciseId, int index, SetDto set) {
    var setUpdated = Provider.of<ExerciseProvider>(context, listen: false)
        .updateSetInTrackedExercise(trackedExerciseId, index, set);
    if (setUpdated) {
      setState(() {
        sets[index] = set;
      });
    }
  }

  List<Widget> generateSetRows() {
    var textStyleTemplates = TextStyleTemplates();
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
      var canLog = (set.reps != null || previousSetReps.isNotEmpty) &&
          (set.weight != null || previousSetWeight.isNotEmpty);
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
        child: Row(
          children: [
            rowItem(Text(
              '$index',
              style: textStyleTemplates.defaultTextStyle(
                ConfigProvider.mainTextColor,
              ),
            )),
            rowItem(
              getNumberInput(
                controller: _weightControllers[index],
                save: (double number) {
                  print("saving weight for index $index");
                  var weightBeforeUpdate = sets[index].weight;
                  sets[index].weight = number;
                  var isUpdated =
                      Provider.of<ExerciseProvider>(context, listen: false)
                          .updateSetInTrackedExercise(
                              widget.trackedExerciseId, index, sets[index]);
                  setState(() {
                    if (!isUpdated) {
                      print("was not updated");
                      sets[index].weight = weightBeforeUpdate;
                    }
                  });
                },
                allowDecimal: true,
                canEdit: !set.isLogged,
                hintText: previousSetWeight,
              ),
            ),
            rowItem(
              getNumberInput(
                controller: _repsControllers[index],
                save: (double number) {
                  print("saving reps for index $index");
                  var repsBeforeUpdate = sets[index].reps;
                  sets[index].reps = number.toInt();
                  var isUpdated =
                      Provider.of<ExerciseProvider>(context, listen: false)
                          .updateSetInTrackedExercise(
                              widget.trackedExerciseId, index, sets[index]);
                  setState(() {
                    if (!isUpdated) {
                      sets[index].reps = repsBeforeUpdate;
                    }
                  });
                },
                allowDecimal: false,
                canEdit: !set.isLogged,
                hintText: previousSetReps,
              ),
            ),
            rowItem(
              Checkbox(
                value: set.isLogged,
                activeColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(ConfigProvider.defaultSpace / 2),
                ),
                onChanged: canLog
                    ? (val) {
                        _onLog(
                          trackedExerciseId: widget.trackedExerciseId,
                          index: index,
                          val: val ?? false,
                          previousSetWeight: sets[index].weight == null
                              ? double.tryParse(previousSetWeight)
                              : null,
                          previousSetReps: sets[index].reps == null
                              ? int.tryParse(previousSetReps)
                              : null,
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // print("rebuilding body in tracked exercise list item");
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

                  var setAdded = Provider.of<ExerciseProvider>(context,
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
                  style: TextStyleTemplates().smallTextStyle(
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
