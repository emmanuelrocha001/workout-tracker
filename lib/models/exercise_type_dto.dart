import 'filters_dto.dart';
import 'dart:convert';

const exerciseTypes = {
  'barbell': {
    'id': 'barbell',
    'name': 'Barbell',
    'isRepEnabled': true,
    'isWeightEnabled': true,
  },
  'bodyweight-loadable': {
    'id': 'bodyweight-loadable',
    'name': 'Bodyweight-Loadable',
    'isRepEnabled': true,
    'isWeightEnabled': true,
  },
  'bodyweight-only': {
    'id': 'bodyweight-only',
    'name': 'Bodyweight-Only',
    'isRepEnabled': true,
  },
  'cable': {
    'id': 'cable',
    'name': 'Cable',
    'isRepEnabled': true,
    'isWeightEnabled': true,
  },
  'dumbbell': {
    'id': 'dumbbell',
    'name': 'Dumbbell',
    'isRepEnabled': true,
    'isWeightEnabled': true,
  },
  'freemotion': {
    'id': 'freemotion',
    'name': 'Freemotion',
    'isRepEnabled': true,
    'isWeightEnabled': true,
  },
  'machine': {
    'id': 'machine',
    'name': 'Machine',
    'isRepEnabled': true,
    'isWeightEnabled': true,
  },
  'machine-assistance': {
    'id': 'machine-assistance',
    'name': 'Machine-Assistance',
    'isRepEnabled': true,
    'isWeightEnabled': true,
  },
  'smith-machine': {
    'id': 'smith-machine',
    'name': 'Smith-Machine',
    'isRepEnabled': true,
    'isWeightEnabled': true,
  },
  'standard': {
    'id': 'standard',
    'name': 'Standard',
    'isRepEnabled': true,
    'isWeightEnabled': true,
  },
  'reps-only': {
    'id': 'reps-only',
    'name': 'Reps-Only',
    'isRepEnabled': true,
  },
  'timed': {
    'id': 'timed',
    'name': 'Timed',
    'isTimeEnabled': true,
  },
  'distance': {
    'id': 'distance',
    'name': 'Distance',
    'isTimeEnabled': true,
    'isDistanceEnabled': true,
  },
};

class ExerciseDimensionsDto {
  final bool isRepEnabled;
  final bool isWeightEnabled;
  final bool isTimeEnabled;
  final bool isDistanceEnabled;

  ExerciseDimensionsDto(
      {this.isRepEnabled = false,
      this.isWeightEnabled = false,
      this.isTimeEnabled = false,
      this.isDistanceEnabled = false});

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'isRepEnabled': isRepEnabled,
      'isWeightEnabled': isWeightEnabled,
      'isTimeEnabled': isTimeEnabled,
      'isDistanceEnabled': isDistanceEnabled,
    };
  }

  static ExerciseDimensionsDto? getDimensions(String exerciseType) {
    if (!exerciseTypes.containsKey(exerciseType)) return null;

    var data = exerciseTypes[exerciseType];
    if (data == null) return null;
    return ExerciseDimensionsDto(
      isRepEnabled:
          (exerciseTypes[exerciseType]?['isRepEnabled'] as bool?) ?? false,
      isWeightEnabled:
          (exerciseTypes[exerciseType]?['isWeightEnabled'] as bool?) ?? false,
      isTimeEnabled:
          (exerciseTypes[exerciseType]?['isTimeEnabled'] as bool?) ?? false,
      isDistanceEnabled:
          (exerciseTypes[exerciseType]?['isDistanceEnabled'] as bool?) ?? false,
    );
  }
}

class ExerciseTypeDto {
  final String id;
  final String name;

  ExerciseTypeDto({
    required this.id,
    required this.name,
  });

  static const String filterName = "Exercise Type";

  static List<ExerciseTypeDto> getExerciseTypes() {
    return exerciseTypes.keys
        .map((key) => ExerciseTypeDto.fromJson(key, exerciseTypes[key]!))
        .toList();
  }

  static FiltersDto toFiltersDto(List<ExerciseTypeDto> exerciseTypes) {
    return FiltersDto(
      name: filterName,
      filters: exerciseTypes
          .map(
            (x) => FilterDto(
              displayValue: x.name,
              value: x.id,
            ),
          )
          .toList(),
    );
  }

  factory ExerciseTypeDto.fromJson(String key, Map<String, dynamic> json) {
    return ExerciseTypeDto(
      id: json['id'],
      name: json['name'],
    );
  }
}
