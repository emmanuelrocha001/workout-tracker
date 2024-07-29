import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:workout_tracker/default_configs.dart';
import 'package:workout_tracker/models/muscle_group_dto.dart';
import 'package:workout_tracker/utility.dart';

import '../general/text_style_templates.dart';

import "../general/pill_container.dart";
import "../../models/exercise_dto.dart";

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

  void _navigateToYoutube() async {
    var baseUrl = "https://www.youtube.com";

    var url = (data.youtubeId?.isNotEmpty ?? false)
        ? "$baseUrl/watch?v=${data.youtubeId}"
        : "$baseUrl/results?search_query=${Uri.encodeComponent(data.name)}";

    await launchUrlString(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var textTemplates = TextStyleTemplates();
    return Card(
      color: DefaultConfigs.backgroundColor,
      elevation: 0,
      shape: const BorderDirectional(
        bottom: BorderSide(
          width: 1,
          color: DefaultConfigs.slightContrastBackgroundColor,
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
              return DefaultConfigs.mainColor;
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
              style: textTemplates.smallTextStyle(
                DefaultConfigs.mainTextColor.withOpacity(
                  DefaultConfigs.mainTextColorWithOpacityPercent,
                ),
              ),
            ),
            Text(
              data.name,
              style: textTemplates.defaultTextStyle(
                DefaultConfigs.mainTextColor,
              ),
            ),
          ],
        ),
        subtitle: Align(
          alignment: Alignment.centerLeft,
          child: PillContainer(
            color: DefaultConfigs.slightContrastBackgroundColor,
            child: Text(
              data.exerciseType.toUpperCase(),
              style: textTemplates.defaultTextStyle(
                DefaultConfigs.mainTextColor,
              ),
            ),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.chevron_right,
          ),
          style: _theme.iconButtonTheme.style,
          onPressed: _navigateToYoutube,
        ),
      ),
    );
  }
}
