import 'package:flutter/foundation.dart';
import 'package:workout_tracker/models/exercise_dto.dart';
import '../models/workout_dto.dart';
import '../models/tracked_exercise_dto.dart';

class WorkoutProvider extends ChangeNotifier {
  WorkoutDto? _inProgressWorkout;

  void startWorkout() {
    _inProgressWorkout = WorkoutDto.newInstance();
    notifyListeners();
  }

  void endWorkout() {
    _inProgressWorkout!.endTime = DateTime.now();
    // TODO - save workout record.
    notifyListeners();
  }

  bool isWorkoutInProgress() {
    return _inProgressWorkout != null;
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
    notifyListeners();
  }

  void deleteTrackedExercise(String trackedExerciseId) {
    if (_inProgressWorkout == null) {
      return;
    }
    print("from delete exercise ${trackedExerciseId}");
    _inProgressWorkout!.exercises.removeWhere((x) => x.id == trackedExerciseId);
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
    notifyListeners();
    return true;
  }

  bool removeSetFromTrackedExercise(String trackedExerciseId, int index) {
    if (_inProgressWorkout == null) {
      return false;
    }

    var trackedExercise = _inProgressWorkout!.exercises
        .where((x) => x.id == trackedExerciseId)
        .firstOrNull;

    if (trackedExercise == null) {
      return false;
    }
    trackedExercise.sets.removeAt(index);
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

    var oldIsSetLogged = trackedExercise.isSetLogged();

    trackedExercise.sets[index] = set;

    if (oldIsSetLogged != trackedExercise.isSetLogged()) {
      notifyListeners();
    }

    return true;
  }
}
