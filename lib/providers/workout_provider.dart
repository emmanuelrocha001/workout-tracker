import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_tracker/models/res_dto.dart';
import './config_provider.dart';
import '../models/exercise_dto.dart';
import '../models/workout_dto.dart';
import '../models/tracked_exercise_dto.dart';
import '../models/tracked_exercise_history_entry_dto.dart';
import '../models/adjust_workout_times_dto.dart';

class WorkoutProvider extends ChangeNotifier {
  static const String _inProgressWorkoutKey = 'inProgressWorkout';
  static const String _workoutHistoryKey = 'workoutHistory';
  String get _deprecatedExerciseSetsHistoryKey =>
      '${ConfigProvider.cachePrefix}_exercises_sets_history';
  String get _exerciseHistoryKey =>
      '${ConfigProvider.cachePrefix}_exercise_history';

  WorkoutDto? _inProgressWorkout;
  List<WorkoutDto> _workoutHistory = [];
  final Map<String, Map<String, TrackedExerciseHistoryEntryDto>>
      _exerciseHistory = {};
  SharedPreferencesWithCache? _cache;
  WorkoutDto? _workoutToShowAsFinished;
  final Map<String, ExerciseDto> _exerciseMap = {};
  bool _isInitializedWithExerciseProvider = false;

  bool get isInitializedWithExerciseProvider =>
      _isInitializedWithExerciseProvider;

  WorkoutProvider({List<ExerciseDto>? exercises}) {
    if (exercises == null || exercises.isEmpty) {
      print('No exercises provided, skipping workout provider initialization');
      return;
    }

    // loadExcercises();
    if (!_isInitializedWithExerciseProvider) {
      print('Initializing workout provider with exercises ${exercises.length}');

      setupCache(exercises);
    }
    // inject auth provider
  }

