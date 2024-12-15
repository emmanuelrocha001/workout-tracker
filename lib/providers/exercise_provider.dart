import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import './config_provider.dart';
import '../models/res_dto.dart';
import '../models/create_update_exercise_dto.dart';
import '../models/exercise_dto.dart';

class ExerciseProvider with ChangeNotifier {
  final String _exercisesFilePath = 'assets/json_docs/_EXERCISES.json';
  String get userDefinedExercisesKey =>
      '${ConfigProvider.cachePrefix}_user_created_exercises';
  SharedPreferencesWithCache? _cache;
  List<ExerciseDto> _systemDefinedExercises = [];
  List<ExerciseDto> _userDefinedExercises = [];
  List<ExerciseDto> _exercises = [];
  List<ExerciseDto> _filteredExercises = [];
  String? _appliedSearchFilter;
  String? _appliedMuscleGroupIdFilter;
  String? _appliedExerciseType;
  String? _appliedAuthor;

  ExerciseProvider() {
    print('ExerciseProvider constructor');
    setupCache().then((_) {
      loadExcercises();
    });
  }

  Future<void> loadExcercises() async {
    await loadSystemDefinedExercises();
    await loadUserDefinedExercisesFromCache();
  }

  Future<void> loadSystemDefinedExercises() async {
    // Load exercises from asset
    try {
      print("loading exercises from asset");
      var exercisesEncodedString =
          await rootBundle.loadString(_exercisesFilePath);

      List<dynamic> tempExercises = json.decode(exercisesEncodedString);
      _systemDefinedExercises = tempExercises.map((x) {
        var temp = ExerciseDto.fromJson(x);
        temp.setSearchableString();
        return temp;
      }).toList();
      _exercises = [..._systemDefinedExercises];
    } catch (e, s) {
      print(e);
      print(s);
    }
    notifyListeners();
  }

  Future<void> setupCache() async {
    _cache = await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(
            // This cache will only accept the key 'inProgressWorkout'.
            allowList: <String>{userDefinedExercisesKey}));
    // await clearCache();
  }

  Future<void> loadUserDefinedExercisesFromCache() async {
    // TODO fix this. currently not loading system defined exercises
    try {
      List<String>? cachedEncodedValueList =
          _cache?.getStringList(userDefinedExercisesKey);

      if (cachedEncodedValueList != null) {
        print(_exercises.length);
        _userDefinedExercises = (cachedEncodedValueList).map((exercise) {
          var tempUserDefinedExercise =
              ExerciseDto.fromJson(jsonDecode(exercise));
          tempUserDefinedExercise.setSearchableString();
          tempUserDefinedExercise.isCustom = true;
          return tempUserDefinedExercise;
        }).toList();
        print("exercise before adding user defined ${_exercises.length}");
        _exercises.addAll(_userDefinedExercises);
        _filteredExercises = [..._exercises];
        notifyListeners();
      } else {
        print('no user defined exercises found in cache');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _saveUserDefinedExercise({
    required ExerciseDto exercise,
    String? exerciseId,
  }) async {
    if (_cache == null) {
      return false;
    }
    try {
      if (exerciseId != null) {
        var index = _userDefinedExercises.indexWhere((x) => x.id == exerciseId);
        if (index != -1) {
          _userDefinedExercises[index] = exercise;
        } else {
          return false;
        }
      } else {
        _userDefinedExercises.insert(0, exercise);
      }
      await _cache!.setStringList(
        userDefinedExercisesKey,
        _userDefinedExercises.map((x) => jsonEncode(x)).toList(),
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _deleteUserDefinedExercise({
    required String exerciseId,
  }) async {
    if (_cache == null) {
      return false;
    }
    try {
      var index = _userDefinedExercises.indexWhere((x) => x.id == exerciseId);
      if (index != -1) {
        _userDefinedExercises.removeAt(index);
      } else {
        return false;
      }

      await _cache!.setStringList(
        userDefinedExercisesKey,
        _userDefinedExercises.map((x) => jsonEncode(x)).toList(),
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
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

  String get appliedAuthor {
    return _appliedAuthor ?? "";
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
                        )) &&
                (_appliedAuthor == null ||
                    _appliedAuthor!.isEmpty ||
                    (x.isCustom && _appliedAuthor!.toLowerCase() == "user") ||
                    (!x.isCustom && _appliedAuthor!.toLowerCase() == "system")),
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
    _appliedAuthor = "";
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

  void setAppliedAuthor(String value) {
    _appliedAuthor = value;
    _applyFilters();
    notifyListeners();
  }

  ExerciseDto? getExerciseById(String id) {
    return _exercises.firstWhere((x) => x.id == id);
  }

  Future<ResDto> createUserDefinedExercise(
      CreateUpdateExerciseDto input) async {
    var newExercise = ExerciseDto.newInstance(
      name: input.name,
      muscleGroupId: input.muscleGroupId,
      exerciseType: input.exerciseType,
      description: input.description,
      youtubeId: input.youtubeId,
    );

    var res = await _saveUserDefinedExercise(exercise: newExercise);
    if (res) {
      _exercises = [..._systemDefinedExercises, ..._userDefinedExercises];
      _appliedMuscleGroupIdFilter = "";
      _appliedExerciseType = "";
      setAppliedAuthor("User");
      _applyFilters();
      notifyListeners();
      return ResDto(
        success: true,
        message: "Exercise created successfully",
      );
    }

    return ResDto(
      success: false,
      message: "Failed to create exercise",
    );
  }

  Future<ResDto> updateUserDefinedExercise({
    required ExerciseDto exercise,
    required CreateUpdateExerciseDto input,
  }) async {
    exercise.name = input.name;
    exercise.muscleGroupId = input.muscleGroupId;
    exercise.description = input.description;
    exercise.youtubeId = input.youtubeId;
    exercise.updatedAt = DateTime.now();

    var res = await _saveUserDefinedExercise(
        exerciseId: exercise.id, exercise: exercise);
    if (res) {
      _exercises = [..._systemDefinedExercises, ..._userDefinedExercises];
      _filteredExercises = [..._exercises];
      notifyListeners();
      return ResDto(
        success: true,
        message: "Exercise updated successfully",
      );
    }

    return ResDto(
      success: false,
      message: "Failed to update exercise",
    );
  }

  Future<ResDto> deleteUserDefinedExercise({
    required exerciseId,
  }) async {
    print('deleting exercise $exerciseId');
    var res = await _deleteUserDefinedExercise(exerciseId: exerciseId);
    if (res) {
      _exercises = [..._systemDefinedExercises, ..._userDefinedExercises];
      _filteredExercises = [..._exercises];
      notifyListeners();
      return ResDto(
        success: true,
        message: "Exercise deleted successfully",
      );
    }

    return ResDto(
      success: false,
      message: "Failed to delete exercise",
    );
  }
}
