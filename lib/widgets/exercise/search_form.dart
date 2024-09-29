import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/config_provider.dart';
import '../../models/muscle_group_dto.dart';

import '../../providers/exercise_provider.dart';

import '../general/text_style_templates.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String? currentSearch;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // _focusNode.requestFocus();
    _controller.addListener(_onKeyStroke);
  }

  _onKeyStroke() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      // do something with _controller.text
      if (currentSearch == _controller.text) return;
      print("from debouncer");
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
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textStyles = TextStyleTemplates();
    var items = MuscleGroupDto.getMuscleGroups();
    var exercisesProvider = Provider.of<ExerciseProvider>(context);
    var textValue = "${exercisesProvider.exercisesCount} results";
    if (exercisesProvider.filteredExercisesCount !=
        exercisesProvider.exercisesCount) {
      textValue =
          "${exercisesProvider.filteredExercisesCount} of ${exercisesProvider.exercisesCount} results";
    }
    return TextField(
      focusNode: _focusNode,
      controller: _controller,
      style: TextStyleTemplates.defaultTextStyle(
        ConfigProvider.mainTextColor,
      ),
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: TextStyleTemplates.defaultTextStyle(
          ConfigProvider.mainTextColor,
        ),
        fillColor: ConfigProvider.slightContrastBackgroundColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
