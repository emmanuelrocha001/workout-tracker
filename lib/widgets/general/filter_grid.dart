import 'package:flutter/material.dart';
import '../../providers/config_provider.dart';
import 'package:workout_tracker/utility.dart';

import "../../models/exercise_type_dto.dart";
import "../../models/filters_dto.dart";

import '../general/text_style_templates.dart';

import './overlay_action_button.dart';

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
    var tempWidgets = <Widget>[];
    for (var cFilter in filters) {
      var cFilterTitle = SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cFilter.name.toLowerCase(),
            style: TextStyleTemplates.mediumTextStyle(
              ConfigProvider.mainTextColor,
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
                  overlayColor: ConfigProvider.mainTextColor,
                  elevation: 0.0,
                  backgroundColor: isSelected
                      ? ConfigProvider.mainColor
                      : ConfigProvider.slightContrastBackgroundColor,
                  side: BorderSide(
                    color: isSelected
                        ? ConfigProvider.mainColor
                        : ConfigProvider.slightContrastBackgroundColor,
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
                  style: TextStyleTemplates.defaultTextStyle(
                    isSelected
                        ? Utility.getTextColorBasedOnBackground()
                        : ConfigProvider.mainTextColor,
                  ),
                ),
              ),
            );
          },
          childCount: cFilter.filters.length,
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
    return OverlayActionButton(
      content: CustomScrollView(
        slivers: <Widget>[
          ..._generateWidgets(filters),
          const SliverPadding(
            padding: EdgeInsets.all(ConfigProvider.largeSpace),
          )
        ],
      ),
      showActionButton: _filtersUpdated(),
      label: "APPLY",
      onPressed: onApply,
    );
  }
}
