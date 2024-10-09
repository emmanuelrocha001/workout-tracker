import '../utility.dart';
import './tracked_exercise_dto.dart';

class WorkoutDto {
  late String id;
  DateTime? startTime;
  DateTime? endTime;
  String? title;
  List<TrackedExerciseDto> exercises = [];
  bool areTrackedExercisesLogged = false;

  WorkoutDto({
    required this.id,
    required this.title,
    required this.exercises,
    required this.startTime,
    required this.endTime,
    this.areTrackedExercisesLogged = false,
  });

  WorkoutDto.newInstance({this.title = ""}) {
    id = Utility.generateId();
    startTime = DateTime.now();
  }

  factory WorkoutDto.fromJson(Map<String, dynamic> json) {
    // print("from WorkoutDto.fromJson ${json}\n");
    // TODO - add validation
    var workout = WorkoutDto(
      id: json['id'],
      title: json['title'],
      startTime:
          json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      exercises: (json['exercises'] as List)
          .map((exercise) => TrackedExerciseDto.fromJson(exercise))
          .toList(),
    );
    workout.setAreTrackedExercisesLogged();
    return workout;
  }

  factory WorkoutDto.fromWorkoutDto({
    required WorkoutDto workout,
  }) {
    // mark sets as not logged.
    var tempExercises = workout.exercises.map((x) {
      var trackedExercise =
          TrackedExerciseDto.newInstance(exercise: x.exercise);
      trackedExercise.sets = x.sets.map((y) {
        var updatedSet = SetDto.getCopy(y);
        updatedSet.isLogged = false;
        return updatedSet;
      }).toList();
      return trackedExercise;
    }).toList();

    return WorkoutDto(
      id: Utility.generateId(),
      title: workout.title,
      exercises: tempExercises,
      startTime: DateTime.now(),
      endTime: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'exercises': exercises.map((x) => x.toJson()).toList(),
      'endTime': endTime?.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
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
