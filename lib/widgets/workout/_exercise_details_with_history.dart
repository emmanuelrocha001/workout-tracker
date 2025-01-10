import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/exercise_dto.dart';
import '../../models/tracked_exercise_history_entry_dto.dart';
import '../../providers/config_provider.dart';
import '../exercise/_exercise_details.dart';
import 'tracked_exercise_history.dart';

import '../general/text_style_templates.dart';

class ExerciseDetailsWithHistory extends StatefulWidget {
  final ExerciseDto exercise;
  final List<TrackedExerciseHistoryEntryDto>? exerciseHistory;
  const ExerciseDetailsWithHistory({
    super.key,
    required this.exercise,
    required this.exerciseHistory,
  });

  @override
  State<ExerciseDetailsWithHistory> createState() =>
      _ExerciseDetailsWithHistoryState();
}

class _ExerciseDetailsWithHistoryState extends State<ExerciseDetailsWithHistory>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
          child: SizedBox(
            height: 35.0,
            child: TabBar.secondary(
              tabAlignment: TabAlignment.fill,
              dividerHeight: 1.0,
              indicatorWeight: 2.0,
              controller: _tabController,
              indicator: BoxDecoration(
                color: ConfigProvider.mainColor,
                shape: BoxShape.rectangle,
                borderRadius:
                    BorderRadius.circular(ConfigProvider.defaultSpace / 2),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: EdgeInsets.zero,
              indicatorColor: ConfigProvider.mainColor,
              dividerColor: ConfigProvider.backgroundColor,
              unselectedLabelStyle: TextStyleTemplates.defaultTextStyle(
                  ConfigProvider.mainTextColor),
              labelStyle: TextStyleTemplates.defaultTextStyle(
                ConfigProvider.backgroundColorSolid,
              ),
              tabs: const <Widget>[
                Center(
                  child: Tab(
                    text: 'Details',
                  ),
                ),
                Tab(text: 'History'),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              ExerciseDetails(
                exercise: widget.exercise,
              ),
              TrackedExerciseHistory(
                exercise: widget.exercise,
                entries: widget.exerciseHistory,
                isMetricSystemSelected: configProvider.isMetricSystemSelected,
                scrollController: _scrollController,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
