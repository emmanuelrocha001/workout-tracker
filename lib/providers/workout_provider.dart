import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './config_provider.dart';
import '../models/exercise_dto.dart';
import '../models/workout_dto.dart';
import '../models/tracked_exercise_dto.dart';
import '../models/adjust_workout_times_dto.dart';

class WorkoutProvider extends ChangeNotifier {
  static const String _inProgressWorkoutKey = 'inProgressWorkout';
  static const String _workoutHistoryKey = 'workoutHistory';
  String get exerciseSetsHistoryKey =>
      '${ConfigProvider.cachePrefix}_exercises_sets_history';

  WorkoutDto? _inProgressWorkout;
  List<WorkoutDto> _workoutHistory = [];
  Map<String, List<List<SetDtoSimplified>>> _exerciseSetsHistory = {};
  SharedPreferencesWithCache? _cache;
  bool _showLatestWorkoutHistoryEntryAsFinished = false;

  WorkoutProvider() {
    // loadExcercises();
    setupCache();
    // inject auth provider
  }

  void setupCache() async {
    _cache = await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(
            // This cache will only accept the key 'inProgressWorkout'.
            allowList: <String>{
          _inProgressWorkoutKey,
          _workoutHistoryKey,
          exerciseSetsHistoryKey
        }));
    // await clearCache();
    if (_cache != null) {
      loadInProgressWorkoutFromCache();

      _cache!.containsKey(exerciseSetsHistoryKey);

      var containsExerciseSetsHistoryKey =
          _cache!.containsKey(exerciseSetsHistoryKey);

      loadWorkoutHistoryFromCache(
          shouldBuildExerciseSetsHistoryFromWorkoutHistory:
              !containsExerciseSetsHistoryKey);

      if (containsExerciseSetsHistoryKey) {
        loadExerciseSetsHistory();
      }
    }
  }

  Future<void> clearCache() async {
    _cache?.clear();
  }

  void loadInProgressWorkoutFromCache() async {
    try {
      var cachedEncodedValue = _cache?.getString(_inProgressWorkoutKey);
      if (cachedEncodedValue != null) {
        _inProgressWorkout =
            WorkoutDto.fromJson(jsonDecode(cachedEncodedValue));
        if (_inProgressWorkout!.endTime == null) {
          _inProgressWorkout!.autoTimingSelected = true;
        }
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  void loadWorkoutHistoryFromCache({
    bool shouldBuildExerciseSetsHistoryFromWorkoutHistory = false,
  }) async {
    try {
      print(
          'attempting to build sets history from workout history $shouldBuildExerciseSetsHistoryFromWorkoutHistory');
      List<String>? cachedEncodedValueList =
          _cache?.getStringList(_workoutHistoryKey);

      // print('\ncached workout history:\n\n $cachedEncodedValueList\n\n');

      if (cachedEncodedValueList != null) {
        _workoutHistory = (cachedEncodedValueList).map((workout) {
          var tempWorkout = WorkoutDto.fromJson(jsonDecode(workout));
          // populate for legacy data
          tempWorkout.createTime ??= tempWorkout.startTime;
          tempWorkout.lastUpdated ??= tempWorkout.endTime;
          return tempWorkout;
        }).toList();

        if (shouldBuildExerciseSetsHistoryFromWorkoutHistory &&
            _workoutHistory.isNotEmpty) {
          print('\n attempting to build sets history from workout history');
          for (var workout in _workoutHistory) {
            _updateExerciseSetsHistory(workout);
          }
          saveExerciseSetsHistory();
        }
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  void loadExerciseSetsHistory() async {
    try {
      String? cachedEncodedValue = _cache?.getString(exerciseSetsHistoryKey);

      print('\ncached workout history:\n\n $exerciseSetsHistoryKey\n\n');

      if (cachedEncodedValue != null) {
        (jsonDecode(cachedEncodedValue) as Map<String, dynamic>)
            .forEach((key, value) {
          _exerciseSetsHistory[key] = List<List<SetDtoSimplified>>.from(
            (value as List).map(
              (x) =>
                  (x as List).map((y) => SetDtoSimplified.fromJson(y)).toList(),
            ),
          );
        });
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  void _updateExerciseSetsHistory(WorkoutDto workout) {
    for (var trackedExercise in workout.exercises) {
      var simplifiedSets = trackedExercise.sets
          .map((x) => SetDtoSimplified.fromSetDto(x))
          .toList();
      if (_exerciseSetsHistory.containsKey(trackedExercise.exercise.id)) {
        _exerciseSetsHistory[trackedExercise.exercise.id]!.add(simplifiedSets);
      } else {
        _exerciseSetsHistory[trackedExercise.exercise.id] = [simplifiedSets];
      }
    }
  }

  List<ISetDto>? getExerciseSetsHistoryLatestEntry(String exerciseId) {
    print(exerciseId);
    if (_exerciseSetsHistory.containsKey(exerciseId)) {
      return _exerciseSetsHistory[exerciseId]![
          _exerciseSetsHistory[exerciseId]!.length - 1];
    }
    return null;
  }

  void saveExerciseSetsHistory() async {
    try {
      await _cache?.setString(
          exerciseSetsHistoryKey, jsonEncode(_exerciseSetsHistory));
    } catch (e) {
      print(e);
    }
  }

  bool get showLatestWorkoutHistoryEntryAsFinished {
    return _showLatestWorkoutHistoryEntryAsFinished;
  }

  void resetShowLatestWorkoutHistoryEntryAsFinished() {
    _showLatestWorkoutHistoryEntryAsFinished = false;
  }

  List<WorkoutDto> get workoutHistory {
    return [..._workoutHistory];
  }

  WorkoutDto? get latestWorkoutHistoryEntry {
    if (_workoutHistory.isEmpty) {
      return null;
    }
    return _workoutHistory[_workoutHistory.length - 1];
  }

  void _saveInProgressWorkout() async {
    if (_inProgressWorkout == null) {
      return;
    }

    var encodedValue = jsonEncode(_inProgressWorkout);
    await _cache!.setString(_inProgressWorkoutKey, encodedValue);
  }

  void startWorkout({
    bool showRestTimerAfterEachSet = false,
    bool autoPopulateWorkoutFromSetsHistory = false,
  }) {
    _inProgressWorkout = WorkoutDto.newInstance();
    _inProgressWorkout!.showRestTimerAfterEachSet = showRestTimerAfterEachSet;

    // this would only apply if new workout is some sort of template
    // if (autoPopulateWorkoutFromSetsHistory) {
    //   for (var trackedExercise in _inProgressWorkout!.exercises) {
    //     var latestSets =
    //         getExerciseSetsHistoryLatestEntry(trackedExercise.exercise.id);
    //     if (latestSets != null) {
    //       trackedExercise.sets = latestSets
    //           .map((x) => SetDto(reps: x.reps, weight: x.weight))
    //           .toList();
    //     }
    //   }
    // }

    notifyListeners();
    _saveInProgressWorkout();
  }

  void startWorkoutFromHistory({
    required WorkoutDto workout,
    required bool shouldStartAsNew,
    bool showRestTimerAfterEachSet = false,
  }) {
    _inProgressWorkout = WorkoutDto.fromWorkoutDto(
      workout: workout,
      shouldCreateAsNew: shouldStartAsNew,
    );
    if (shouldStartAsNew) {
      _inProgressWorkout!.showRestTimerAfterEachSet = showRestTimerAfterEachSet;
    }
    notifyListeners();
    _saveInProgressWorkout();
  }

  void cancelInProgressWorkout() {
    _inProgressWorkout = null;
    notifyListeners();
    _cache!.remove(_inProgressWorkoutKey);
  }

  bool updateInProgresssWorkoutTimes(AdjustWorkoutTimesDto update) {
    if (_inProgressWorkout == null) {
      return false;
    }
    print("updating workout times");
    _inProgressWorkout!.startTime = update.startTime;
    _inProgressWorkout!.endTime = update.endTime;
    _inProgressWorkout!.autoTimingSelected = update.autoTimingSelected;
    _inProgressWorkout!.showRestTimerAfterEachSet =
        update.showRestTimerAfterEachSet;
    _inProgressWorkout!.title = update.workoutNickName;
    _inProgressWorkout!.setAreTrackedExercisesLogged();
    _saveInProgressWorkout();
    notifyListeners();
    return true;
  }

  void finishInProgressWorkout() {
    if (_inProgressWorkout == null) {
      return;
    }
    _inProgressWorkout!.endTime = DateTime.now();
    _inProgressWorkout!.lastUpdated = _inProgressWorkout!.endTime;

    _showLatestWorkoutHistoryEntryAsFinished = true;

    // save to history
    _workoutHistory.add(_inProgressWorkout!);
    // update exercoise sets history
    _updateExerciseSetsHistory(_inProgressWorkout!);
    saveExerciseSetsHistory();
    _inProgressWorkout = null;

    notifyListeners();

    // TODO might need to await in scenario where uses refreshes the page.
    _cache!.remove(_inProgressWorkoutKey);
    _cache!.setStringList(_workoutHistoryKey,
        _workoutHistory.map((workout) => jsonEncode(workout)).toList());
    _cache!.setString(exerciseSetsHistoryKey, jsonEncode(_exerciseSetsHistory));
  }

  void finishUpdatingWorkoutHistoryEntry() {
    if (_inProgressWorkout == null) {
      return;
    }

    var index =
        _workoutHistory.indexWhere((x) => x.id == _inProgressWorkout!.id);
    if (index == -1) {
      return;
    }

    _workoutHistory[index] = _inProgressWorkout!;
    _inProgressWorkout = null;

    notifyListeners();

    // TODO might need to await in scenario where uses refreshes the page.
    _cache!.remove(_inProgressWorkoutKey);
    _cache!.setStringList(_workoutHistoryKey,
        _workoutHistory.map((workout) => jsonEncode(workout)).toList());
  }

  void deleteWorkoutHistoryEntry(String workoutId) {
    var index = _workoutHistory.indexWhere((x) => x.id == workoutId);
    if (index == -1) {
      return;
    }

    _workoutHistory.removeAt(index);
    notifyListeners();

    // TODO might need to await in scenario where uses refreshes the page.
    _cache!.setStringList(_workoutHistoryKey,
        _workoutHistory.map((workout) => jsonEncode(workout)).toList());
  }

  bool isWorkoutInProgress() {
    return _inProgressWorkout != null;
  }

  bool get showRestTimerAfterEachSet {
    return _inProgressWorkout?.showRestTimerAfterEachSet ?? false;
  }

  String get inProgressWorkoutNickName {
    return _inProgressWorkout?.title ?? '';
  }

  bool isInProgressWorkoutReadyTofinish() {
    var t = _inProgressWorkout != null &&
        _inProgressWorkout!.areTrackedExercisesLogged;
    return t;
  }

  DateTime? get inProgressWorkoutStartTime {
    return _inProgressWorkout!.startTime;
  }

  DateTime? get inProgressWorkoutEndTime {
    return _inProgressWorkout?.endTime;
  }

  bool get inProgressWorkoutAutoTimingSelected {
    return _inProgressWorkout?.autoTimingSelected ?? false;
  }

  bool setInProgressWorkoutStartTime(DateTime startTime) {
    _inProgressWorkout!.startTime = startTime;
    _saveInProgressWorkout();
    notifyListeners();
    return true;
  }

  DateTime? get inProgressWorkoutLastUpdated {
    return _inProgressWorkout!.lastUpdated;
  }

  bool get updatingLoggedWorkout {
    return _inProgressWorkout?.lastUpdated != null;
  }

  List<TrackedExerciseDto> get trackedExercises {
    if (_inProgressWorkout == null) {
      return [];
    }
    return [..._inProgressWorkout!.exercises];
  }

  void addTrackedExercise({
    required ExerciseDto exercise,
    bool autoPopulateWorkoutFromSetsHistory = false,
  }) {
    if (_inProgressWorkout == null) {
      return;
    }
    print("from add exercise ${exercise.id}");

    var trackedExercise = TrackedExerciseDto.newInstance(
      exercise: exercise,
    );

    if (autoPopulateWorkoutFromSetsHistory) {
      print("attempting to auto populate tracked exercise");
      var latestSets = getExerciseSetsHistoryLatestEntry(exercise.id);
      if (latestSets != null) {
        trackedExercise.sets = latestSets
            .map((x) => SetDto(reps: x.reps, weight: x.weight))
            .toList();
      }
    }

    _inProgressWorkout!.exercises.add(trackedExercise);
    print("from add exercise ${trackedExercise.id}");

    _inProgressWorkout!.setAreTrackedExercisesLogged();
    _saveInProgressWorkout();
    notifyListeners();
  }

  void deleteTrackedExercise(String trackedExerciseId) {
    if (_inProgressWorkout == null) {
      return;
    }
    print("from delete exercise ${trackedExerciseId}");
    _inProgressWorkout!.exercises.removeWhere((x) => x.id == trackedExerciseId);

    _inProgressWorkout!.setAreTrackedExercisesLogged();
    _saveInProgressWorkout();
    notifyListeners();
  }

  void reorderTrackedExercises(int oldIndex, int newIndex) {
    if (_inProgressWorkout == null) {
      return;
    }

    if (oldIndex == newIndex) {
      return;
    }

    if (newIndex >= _inProgressWorkout!.exercises.length) {
      newIndex = _inProgressWorkout!.exercises.length - 1;
    } else if (newIndex < 0) {
      newIndex = 0;
    }

    var temp = _inProgressWorkout!.exercises[oldIndex];
    _inProgressWorkout!.exercises.removeAt(oldIndex);
    _inProgressWorkout!.exercises.insert(newIndex, temp);

    _saveInProgressWorkout();
    notifyListeners();
  }

  bool addSetToTrackedExercise(String trackedExerciseId, SetDto set) {
    if (_inProgressWorkout == null) {
      return false;
    }

    var trackedExercise = _inProgressWorkout!.exercises
        .where((x) => x.id == trackedExerciseId)
        .firstOrNull;

    if (trackedExercise == null) {
      return false;
    }
    trackedExercise.sets.add(set);

    _inProgressWorkout!.setAreTrackedExercisesLogged(shouldForceValue: true);
    notifyListeners();
    return true;
  }

  bool deleteSetFromTrackedExercise(String trackedExerciseId, int index) {
    if (_inProgressWorkout == null) {
      return false;
    }

    var trackedExercise = _inProgressWorkout?.exercises
        .where((x) => x.id == trackedExerciseId)
        .firstOrNull;

    if (trackedExercise == null) {
      return false;
    }

    var oldAreSetsLogged = trackedExercise.areSetsLogged();

    trackedExercise.sets.removeAt(index);

    _saveInProgressWorkout();
    if (oldAreSetsLogged != trackedExercise.areSetsLogged()) {
      _inProgressWorkout!.setAreTrackedExercisesLogged();
      notifyListeners();
    }
    return true;
  }

  bool updateSetInTrackedExercise(
      String trackedExerciseId, int index, SetDto set) {
    if (_inProgressWorkout == null) {
      return false;
    }

    var trackedExercise = _inProgressWorkout!.exercises
        .where((x) => x.id == trackedExerciseId)
        .firstOrNull;

    if (trackedExercise == null) {
      return false;
    }

    var oldAreSetsLogged = trackedExercise.areSetsLogged();

    trackedExercise.sets[index] = set;

    _saveInProgressWorkout();

    if (oldAreSetsLogged != trackedExercise.areSetsLogged()) {
      _inProgressWorkout!.setAreTrackedExercisesLogged();
      notifyListeners();
    }

    return true;
  }
}
