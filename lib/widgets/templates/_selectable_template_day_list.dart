import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/models/template_dto.dart';
import 'package:workout_tracker/providers/templates_provider.dart';
import 'package:workout_tracker/widgets/templates/_template_day_grid_item.dart';
import 'package:workout_tracker/widgets/templates/_template_day_list_item.dart';

import '../../providers/exercise_provider.dart';
import '../../providers/workout_provider.dart';
import '../../providers/config_provider.dart';

import "../helper.dart";

import '../../models/exercise_dto.dart';
import '../exercise/_exercise_filters_grid.dart';
import '../../class_extensions.dart';
import './template_list_item.dart';
import '../workout/_exercise_details_with_history.dart';
import '../general/overlay_action_button.dart';

class SelectableTemplateDayList extends StatefulWidget {
  final TemplateDto template;
  const SelectableTemplateDayList({
    super.key,
    required this.template,
  });

  @override
  State<SelectableTemplateDayList> createState() =>
      _SelectableTemplateDayListState();
}

class _SelectableTemplateDayListState extends State<SelectableTemplateDayList> {
  int? _selectedIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return OverlayActionButton(
      label: "NEW WORKOUT",
      showActionButton: _selectedIndex != null,
      onPressed: () {
        Navigator.of(context).pop(_selectedIndex);
      },
      content: Scrollbar(
        controller: _scrollController,
        radius: const Radius.circular(ConfigProvider.defaultSpace / 2),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            // ExerciseSearchBar(
            //   onFilter: onFilter,
            // ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  var day = widget.template.days![index];
                  return TemplateDayListItem(
                    day: day,
                    name: widget.template.name,
                    emphasis: widget.template.emphasis,
                    sex: widget.template.sex,
                    numberOfDays: widget.template.days!.length,
                    selectedPosition: _selectedIndex,
                    onSelect: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  );
                },
                childCount: widget.template.days!.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
