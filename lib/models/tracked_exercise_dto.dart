import 'package:uuid/uuid.dart';

import './exercise_dto.dart';

class TrackedExerciseDto {
  late String id;
  ExerciseDto exercise;
  List<SetDto> sets;

  TrackedExerciseDto({
    this.id = "",
    this.sets = const [],
    required this.exercise,
  }) {
    if (id.isEmpty) {
      id = const Uuid().v4();
    }
  }
}

class SetDto {
  final int reps;
  final int weight;
  final int? restTime;
  // final int? duration;

  SetDto({
    required this.reps,
    required this.weight,
    this.restTime,
  });
}
