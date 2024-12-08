import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/models/create_update_exercise_dto.dart';
import 'package:workout_tracker/providers/exercise_provider.dart';
import '../../providers/config_provider.dart';

import '../../models/exercise_dto.dart';
import '../general/overlay_content.dart';
import '_editable_exercise_list.dart';
import '../general/text_style_templates.dart';
import '../general/default_tooltip.dart';
import './_exercise_details.dart';
import '../helper.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  final ScrollController scrollController = ScrollController();

  void createNewExercise(BuildContext context) async {
    var res = await Helper.showPopUp(
      title: "New Exercise",
      context: context,
      content: const SingleChildScrollView(
        child: ExerciseDetails(
          inEditMode: true,
        ),
      ),
    );
    if (res != null && res is CreateUpdateExerciseDto && context.mounted) {
      var newExercise = ExerciseDto.newInstance(
        name: res.name,
        muscleGroupId: res.muscleGroupId,
        exerciseType: res.exerciseType,
        description: res.description,
        youtubeId: res.youtubeId,
      );
      var exerciseProvider = Provider.of<ExerciseProvider>(
        context,
        listen: false,
      );
      exerciseProvider.createUpdateExercise(newExercise);
      if (true) {
        _scrollToTop();
      }
    }
  }

  void _scrollToTop() {
    // scrollController.position.maxScrollExtent
    scrollController.jumpTo(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return OverlayContent(
        overLayContent: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
              child: Text(
                "Exercises",
                style: TextStyleTemplates.mediumBoldTextStyle(
                    ConfigProvider.mainTextColor),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: ConfigProvider.defaultSpace),
              child: DefaultTooltip(
                message: ConfigProvider.exercisesPageToolTip,
              ),
            ),
            const Spacer(),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Padding(
            //     padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
            //     child: TextButton(
            //       onPressed: () => createNewExercise(context),
            //       style: TextButton.styleFrom(
            //         backgroundColor: ConfigProvider.mainColor,
            //       ),
            //       child: Text(
            //         "NEW EXERCISE",
            //         style: TextStyleTemplates.smallBoldTextStyle(
            //           ConfigProvider.backgroundColor,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.all(
            ConfigProvider.defaultSpace,
          ),
          child: EditableExerciseList(
            scrollController: scrollController,
          ),
        ));
  }
}
