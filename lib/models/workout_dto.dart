import '../utility.dart';
import './tracked_exercise_dto.dart';

class WorkoutDto {
  late String id;
  DateTime? createTime;
  DateTime? startTime;
  DateTime? endTime;
  DateTime? lastUpdated;
  String? title;
  List<TrackedExerciseDto> exercises = [];
  bool areTrackedExercisesLogged = false;
  bool autoTimingSelected = false;
  bool showRestTimerAfterEachSet = false;

  WorkoutDto({
    required this.id,
    required this.title,
    required this.exercises,
    required this.createTime,
    required this.startTime,
    required this.endTime,
    required this.lastUpdated,
    this.areTrackedExercisesLogged = false,
    this.autoTimingSelected = false,
    this.showRestTimerAfterEachSet = false,
  });

  WorkoutDto.newInstance({
    this.title = "",
  }) {
    id = Utility.generateId();
    createTime = DateTime.now();
    startTime = DateTime.now();
    autoTimingSelected = true;
  }

  factory WorkoutDto.fromJson(Map<String, dynamic> json) {
    // print("from WorkoutDto.fromJson ${json}\n");
    // TODO - add validation
    var workout = WorkoutDto(
      id: json['id'],
      title: json['title'],
      createTime: json['createTime'] != null
          ? DateTime.parse(json['createTime'])
          : null,
      startTime:
          json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
      exercises: (json['exercises'] as List)
          .map((exercise) => TrackedExerciseDto.fromJson(exercise))
          .toList(),
      showRestTimerAfterEachSet: json['showRestTimerAfterExercise'] ?? false,
    );
    workout.setAreTrackedExercisesLogged();
    return workout;
  }

  factory WorkoutDto.fromWorkoutDto({
    required WorkoutDto workout,
    required bool shouldCreateAsNew,
  }) {
    // mark sets as not logged.
    var tempExercises = workout.exercises.map((x) {
      var trackedExercise =
          TrackedExerciseDto.newInstance(exercise: x.exercise);
      trackedExercise.sets = x.sets.map((y) {
        var updatedSet = SetDto.getCopy(y);
        if (shouldCreateAsNew) {
          updatedSet.isLogged = false;
          updatedSet.restTimerShown = false;
        }
        return updatedSet;
      }).toList();
      return trackedExercise;
    }).toList();

    return WorkoutDto(
      id: shouldCreateAsNew ? Utility.generateId() : workout.id,
      title: workout.title,
      exercises: tempExercises,
      createTime: shouldCreateAsNew ? DateTime.now() : workout.createTime,
      startTime: shouldCreateAsNew ? DateTime.now() : workout.startTime,
      endTime: shouldCreateAsNew ? null : workout.endTime,
      lastUpdated: shouldCreateAsNew ? null : workout.lastUpdated,
      autoTimingSelected: shouldCreateAsNew,
      // needs to be set manually or in user preferences.
      showRestTimerAfterEachSet: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'exercises': exercises.map((x) => x.toJson()).toList(),
      'createTime': createTime?.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
      'showRestTimerAfterExercise': showRestTimerAfterEachSet,
    };
  }

  bool setAreTrackedExercisesLogged({
    bool shouldForceValue = false,
    bool forcedValue = false,
  }) {
    if (shouldForceValue) {
      areTrackedExercisesLogged = forcedValue;
      return forcedValue;
    }
    areTrackedExercisesLogged =
        exercises.isNotEmpty && exercises.every((x) => x.areSetsLogged());
    return areTrackedExercisesLogged;
  }
}
