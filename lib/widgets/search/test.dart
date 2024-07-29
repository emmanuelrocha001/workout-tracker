import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/class_extensions.dart';
import 'package:workout_tracker/models/muscle_group_dto.dart';
import 'package:workout_tracker/widgets/general/pill_container.dart';
import './active_search_filter.dart';

import '../../providers/exercise_provider.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _controller = TextEditingController();
  String? currentSearch;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onKeyStroke);
  }

  _onKeyStroke() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      // do something with _controller.text
      if (currentSearch == _controller.text) return;
      Provider.of<ExerciseProvider>(context, listen: false)
          .setAppliedSearchFilter(_controller.text);
      print(_controller.text);
      setState(() {
        currentSearch = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onKeyStroke);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var items = MuscleGroupDto.getMuscleGroups();
    return Consumer<ExerciseProvider>(
      builder: (context, exercisesProvider, child) {
        var textValue = "${exercisesProvider.exercisesCount} results";
        if (exercisesProvider.filteredExercisesCount !=
            exercisesProvider.exercisesCount) {
          textValue =
              "${exercisesProvider.filteredExercisesCount} of ${exercisesProvider.exercisesCount} results";
        }
        return SizedBox(
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search',
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              ListTile(
                isThreeLine: true,
                dense: true,
                leading: const Text(
                  'FILTERED BY',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12.0,
                      color: Colors.black),
                ),
                title: ActiveFilter(
                  label: 'muscle_group a reallly long lablesd'.toUpperCase(),
                  value: items[0].name.toUpperCase(),
                ),
                subtitle: ActiveFilter(
                  label: 'exercise_type'.toUpperCase(),
                  value: items[0].name.toUpperCase(),
                ),
                trailing: Text(
                  textValue,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
