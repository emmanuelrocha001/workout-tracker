import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/widgets/general/default_container.dart';
import '../../models/create_update_exercise_dto.dart';
import '../../providers/exercise_provider.dart';
import '../../providers/workout_provider.dart';

import '../exercise/create_update_exercise_form.dart';
import '../../providers/config_provider.dart';

import '../general/overlay_content.dart';
import '_editable_exercise_list.dart';
import '../general/text_style_templates.dart';
import '../general/default_tooltip.dart';
import '../helper.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  final ScrollController scrollController = ScrollController();

  void createNewExercise(BuildContext context) async {
    var input = await Helper.showPopUp(
      title: "New Exercise",
      context: context,
      content: const SingleChildScrollView(
        child: CreateUpdateExerciseForm(),
      ),
    );
    if (input != null && input is CreateUpdateExerciseDto && context.mounted) {
      var exerciseProvider = Provider.of<ExerciseProvider>(
        context,
        listen: false,
      );
      var res = await exerciseProvider.createUserDefinedExercise(input);
      if (context.mounted) {
        Helper.showMessageBar(
            context: context, message: '${res.message}', isError: !res.success);
        if (res.success) {
          _scrollToTop();
        }
      }
    }
  }

  void _scrollToTop() {
    // scrollController.position.maxScrollExtent
    scrollController.jumpTo(0.0);
  }

  @override
  Widget build(BuildContext context) {
    var workoutProvider = Provider.of<WorkoutProvider>(context);
    return OverlayContent(
      blockContentMessage: workoutProvider.isWorkoutInProgress()
          ? 'Workout is in progress...'
          : null,
      overLayContent: Container(
        color: ConfigProvider.backgroundColorSolid,
        child: Row(
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
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
                child: TextButton(
                  onPressed: () => createNewExercise(context),
                  style: TextButton.styleFrom(
                    backgroundColor: ConfigProvider.mainColor,
                  ),
                  child: Text(
                    "NEW EXERCISE",
                    style: TextStyleTemplates.smallBoldTextStyle(
                      ConfigProvider.backgroundColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: ConfigProvider.defaultSpace / 2),
        child: DefaultContainer(
          child: EditableExerciseList(
            scrollController: scrollController,
          ),
        ),
      ),
    );
  }
}
