import 'dart:convert';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/tracked_exercise_dto.dart';

import '../models/exercise_dto.dart';

class ExerciseProvider with ChangeNotifier {
  final String _exercisesFilePath = 'assets/json_docs/_EXERCISES.json';
  List<ExerciseDto> _exercises = [];
  List<ExerciseDto> _filteredExercises = [];
  String? _appliedSearchFilter;
  String? _appliedMuscleGroupIdFilter;
  String? _appliedExerciseType;

  ExerciseProvider() {
    loadExcercises();
    // inject auth provider
  }

  Future<void> loadExcercises() async {
    // Load exercises from asset
    try {
      List<dynamic> tempExercises =
          json.decode((await rootBundle.loadString(_exercisesFilePath)));
      _exercises = tempExercises.map((x) {
        var temp = ExerciseDto.fromJson(x);
        temp.setSearchableString();
        return temp;
      }).toList();
      _filteredExercises = [..._exercises];
    } catch (e, s) {
      print(e);
      print(s);
    }

    notifyListeners();
  }

  List<ExerciseDto> get exercises {
    return [..._filteredExercises];
  }

  int get exercisesCount {
    return _exercises.length;
  }

  int get filteredExercisesCount {
    return _filteredExercises.length;
  }

  String get currentSearch {
    return _appliedSearchFilter ?? "";
  }

  String get appliedMuscleGroupIdFilter {
    return _appliedMuscleGroupIdFilter ?? "";
  }

  String get appliedExerciseType {
    return _appliedExerciseType ?? "";
  }

  List<ExerciseDto> _applySearchFilter(List<ExerciseDto> tList) {
    var searchString = _appliedSearchFilter!.toLowerCase();
    // print('search string $searchString');
    var searchableStringToExerciseMap = <String, ExerciseDto>{};
    var tSet = tList.where((x) {
      var matchByStringContains = x.searchableString.contains(searchString);
      if (!searchableStringToExerciseMap.containsKey(x.searchableString) &&
          !matchByStringContains &&
          searchString.length > 2) {
        searchableStringToExerciseMap[x.searchableString] = x;
      }
      return matchByStringContains;
    }).toList();

    // print('searchable map length ${searchableStringToExerciseMap.length}');
    var results = extractAllSorted(
      choices: searchableStringToExerciseMap.keys.toList(),
      query: searchString,
      cutoff: 65,
    );
    // print('search results length${results.length}');
    return [
      ...results.map((x) => searchableStringToExerciseMap[x.choice]!),
      ...tSet,
    ];
  }

  void _applyFilters() {
    // search can be optimized with some pre-processing of searchable content. looks like this is not something that is offered by fuzzywuzzy package. TODO - look for a better package or implement a custom solution if needed.
    try {
      var tList = _exercises
          .where(
            (x) =>
                (_appliedMuscleGroupIdFilter == null ||
                    _appliedMuscleGroupIdFilter!.isEmpty ||
                    x.muscleGroupId.toLowerCase() ==
                        _appliedMuscleGroupIdFilter!.toLowerCase()) &&
                (_appliedExerciseType == null ||
                    _appliedExerciseType!.isEmpty ||
                    x.exerciseType.toLowerCase().contains(
                          _appliedExerciseType!.toLowerCase(),
                        )),
          )
          .toList();
      if (_appliedSearchFilter == null) {
        _filteredExercises = tList;
      } else {
        _filteredExercises = _applySearchFilter(tList);
      }
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }

  void clearFilters() {
    _appliedMuscleGroupIdFilter = "";
    _appliedExerciseType = "";
    _applyFilters();
    notifyListeners();
  }

  void setAppliedSearchFilter(String value) {
    if (value == _appliedSearchFilter) return;

    if (value.isEmpty && _appliedSearchFilter != null) {
      _appliedSearchFilter = null;
    } else {
      _appliedSearchFilter = value;
    }
    _applyFilters();
    notifyListeners();
  }

  void setAppliedMuscleGroupIdFilter(String value) {
    _appliedMuscleGroupIdFilter = value;
    _applyFilters();
    notifyListeners();
  }

  void setAppliedExerciseType(String value) {
    _appliedExerciseType = value;
    _applyFilters();
    notifyListeners();
  }

  ExerciseDto? getExerciseById(String id) {
    return _exercises.firstWhere((x) => x.id == id);
  }
}
