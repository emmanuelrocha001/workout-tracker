import '../utility.dart';
import './tracked_exercise_dto.dart';

class WorkoutDto {
  late String id;
  DateTime? startTime;
  DateTime? endTime;
  String title;
  List<TrackedExerciseDto> exercises = [];

  WorkoutDto({
    required this.id,
    required this.title,
    required this.exercises,
  });

  WorkoutDto.newInstance({this.title = ""}) {
    id = Utility.generateId();
    startTime = DateTime.now();
  }

  factory WorkoutDto.fromJson(Map<String, dynamic> json) {
    // TODO - add validation
    return WorkoutDto(
      id: json['id'],
      title: json['name'],
      exercises: (json['exercises'] as List)
          .map((exercise) => TrackedExerciseDto.fromJson(exercise))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'exercises': exercises.map((x) => x.toJson()).toList(),
    };
  }
}
