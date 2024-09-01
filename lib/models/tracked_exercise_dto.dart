import 'package:uuid/uuid.dart';
import 'dart:convert';

import './exercise_dto.dart';

class TrackedExerciseDto {
  late String id;
  ExerciseDto exercise;
  List<SetDto> sets = [];

  TrackedExerciseDto({
    this.id = "",
    required this.exercise,
  }) {
    if (id.isEmpty) {
      id = const Uuid().v4();
      print("from generating id ${id}");
    }
    sets.add(SetDto());
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

  @override
  String toString() {
    return '\nSetDto{\nreps: $reps, \nweight: $weight, \nrestTime: $restTime, \nisLogged: $isLogged}';
  }
}
