import '../utility.dart';
import './tracked_exercise_dto.dart';

class TrackedExerciseHistoryEntryDto {
  late String id;

  /// The exercise id.
  String exerciseId;

  /// The id of the workout that this entry is sourced from.
  String workoutId;

  /// The date and time of the workout that this entry is sourced from.
  DateTime workoutStartDate;

  /// The date and time that this entry will expire.
  late DateTime expiryDate;

  /// A simplified form of the sets performed for this exercise from the sourced workout.
  List<SetDtoSimplified> sets = [];

  TrackedExerciseHistoryEntryDto({
    required this.exerciseId,
    required this.workoutId,
    required this.sets,
    required this.workoutStartDate,
    required this.expiryDate,
  });

  TrackedExerciseHistoryEntryDto.newInstance({
    required this.exerciseId,
    required this.workoutId,
    required this.workoutStartDate,
    required this.sets,
  }) {
    id = Utility.generateId();
    expiryDate = workoutStartDate.add(const Duration(days: 365));
  }

  factory TrackedExerciseHistoryEntryDto.fromJson(Map<String, dynamic> json) {
    return TrackedExerciseHistoryEntryDto(
      exerciseId: json['exerciseId'],
      workoutId: json['workoutId'],
      workoutStartDate: DateTime.parse(json['workoutStartDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      sets: (json['sets'] as List)
          .map((set) => SetDtoSimplified.fromJson(set))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'workoutId': workoutId,
      'workoutStartDate': workoutStartDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'sets': sets.map((x) => x.toJson()).toList(),
    };
  }
}
