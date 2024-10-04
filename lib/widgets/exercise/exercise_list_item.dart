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
  final String selectedId;
  final void Function(String?) onSelect;
  const ExerciseListItem({
    super.key,
    required this.data,
    required this.selectedId,
    required this.onSelect,
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
        onTap: () => onSelect(data.id),
        leading: Radio(
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

          // onChanged: onSelect,
        ),
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
        trailing: IconButton(
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
        ),
      ),
    );
  }
}
