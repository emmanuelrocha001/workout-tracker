import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:workout_tracker/models/muscle_group_dto.dart';

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
      _exercises = tempExercises.map((x) => ExerciseDto.fromJson(x)).toList();
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

  void _applyFilters() {
    try {
      _filteredExercises = _exercises
          .where(
            (x) =>
                (_appliedSearchFilter == null ||
                    x.name.toLowerCase().contains(
                          _appliedSearchFilter!.toLowerCase(),
                        )) &&
                (_appliedMuscleGroupIdFilter == null ||
                    x.muscleGroupId.toLowerCase().contains(
                          _appliedMuscleGroupIdFilter!.toLowerCase(),
                        )) &&
                (_appliedExerciseType == null ||
                    x.exerciseType.toLowerCase().contains(
                          _appliedExerciseType!.toLowerCase(),
                        )),
          )
          .toList();
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
    print("applied filter");
    print(value);
    if (value == null) {
      print("is null");
    }
    _appliedSearchFilter = value;
    _applyFilters();
    notifyListeners();
    // if (search != null && search.isNotEmpty) {
    //   _appliedSearchFilter = search;
    //   _filteredExercises = _exercises
    //       .where((x) => x.name.toLowerCase().contains(search.toLowerCase()))
    //       .toList();
    //   notifyListeners();
    // } else {
    //   _filteredExercises = [..._exercises];
    //   notifyListeners();
    // }
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
}