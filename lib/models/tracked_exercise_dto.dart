import 'package:uuid/uuid.dart';

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
}
