import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/config_provider.dart';
import '../../providers/exercise_provider.dart';

import '../exercise/_exercise_list.dart';
import './tracked_exercise_list_item.dart';

import '../general/overlay_top_widget.dart';
import '../general/text_style_templates.dart';
import '../helper.dart';
import '../../utility.dart';

class TrackedExerciseList extends StatelessWidget {
  const TrackedExerciseList({super.key});

  void onAddExercise(BuildContext context) async {
    dynamic exerciseId = await Helper.showPopUp(
      context: context,
      title: 'Exercises',
      content: const ExerciseList(),
    );
    if (exerciseId != null && exerciseId.isNotEmpty) {
      var exerciseProvider =
          Provider.of<ExerciseProvider>(context, listen: false);
      exerciseProvider.addTrackedExercise(exerciseId);
      print('FROM selector ${exerciseId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTemplates = TextStyleTemplates();
    var exerciseProvider = Provider.of<ExerciseProvider>(context);
    var trackedExercises = exerciseProvider.trackedExercises;
    var title = DateFormat(ConfigProvider.simpleDateFormat)
        .format(DateTime.now())
        .toUpperCase();
    return OverlayContent(
      content: ReorderableListView(
        children: <Widget>[
          for (int index = 0; index < trackedExercises.length; index += 1)
            TrackedExerciseListItem(
              key: ValueKey(trackedExercises[index].id),
              trackedExercise: trackedExercises[index],
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          print('${oldIndex} ${newIndex}');
          try {
            var exerciseProvider =
                Provider.of<ExerciseProvider>(context, listen: false);
            exerciseProvider.reorderTrackedExercises(oldIndex, newIndex);
          } catch (e) {
            print('from catch ${e}');
          }
        },
      ),
      overLayContent: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
            child: Text(
              title,
              style: textTemplates
                  .mediumBoldTextStyle(ConfigProvider.mainTextColor),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
              child: TextButton(
                onPressed: () {
                  onAddExercise(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: ConfigProvider.mainColor,
                ),
                child: Text(
                  "ADD EXERCISE",
                  style: textTemplates.smallBoldTextStyle(
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
