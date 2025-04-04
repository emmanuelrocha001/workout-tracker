import 'package:uuid/uuid.dart';

import './exercise_dto.dart';

class TrackedExerciseDto {
  late String id;
  ExerciseDto exercise;
  List<SetDto> sets = [];
  bool? isCollapsed;

  TrackedExerciseDto({
    required this.id,
    required this.exercise,
    required this.sets,
    this.isCollapsed,
  });

  TrackedExerciseDto.newInstance({required this.exercise}) {
    id = const Uuid().v4();
    print("from generating id ${id}");
    sets.add(SetDto());
  }

  factory TrackedExerciseDto.fromJson(Map<String, dynamic> json) {
    // print("from TrackedExerciseDto.fromJson ${json}\n");
    return TrackedExerciseDto(
      id: json['id'],
      isCollapsed: json['isCollapsed'],
      exercise: ExerciseDto.fromJson(json['exercise']),
      sets: (json['sets'] as List)
          .map((set) => SetDto(
                reps: set['reps'],
                weight: set['weight'],
                distance: set['distance'],
                time: set['time'],
                restTime: set['restTime'],
                isLogged: set['isLogged'],
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercise': exercise.toJson(),
      'sets': sets.map((x) => x.toJson()).toList(),
      'isCollapsed': isCollapsed,
    };
  }

  bool areSetsLogged() {
    if (sets.isEmpty) {
      return false;
    }
    return sets.every((x) => x.isLogged);
  }

  double getTotalDistance() {
    if (exercise.dimensions?.isDistanceEnabled ?? false) {
      return sets.fold(0.0, (total, set) => total + (set.distance ?? 0.0));
    }
    return 0.0;
  }

  double getTotalWeight() {
    if (exercise.dimensions?.isWeightEnabled ?? false) {
      return sets.fold(
          0.0, (total, set) => total + ((set.weight ?? 0.0) * (set.reps ?? 0)));
    }
    return 0.0;
  }
}

class SetDto implements ISetDto {
  @override
  int? reps;
  @override
  double? weight;
  @override
  double? distance;
  @override
  String? time;
  int? restTime;
  bool isLogged;
  bool restTimerShown;
  // final int? duration;

  SetDto({
    this.reps,
    this.weight,
    this.distance,
    this.time,
    this.restTime,
    this.isLogged = false,
    this.restTimerShown = false,
  });

  factory SetDto.getCopy(SetDto set) {
    return SetDto(
      reps: set.reps,
      weight: set.weight,
      distance: set.distance,
      time: set.time,
      restTime: set.restTime,
      isLogged: set.isLogged,
      restTimerShown: set.restTimerShown,
    );
  }

  @override
  String toString() {
    return 'SetDto{reps: $reps, weight: $weight, distance: $distance, time: $time, restTime: $restTime, isLogged: $isLogged, restTimerShown: $restTimerShown}';
  }

  factory SetDto.fromJson(Map<String, dynamic> json) {
    // print("from SetDto.fromJson ${json}\n");
    // TODO: Add validation
    return SetDto(
      reps: json['reps'],
      weight: json['weight'],
      distance: json['distance'],
      time: json['time'],
      restTime: json['restTime'],
      isLogged: json['isLogged'],
      restTimerShown: json['restTimerShown'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reps': reps,
      'weight': weight,
      'distance': distance,
      'time': time,
      'restTime': restTime,
      'isLogged': isLogged,
      'restTimerShown': restTimerShown,
    };
  }
}

abstract class ISetDto {
  int? get reps;
  double? get weight;
  double? get distance;
  String? get time;
}

class SetDtoSimplified implements ISetDto {
  @override
  int? reps;
  @override
  double? weight;
  @override
  double? distance;
  @override
  String? time;

  SetDtoSimplified({
    this.reps,
    this.weight,
    this.distance,
    this.time,
  });

  factory SetDtoSimplified.fromJson(Map<String, dynamic> json) {
    return SetDtoSimplified(
      reps: json['reps'],
      weight: json['weight'],
      distance: json['distance'],
      time: json['time'],
    );
  }

  factory SetDtoSimplified.fromSetDto(SetDto set) {
    return SetDtoSimplified(
      reps: set.reps,
      weight: set.weight,
      distance: set.distance,
      time: set.time,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = {};
    if (reps != null) {
      jsonData['reps'] = reps;
    }
    if (weight != null) {
      jsonData['weight'] = weight;
    }
    if (distance != null) {
      jsonData['distance'] = distance;
    }
    if (time != null) {
      jsonData['time'] = time;
    }
    return jsonData;
  }
}
