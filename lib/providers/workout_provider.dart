import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_tracker/models/exercise_dto.dart';
import '../models/workout_dto.dart';
import '../models/tracked_exercise_dto.dart';

class WorkoutProvider extends ChangeNotifier {
  static const String _inProgressWorkoutKey = 'inProgressWorkout';
  static const String _workoutHistoryKey = 'workoutHistory';

  WorkoutDto? _inProgressWorkout;
  List<WorkoutDto> _workoutHistory = [];
  SharedPreferencesWithCache? _cache;
  bool _showLatestWorkoutHistoryEntryAsFinished = false;

  WorkoutProvider() {
    // loadExcercises();
    setupCache();
    // inject auth provider
  }

  void setupCache() async {
    _cache = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(
            // This cache will only accept the key 'inProgressWorkout'.
            allowList: <String>{_inProgressWorkoutKey, _workoutHistoryKey}));
    // await clearCache();
    if (_cache != null) {
      loadInProgressWorkoutFromCache();
      loadWorkoutHistoryFromCache();
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
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  void loadWorkoutHistoryFromCache() async {
    try {
      List<String>? cachedEncodedValueList =
          _cache?.getStringList(_workoutHistoryKey);

      print('\ncached workout history:\n\n $cachedEncodedValueList\n\n');

      if (cachedEncodedValueList != null) {
        _workoutHistory = (cachedEncodedValueList)
            .map((workout) => WorkoutDto.fromJson(jsonDecode(workout)))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  bool get showLatestWorkoutHistoryEntryAsFinished {
    return _showLatestWorkoutHistoryEntryAsFinished;
  }

  void latestWorkoutHistoryEntryShownAsFinished() {
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

  void startWorkout() {
    _inProgressWorkout = WorkoutDto.newInstance();
    notifyListeners();
  }

  void cancelInProgressWorkout() {
    _inProgressWorkout = null;
    notifyListeners();
    _cache!.remove(_inProgressWorkoutKey);
  }

  void finishInProgressWorkout() {
    if (_inProgressWorkout == null) {
      return null;
    }
    _inProgressWorkout!.endTime = DateTime.now();

    _showLatestWorkoutHistoryEntryAsFinished = true;

    // save to history
    _workoutHistory.add(_inProgressWorkout!);
    _inProgressWorkout = null;

    notifyListeners();

    // TODO might need to await in scenario where uses refreshes the page.
    _cache!.remove(_inProgressWorkoutKey);
    _cache!.setStringList(_workoutHistoryKey,
        _workoutHistory.map((workout) => jsonEncode(workout)).toList());
  }

  bool isWorkoutInProgress() {
    return _inProgressWorkout != null;
  }

  bool isInProgressWorkoutReadyTofinish() {
    var t = _inProgressWorkout != null &&
        _inProgressWorkout!.areTrackedExercisesLogged;
    return t;
  }

  DateTime? get inProgressWorkoutStartTime {
    return _inProgressWorkout!.startTime;
  }

  List<TrackedExerciseDto> get trackedExercises {
    if (_inProgressWorkout == null) {
      return [];
    }
    return [..._inProgressWorkout!.exercises];
  }

  void addTrackedExercise(ExerciseDto exercise) {
    if (_inProgressWorkout == null) {
      return;
    }
    print("from add exercise ${exercise.id}");

    var trackedExercise = TrackedExerciseDto.newInstance(
      exercise: exercise,
    );

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
