import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/models/template_dto.dart';
import '../../providers/exercise_provider.dart';

import '../general/overlay_content.dart';
import '../general/default_tooltip.dart';
import '../general/default_menu_item_button.dart';
import '../../providers/config_provider.dart';
import '../../providers/workout_provider.dart';

import '../general/text_style_templates.dart';
import '../helper.dart';
import '../templates/_template_list.dart';
import '../../utility.dart';

class StartNewWorkout extends StatelessWidget {
  const StartNewWorkout({super.key});

  void onStartFromTemplate(BuildContext context) async {
    dynamic selectedTemplateInfo = await Helper.showPopUp(
      context: context,
      title: 'Select Template',
      content: const TemplateList(),
    );

    if (selectedTemplateInfo is (
          TemplateDto selectedTemplate,
          int selectedDayIndex
        ) &&
        context.mounted) {
      print(
          "Selected Template: ${selectedTemplateInfo.$1.id} - Day ${selectedTemplateInfo.$2 + 1}");
      var workoutProvider =
          // ignore: use_build_context_synchronously
          Provider.of<WorkoutProvider>(context, listen: false);
      workoutProvider.startWorkoutFromTemplateDay(
        template: selectedTemplateInfo.$1,
        daySlotIndex: selectedTemplateInfo.$2,
      );
    }

    // if (exerciseId != null && exerciseId.isNotEmpty) {
    //   if (context.mounted) {
    //     var workoutProvider =
    //         // ignore: use_build_context_synchronously
    //         Provider.of<WorkoutProvider>(context, listen: false);
    //     var exerciseProvider =
    //         // ignore: use_build_context_synchronously
    //         Provider.of<ExerciseProvider>(context, listen: false);

    //     var configProvider =
    //         // ignore: use_build_context_synchronously
    //         Provider.of<ConfigProvider>(context, listen: false);

    //     var exercise = exerciseProvider.getExerciseById(exerciseId);

    //     if (exercise == null) return;

    //     workoutProvider.addTrackedExercise(
    //       exercise: exercise,
    //       autoPopulateWorkoutFromSetsHistory:
    //           configProvider.autoPopulateWorkoutFromSetsHistory,
    //     );
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    var workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    var configProvider = Provider.of<ConfigProvider>(context, listen: false);
    return OverlayContent(
      overLayContent: Container(
        color: ConfigProvider.backgroundColorSolid,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
              child: Text(
                "Workout",
                style: TextStyleTemplates.mediumBoldTextStyle(
                    ConfigProvider.mainTextColor),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
              child: MenuAnchor(
                style: const MenuStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                      ConfigProvider.backgroundColorSolid),
                  // elevation: WidgetStatePropertyAll<double>(0.0),
                ),
                builder: (BuildContext context, MenuController controller,
                    Widget? child) {
                  return Row(
                    spacing: .5,
                    children: [
                      IconButton(
                        style: const ButtonStyle(
                          visualDensity: VisualDensity.comfortable,
                          backgroundColor:
                              WidgetStatePropertyAll(ConfigProvider.mainColor),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    ConfigProvider.defaultSpace / 2),
                                bottomLeft: Radius.circular(
                                    ConfigProvider.defaultSpace / 2),
                              ),
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.more_vert_sharp,
                          color: ConfigProvider.backgroundColorSolid,
                          size: ConfigProvider.smallIconSize,
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
                      ),
                      TextButton(
                        onPressed: () {
                          workoutProvider.startWorkout(
                            showRestTimerAfterEachSet:
                                configProvider.showRestTimerAfterEachSet,
                            autoPopulateWorkoutFromSetsHistory: configProvider
                                .autoPopulateWorkoutFromSetsHistory,
                          );
                        },
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.comfortable,
                          backgroundColor: ConfigProvider.mainColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                  ConfigProvider.defaultSpace / 2),
                              bottomRight: Radius.circular(
                                  ConfigProvider.defaultSpace / 2),
                            ),
                          ),
                        ),
                        child: Text(
                          "NEW WORKOUT",
                          style: TextStyleTemplates.smallBoldTextStyle(
                            Utility.getTextColorBasedOnBackground(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                menuChildren: [
                  DefaultMenuItemButton(
                    icon: Icons.folder_open_rounded,
                    label: "NEW FROM TEMPLATE",
                    onPressed: () {
                      onStartFromTemplate(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      content: Center(
        child: Text(
          'No In Progress Workout',
          style:
              TextStyleTemplates.defaultTextStyle(ConfigProvider.mainTextColor),
        ),
      ),
    );
  }
}
