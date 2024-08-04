import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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
  List<TextEditingController> _weightControllers = [];
  List<TextEditingController> _repsControllers = [];

  @override
  void initState() {
    super.initState();
    print("init state");
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
    String hintText = '',
  }) {
    var textStyleTemplates = TextStyleTemplates();
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(signed: true),
      textInputAction: TextInputAction.done,
      cursorColor: ConfigProvider.mainColor,
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
      inputFormatters: [
        allowDecimal
            ? FilteringTextInputFormatter.deny(RegExp(r'[^\d.]'))
            : FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }

  String getPreviousSetWeight(index) {
    if (index > 0 &&
        index < sets.length - 1 &&
        sets[index - 1].weight != null) {
      return sets[index - 1].weight.toString();
    }
    return '';
  }

  String getPreviousSetReps(index) {
    if (index > 0 && index < sets.length - 1 && sets[index - 1].reps != null) {
      return sets[index - 1].reps.toString();
    }
    return '';
  }

  void onSetWeightChange(String trackedExerciseId, int index) {
    // if (value.isNotEmpty) {
    //   sets[index].weight = double.parse(value);
    // }
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

    return sets
        .mapIndexed((index, set) => Dismissible(
              key: Key(
                  '${widget.trackedExerciseId}_${index}_${const Uuid().v4()}'),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Padding(
                  padding: EdgeInsets.all(ConfigProvider.defaultSpace),
                  child: Icon(
                    Feather.trash,
                    color: Colors.white,
                  ),
                ),
              ),
              onDismissed: (direction) {
                setState(() {
                  sets.removeAt(index);
                });
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
                        sets[index].weight = number;
                      },
                      allowDecimal: true,
                      hintText: getPreviousSetWeight(index),
                    ),
                  ),
                  rowItem(
                    getNumberInput(
                        controller: _repsControllers[index],
                        save: (double number) {
                          sets[index].reps = number.toInt();
                        },
                        allowDecimal: false),
                  ),
                  rowItem(
                    Checkbox(value: set.isLogged, onChanged: (val) {}),
                  ),
                ],
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuilding body in tracked exercise list item");
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
