import 'package:flutter/material.dart';
import '../../providers/config_provider.dart';
import "../../models/template_dto.dart";

import './_template_day_grid_item.dart';

class SelectableTemplateDayGrid extends StatefulWidget {
  final List<TemplateDayDto> days;
  final String name;
  final String emphasis;
  final String sex;

  const SelectableTemplateDayGrid({
    super.key,
    required this.days,
    required this.name,
    required this.emphasis,
    required this.sex,
  });

  @override
  State<SelectableTemplateDayGrid> createState() =>
      _SelectableTemplateDayGridState();
}

class _SelectableTemplateDayGridState extends State<SelectableTemplateDayGrid> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250.0,
            mainAxisExtent: 225.0,
            mainAxisSpacing: ConfigProvider.defaultSpace,
            crossAxisSpacing: ConfigProvider.defaultSpace,
            childAspectRatio: 4.0,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              var isSelected = index == selectedIndex;
              return SizedBox.expand(
                child: TemplateDayGridItem(
                  day: widget.days[index],
                  name: widget.name,
                  emphasis: widget.emphasis,
                  sex: widget.sex,
                  numberOfDays: widget.days.length,
                  onSelect: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  selectedPosition: selectedIndex,
                ),
              );
            },
            childCount: widget.days.length,
          ),
        ),
      ],
    );
  }
}
