import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../providers/config_provider.dart';
import '../../models/muscle_group_dto.dart';

import '../general/text_style_templates.dart';

import "../general/pill_container.dart";
import "../../models/exercise_dto.dart";

import '../helper.dart';

class ExerciseListItem extends StatelessWidget {
  final ExerciseDto data;
  final String? selectedId;
  final void Function(String?)? onSelect;
  final void Function({
    required ExerciseDto exercise,
  })? showDetails;
  final void Function({
    required ExerciseDto exercise,
  })? updateExercise;
  final void Function({
    required ExerciseDto exercise,
  })? deleteExercise;
  const ExerciseListItem({
    super.key,
    required this.data,
    this.selectedId,
    this.onSelect,
    this.showDetails,
    this.updateExercise,
    this.deleteExercise,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ConfigProvider.backgroundColor,
      elevation: 0,
      shape: const BorderDirectional(
        bottom: BorderSide(
          width: 1,
          color: ConfigProvider.slightContrastBackgroundColor,
        ),
      ),
      child: ListTile(
        onTap: () => onSelect != null
            ? onSelect!(data.id)
            : showDetails != null
                ? showDetails!(
                    exercise: data,
                  )
                : null,
        leading: onSelect != null
            ? Radio(
                value: data.id,
                groupValue: selectedId,
                // activeColor: const Color.fromARGB(255, 44, 78, 128),
                fillColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    return ConfigProvider.mainColor;
                  },
                ),
                onChanged: null,
                toggleable: false,
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              MuscleGroupDto.getMuscleGroupName(data.muscleGroupId)
                  .toUpperCase(),
              style: TextStyleTemplates.smallTextStyle(
                ConfigProvider.mainTextColor.withOpacity(
                  ConfigProvider.mainTextColorWithOpacityPercent,
                ),
              ),
            ),
            Text(
              data.name,
              style: TextStyleTemplates.defaultTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
          ],
        ),
        subtitle: Align(
          alignment: Alignment.centerLeft,
          child: PillContainer(
            color: ConfigProvider.slightContrastBackgroundColor,
            child: Text(
              data.exerciseType.toUpperCase(),
              style: TextStyleTemplates.defaultTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
          ),
        ),
        trailing: onSelect != null
            ? IconButton(
                icon: const Icon(
                  Icons.play_circle_fill_rounded,
                ),
                style: Theme.of(context).iconButtonTheme.style,
                onPressed: () {
                  Helper.navigateToYoutube(
                    youtubeId: data.youtubeId,
                    searchQuery: data.name,
                  );
                },
              )
            : data.isCustom &&
                    updateExercise != null &&
                    deleteExercise != null // temp for testing
                // ? IconButton(
                //     icon: const Icon(
                //       Icons.more_horiz_rounded,
                //       size: ConfigProvider.smallIconSize,
                //       color: ConfigProvider.mainColor,
                //     ),
                //     onPressed: () {
                //       updateExercise!(exercise: data);
                //     },
                //   )
                ? MenuAnchor(
                    style: const MenuStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                          ConfigProvider.backgroundColor),
                      // elevation: WidgetStatePropertyAll<double>(0.0),
                    ),
                    builder: (BuildContext context, MenuController controller,
                        Widget? child) {
                      return IconButton(
                        icon: const Icon(
                          Icons.more_horiz_rounded,
                          color: ConfigProvider.mainColor,
                          size: ConfigProvider.defaultIconSize,
                        ),
                        // style: _theme.iconButtonTheme.style,
                        onPressed: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                      );
                    },
                    menuChildren: [
                      MenuItemButton(
                        child: const Icon(
                          Icons.edit_rounded,
                          color: ConfigProvider.mainColor,
                          size: ConfigProvider.defaultIconSize,
                        ),
                        onPressed: () async {
                          updateExercise!(
                            exercise: data,
                          );
                        },
                      ),
                      MenuItemButton(
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red,
                          size: ConfigProvider.defaultIconSize,
                        ),
                        onPressed: () {
                          deleteExercise!(
                            exercise: data,
                          );
                        },
                      ),
                    ],
                  )
                : PillContainer(
                    color: ConfigProvider.slightContrastBackgroundColor,
                    child: Text(
                      'SYSTEM',
                      style: TextStyleTemplates.smallTextStyle(
                        ConfigProvider.mainTextColor,
                      ),
                    ),
                  ),
      ),
    );
  }
}
