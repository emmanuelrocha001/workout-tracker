import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/providers/templates_provider.dart';

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

class TemplateList extends StatefulWidget {
  final bool isReplacing;
  const TemplateList({
    super.key,
    this.isReplacing = false,
  });

  @override
  State<TemplateList> createState() => _TemplateListState();
}

class _TemplateListState extends State<TemplateList> {
  String _selectedId = "";
  final ScrollController _scrollController = ScrollController();

  void _onSelect(String? id) {
    print(id);
    if (!id.isNullOrEmpty) {
      setState(() {
        _selectedId = id.toString();
      });
    }
  }

  void onFilter() {
    Helper.showPopUp(
      context: context,
      title: 'Filters',
      content: const ExerciseFiltersGrid(),
    );
  }

  void onAdd() {
    Navigator.of(context).pop(_selectedId);
  }

  @override
  Widget build(BuildContext context) {
    var templatesProvider = Provider.of<TemplatesProvider>(context);
    var templates = templatesProvider.templates;
    return Scrollbar(
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
                return TemplateListItem(
                  data: templates[index],
                  selectedId: _selectedId,
                  onSelect: _onSelect,
                );
              },
              childCount: templates.length,
            ),
          ),
        ],
      ),
    );
  }
}