  void setupCache(List<ExerciseDto> exercises) async {
    _cache = await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(
            // This cache will only accept the key 'inProgressWorkout'.
            allowList: <String>{
          _inProgressWorkoutKey,
          _workoutHistoryKey,
          _deprecatedExerciseSetsHistoryKey,
          _exerciseHistoryKey,
        }));
    // await clearCache();
    if (_cache != null) {
      // clean up deprecated keys
      await _cache?.remove(_deprecatedExerciseSetsHistoryKey);

      // set up _exercise map
      for (var exercise in exercises) {
        _exerciseMap[exercise.id] = exercise;
      }

      await loadInProgressWorkoutFromCache();

      var containsExerciseHistory = _cache!.containsKey(_exerciseHistoryKey);

      await loadWorkoutHistoryFromCache(
          shouldBuildExerciseHistoryFromWorkoutHistory:
              !containsExerciseHistory);

      if (containsExerciseHistory) {
        await loadExerciseHistory();
      }
      _isInitializedWithExerciseProvider = true;
    }
  }

  Future<void> clearCache() async {
    _cache?.clear();
  }

  Future<void> loadInProgressWorkoutFromCache() async {
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

  Future<void> loadWorkoutHistoryFromCache({
    bool shouldBuildExerciseHistoryFromWorkoutHistory = false,
  }) async {
    try {
      print(
          'attempting to build sets history from workout history $shouldBuildExerciseHistoryFromWorkoutHistory');
      List<String>? cachedEncodedValueList =
          _cache?.getStringList(_workoutHistoryKey);

      // print('\ncached workout history:\n\n $cachedEncodedValueList\n\n');

      if (cachedEncodedValueList != null) {
        _workoutHistory = (cachedEncodedValueList).map((workout) {
          var tempWorkout = WorkoutDto.fromJson(jsonDecode(workout));
          // populate for legacy data
          tempWorkout.createTime ??= tempWorkout.startTime;
          tempWorkout.lastUpdated ??= tempWorkout.endTime;
          // try to use up to date exercise data
          for (var i = 0; i < tempWorkout.exercises.length; i++) {
            if (_exerciseMap
                .containsKey(tempWorkout.exercises[i].exercise.id)) {
              tempWorkout.exercises[i].exercise =
                  _exerciseMap[tempWorkout.exercises[i].exercise.id]!;
            }
          }
          return tempWorkout;
        }).toList();
        _saveWorkoutHistory();

        if (shouldBuildExerciseHistoryFromWorkoutHistory &&
            _workoutHistory.isNotEmpty) {
          print('\n attempting to build sets history from workout history');
          for (var workout in _workoutHistory) {
            _updateExerciseHistory(workout: workout);
          }
          _saveExerciseHistory();
        }
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadExerciseHistory() async {
    try {
      String? cachedEncodedValue = _cache?.getString(_exerciseHistoryKey);

      if (cachedEncodedValue != null) {
        (jsonDecode(cachedEncodedValue) as Map<String, dynamic>)
            .forEach((key, value) {
          _exerciseHistory[key] =
              Map<String, TrackedExerciseHistoryEntryDto>.from(
            (value as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                TrackedExerciseHistoryEntryDto.fromJson(value),
              ),
            ),
          );
        });
        notifyListeners();
      }
    } catch (e) {
      print('something went wrong');
      print(e);
    }
  }

  void _updateExerciseHistory({
    required WorkoutDto workout,
    WorkoutDto? oldWorkout,
    bool isWorkoutEntryBeingDeleted = false,
  }) {
    // delete removed entries
    var toBeRemoved = <String>{};
    if (isWorkoutEntryBeingDeleted) {
      toBeRemoved = workout.exercises.map((x) => x.exercise.id).toSet();
    } else if (oldWorkout != null && workout.id == oldWorkout.id) {
      toBeRemoved = oldWorkout.exercises
          .map((x) => x.exercise.id)
          .toSet()
          .difference(workout.exercises.map((x) => x.exercise.id).toSet());
    }

    print('toBeRemoved $toBeRemoved');
    for (var exerciseId in toBeRemoved) {
      if (_exerciseHistory.containsKey(exerciseId) &&
          _exerciseHistory[exerciseId]!.containsKey(workout.id)) {
        // remove entry
        print(
            'removing entry with exerciseId $exerciseId and workoutId ${workout.id}');
        _exerciseHistory[exerciseId]!.remove(workout.id);
      } else {
        print(
            'entry not found with exerciseId $exerciseId and workoutId ${workout.id}');
      }
    }
    if (isWorkoutEntryBeingDeleted) {
      return;
    }

    // update existing entries
    for (var trackedExercise in workout.exercises) {
      var simplifiedSets = trackedExercise.sets
          .map((x) => SetDtoSimplified.fromSetDto(x))
          .toList();

      var entry = TrackedExerciseHistoryEntryDto.newInstance(
        exerciseId: trackedExercise.exercise.id,
        workoutId: workout.id,
        workoutStartDate: workout.startTime!,
        sets: simplifiedSets,
      );

      if (_exerciseHistory.containsKey(trackedExercise.exercise.id)) {
        _exerciseHistory[trackedExercise.exercise.id]![workout.id] = entry;
        // sort entries
        var entriesAsList =
            _exerciseHistory[trackedExercise.exercise.id]!.entries.toList();

        print(
            're-sorting exercise history entries for exercise ${trackedExercise.exercise.id}');
        entriesAsList.sort((a, b) =>
            a.value.workoutStartDate.isBefore(b.value.workoutStartDate)
                ? -1
                : 1);

        _exerciseHistory[trackedExercise.exercise.id] = {
          for (var entry in entriesAsList) entry.key: entry.value
        };
      } else {
        _exerciseHistory[trackedExercise.exercise.id] = {
          workout.id: entry,
        };
      }
    }
  }

  List<ISetDto>? getExerciseSetsHistoryLatestEntry(String exerciseId) {
    print(exerciseId);
    if (_exerciseHistory.containsKey(exerciseId)) {
      // In dart, for a LinkedHashMap, the underlying structure that maintains the order of insertion is a doubly linked list. This means that we can access the first and last elements in O(1) time.
      return _exerciseHistory[exerciseId]!.values.last.sets;
    }
    return null;
  }

  List<TrackedExerciseHistoryEntryDto>? getExerciseHistory(String exerciseId) {
    if (_exerciseHistory.containsKey(exerciseId)) {
      return _exerciseHistory[exerciseId]!.values.toList();
    }
    return null;
  }

  void _saveExerciseHistory() async {
    // filter out expired entries
    var now = DateTime.now();
    _exerciseHistory.forEach((key, value) {
      _exerciseHistory[key] = {
        for (var entry in value.entries.where(
          (entry) => entry.value.expiryDate.isAfter(now),
        ))
          entry.key: entry.value
      };
    });
    try {
      await _cache?.setString(
          _exerciseHistoryKey, jsonEncode(_exerciseHistory));
    } catch (e) {
      print(e);
    }
  }

  void _saveWorkoutHistory() async {
    _cache!.setStringList(_workoutHistoryKey,
        _workoutHistory.map((workout) => jsonEncode(workout)).toList());
  }

  WorkoutDto? get workoutToShowAsFinished {
    return _workoutToShowAsFinished;
  }

  void resetWorkoutToShowAsFinished() {
    _workoutToShowAsFinished = null;
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

  void _sortWorkoutHistory() {
    _workoutHistory
        .sort((a, b) => a.startTime!.isBefore(b.startTime!) ? -1 : 1);
  }

  void finishInProgressWorkout() {
    if (_inProgressWorkout == null) {
      return;
    }
    var now = DateTime.now();
    if (_inProgressWorkout!.endTime == null &&
        _inProgressWorkout!.startTime != null) {
      _inProgressWorkout!.endTime =
          now.difference(_inProgressWorkout!.startTime!).inSeconds <=
                  ConfigProvider.maxWorkoutDurationInSeconds
              ? now
              : _inProgressWorkout!.startTime!.add(
                  Duration(seconds: ConfigProvider.maxWorkoutDurationInSeconds),
                );
    }

    _inProgressWorkout!.lastUpdated = DateTime.now();

    _workoutToShowAsFinished = _inProgressWorkout;

    // save to history
    _workoutHistory.add(_inProgressWorkout!);
    _sortWorkoutHistory();
    // update exercise sets history
    _updateExerciseHistory(workout: _inProgressWorkout!);
    _saveExerciseHistory();
    _inProgressWorkout = null;

    notifyListeners();

    // TODO might need to await in scenario where uses refreshes the page.
    _cache!.remove(_inProgressWorkoutKey);
    _saveWorkoutHistory();
  }

  Future<ResDto> finishUpdatingWorkoutHistoryEntry() async {
    if (_inProgressWorkout == null) {
      return ResDto(success: false, message: 'No workout in progress');
    }

    var index =
        _workoutHistory.indexWhere((x) => x.id == _inProgressWorkout!.id);
    if (index == -1) {
      return ResDto(success: false, message: 'Workout not found in history');
    }
    try {
      var previousEntry = _workoutHistory[index];

      var workoutArtifactsNeedResorting =
          previousEntry.startTime!.toIso8601String() !=
              _inProgressWorkout!.startTime!.toIso8601String();

      _workoutHistory[index] = _inProgressWorkout!;
      if (workoutArtifactsNeedResorting) {
        _sortWorkoutHistory();
      }

      // update exercise sets history
      _updateExerciseHistory(
        workout: _inProgressWorkout!,
        oldWorkout: previousEntry,
      );
      _saveExerciseHistory();
      _inProgressWorkout = null;

      notifyListeners();

      // TODO might need to await in scenario where uses refreshes the page.
      _cache!.remove(_inProgressWorkoutKey);
      _saveWorkoutHistory();
      return ResDto(success: true, message: 'Workout updated successfully');
    } catch (exception) {
      return ResDto(
          success: false, message: ConfigProvider.defaultErrorMessage);
    }
  }

  void deleteWorkoutHistoryEntry(String workoutId) {
    var index = _workoutHistory.indexWhere((x) => x.id == workoutId);
    if (index == -1) {
      return;
    }
    var workoutToBeRemoved = _workoutHistory[index];
    _updateExerciseHistory(
      workout: workoutToBeRemoved,
      isWorkoutEntryBeingDeleted: true,
    );
    _saveExerciseHistory();
    _workoutHistory.removeAt(index);

    notifyListeners();

    // TODO might need to await in scenario where uses refreshes the page.
    _saveWorkoutHistory();
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
    TrackedExerciseDto trackedExercise;
    var trackedExerciseIndex = _inProgressWorkout!.exercises
        .indexWhere((x) => x.exercise.id == exercise.id);

    if (trackedExerciseIndex != -1) {
      // add new set if exerise is already being tracked.
      trackedExercise = _inProgressWorkout!.exercises[trackedExerciseIndex];
      trackedExercise.sets.add(SetDto());
    } else {
      trackedExercise = TrackedExerciseDto.newInstance(
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
      print("from add exercise ${trackedExercise.id}");
      _inProgressWorkout!.exercises.add(trackedExercise);
    }

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

    trackedExercise.sets.removeAt(index);

    _saveInProgressWorkout();
    // if (oldAreSetsLogged != trackedExercise.areSetsLogged()) {
    //   _inProgressWorkout!.setAreTrackedExercisesLogged();
    //   notifyListeners();
    // }
    _inProgressWorkout!.setAreTrackedExercisesLogged();
    notifyListeners();

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
