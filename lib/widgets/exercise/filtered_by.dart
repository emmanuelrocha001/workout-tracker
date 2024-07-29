import 'package:flutter/material.dart';
import 'package:workout_tracker/default_configs.dart';
import 'package:workout_tracker/utility.dart';

import "../general/pill_container.dart";

import '../general/text_style_templates.dart';

class FilteredBy extends StatelessWidget {
  final List<String> filters;
  final void Function() onClearFilters;
  final void Function() onFilter;
  const FilteredBy({
    super.key,
    required this.filters,
    required this.onClearFilters,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    var textTemplates = TextStyleTemplates();
    return Container(
      color: DefaultConfigs.backgroundColor,
      child: ListTile(
        dense: true,
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PillContainer(
              child: Text(
                filters[0].toUpperCase(),
                style: textTemplates.smallBoldTextStyle(
                  DefaultConfigs.mainTextColor,
                ),
              ),
            ),
            const SizedBox(
              width: DefaultConfigs.defaultSpace,
            ),
            PillContainer(
              child: Text(
                filters[1].toUpperCase(),
                style: textTemplates.smallBoldTextStyle(
                  DefaultConfigs.mainTextColor,
                ),
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: onClearFilters,
              style: TextButton.styleFrom(
                backgroundColor: DefaultConfigs.slightContrastBackgroundColor,
              ),
              child: Text(
                "CLEAR",
                style: textTemplates.smallBoldTextStyle(
                  DefaultConfigs.mainColor,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            TextButton(
              onPressed: onFilter,
              style: TextButton.styleFrom(
                backgroundColor: DefaultConfigs.mainColor,
              ),
              child: Text(
                "FILTER",
                style: textTemplates.smallBoldTextStyle(
                  Utility.getTextColorBasedOnBackground(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
