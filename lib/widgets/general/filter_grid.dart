import 'package:flutter/material.dart';
import 'package:workout_tracker/default_configs.dart';
import 'package:workout_tracker/utility.dart';

import '../../providers/exercise_provider.dart';

import "../../models/exercise_type_dto.dart";
import "../../models/filters_dto.dart";

import '../general/text_style_templates.dart';

class FilterGrid extends StatelessWidget {
  final List<FiltersDto> filters;
  final void Function(String, FilterDto) onSelect;
  final void Function() onApply;
  const FilterGrid({
    super.key,
    required this.filters,
    required this.onSelect,
    required this.onApply,
  });

  List<Widget> _generateWidgets(List<FiltersDto> filters) {
    var textStyles = TextStyleTemplates();
    var tempWidgets = <Widget>[];
    for (var cFilter in filters) {
      var cFilterTitle = SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cFilter.name.toLowerCase(),
            style: textStyles.mediumTextStyle(
              DefaultConfigs.mainTextColor,
            ),
          ),
        ),
      );

      var cFilterGrid = SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 4.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            var isSelected =
                (cFilter.tempSelectedValue == cFilter.filters[index].value);
            return SizedBox.expand(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  overlayColor: DefaultConfigs.mainTextColor,
                  elevation: 0.0,
                  backgroundColor: isSelected
                      ? DefaultConfigs.mainColor
                      : DefaultConfigs.slightContrastBackgroundColor,
                  side: BorderSide(
                    color: isSelected
                        ? DefaultConfigs.mainColor
                        : DefaultConfigs.slightContrastBackgroundColor,
                    width: 2.0,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
                onPressed: () {
                  onSelect(cFilter.name, cFilter.filters[index]);
                },
                child: Text(
                  cFilter.filters[index].displayValue.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: textStyles.defaultTextStyle(
                    isSelected
                        ? Utility.getTextColorBasedOnBackground()
                        : DefaultConfigs.mainTextColor,
                  ),
                ),
              ),
            );
          },
          childCount: exerciseTypes.length,
        ),
      );

      tempWidgets.add(cFilterTitle);
      tempWidgets.add(cFilterGrid);
    }
    return tempWidgets;
  }

  bool _filtersUpdated() {
    for (var filter in filters) {
      if (filter.tempSelectedValue != filter.selectedValue) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var textTemplates = TextStyleTemplates();
    return Stack(
      children: [
        CustomScrollView(
          slivers: <Widget>[
            ..._generateWidgets(filters),
            const SliverPadding(
              padding: EdgeInsets.all(DefaultConfigs.largeSpace),
            )
          ],
        ),
        if (_filtersUpdated())
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: DefaultConfigs.largeSpace * 2,
              color: Colors.black.withOpacity(.1),
              child: Padding(
                padding: const EdgeInsets.all(DefaultConfigs.defaultSpace),
                child: Center(
                  child: SizedBox(
                    width: DefaultConfigs.maxButtonSize,
                    child: TextButton(
                      onPressed: onApply,
                      style: TextButton.styleFrom(
                        backgroundColor: DefaultConfigs.mainColor,
                      ),
                      child: Text(
                        "APPLY",
                        style: textTemplates.smallBoldTextStyle(
                          Utility.getTextColorBasedOnBackground(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
