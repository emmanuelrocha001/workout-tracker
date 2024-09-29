import 'package:uuid/uuid.dart';
import 'dart:convert';

import './exercise_dto.dart';

class TrackedExerciseDto {
  late String id;
  ExerciseDto exercise;
  List<SetDto> sets = [];

  TrackedExerciseDto({
    required this.id,
    required this.exercise,
    required this.sets,
  });

  TrackedExerciseDto.newInstance({required this.exercise}) {
    id = const Uuid().v4();
    print("from generating id ${id}");
    sets.add(SetDto());
  }

  factory TrackedExerciseDto.fromJson(Map<String, dynamic> json) {
    return TrackedExerciseDto(
      id: json['id'],
      exercise: ExerciseDto.fromJson(json['exercise']),
      sets: (json['sets'] as List)
          .map((set) => SetDto(
                reps: set['reps'],
                weight: set['weight'],
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
    };
  }

  bool isSetLogged() {
    return sets.every((x) => x.isLogged);
  }
}

class SetDto {
  int? reps;
  double? weight;
  int? restTime;
  bool isLogged;
  // final int? duration;

  SetDto({
    this.reps,
    this.weight,
    this.restTime,
    this.isLogged = false,
  });

  factory SetDto.getCopy(SetDto set) {
    return SetDto(
      reps: set.reps,
      weight: set.weight,
      restTime: set.restTime,
      isLogged: set.isLogged,
    );
  }

  factory SetDto.fromJson(Map<String, dynamic> json) {
    // TODO: Add validation
    return SetDto(
      reps: json['reps'],
      weight: json['weight'],
      restTime: json['restTime'],
      isLogged: json['isLogged'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reps': reps,
      'weight': weight,
      'restTime': restTime,
      'isLogged': isLogged,
    };
  }

  @override
  String toString() {
    return '\nSetDto{\nreps: $reps, \nweight: $weight, \nrestTime: $restTime, \nisLogged: $isLogged}';
  }
}
