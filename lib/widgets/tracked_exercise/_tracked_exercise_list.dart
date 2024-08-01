import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/config_provider.dart';
import '../../providers/exercise_provider.dart';

import '../../models/tracked_exercise_dto.dart';

import '../exercise/_exercise_list.dart';
import './tracked_exercise_list_item.dart';
import './tracked_exercise_list_item_header.dart';

import '../general/overlay_top_widget.dart';
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

  // Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
  //   var exerciseProvider =
  //       Provider.of<ExerciseProvider>(context, listen: false);
  //   var trackedExercises = exerciseProvider.trackedExercises;
  //   var header = TrackedExerciseListItemHeader(
  //     trackedExercise: trackedExercises[index],
  //   );
  //   return AnimatedBuilder(
  //     animation: animation,
  //     builder: (BuildContext context, Widget? child) {
  //       final double animValue = Curves.easeInOut.transform(animation.value);
  //       final double elevation = lerpDouble(0, 6, animValue)!;
  //       final double scaleY = lerpDouble(100, 50, animValue)!;
  //       return SizedBox(
  //         height: scaleY,
  //         child: Material(
  //           borderRadius: BorderRadius.circular(ConfigProvider.defaultSpace),
  //           elevation: elevation,
  //           color: ConfigProvider.mainColor,
  //           shadowColor: ConfigProvider.mainColor,
  //           child: child,
  //         ),
  //       );
  //     },
  //     child: child,
  //   );
  // }

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
