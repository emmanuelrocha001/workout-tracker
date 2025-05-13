import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:workout_tracker/models/template_dto.dart';
import 'package:workout_tracker/widgets/templates/_selectable_template_day_list.dart';

import '../../providers/config_provider.dart';
import '../../models/muscle_group_dto.dart';

import '../general/text_style_templates.dart';
import '../general/default_menu_item_button.dart';

import "../general/pill_container.dart";
import "../../models/exercise_dto.dart";

import './_template_day_grid.dart';

import '../helper.dart';

class TemplateListItem extends StatelessWidget {
  final TemplateDto data;
  final String? selectedId;
  final void Function(String?)? onSelect;

  const TemplateListItem({
    super.key,
    required this.data,
    this.selectedId,
    required this.onSelect,
  });

  void onSelectDay(BuildContext context) async {
    dynamic selectedIndex = await Helper.showPopUp(
      context: context,
      title: "Select Template Day",
      content: SelectableTemplateDayList(
        template: data,
      ),
    );

    if (selectedIndex is int && context.mounted) {
      // var selectedValue = '${data.id} - ${selectedIndex + 1}';
      // print(jsonEncode(data.days![selectedIndex]));
      // print(selectedValue);
      Navigator.of(context).pop((data, selectedIndex));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ConfigProvider.backgroundColorSolid,
      elevation: 0,
      shape: const BorderDirectional(
        top: BorderSide(
          width: 1,
          color: ConfigProvider.slightContrastBackgroundColor,
        ),
      ),
      child: ListTile(
        onTap: () => onSelectDay(context),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.emphasis.toUpperCase(),
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
        subtitle: Row(
          spacing: ConfigProvider.defaultSpace,
          children: [
            PillContainer(
              color: ConfigProvider.backgroundColor,
              child: Text(
                '${data.numberOfDays}/WEEK',
                style: TextStyleTemplates.defaultTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
            ),
            PillContainer(
              color: ConfigProvider.backgroundColor,
              child: Text(
                data.sex.toUpperCase(),
                style: TextStyleTemplates.defaultTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
