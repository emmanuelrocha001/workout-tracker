import 'filters_dto.dart';

const exerciseTypes = {
  'barbell': {'id': 'barbell', 'name': 'Barbell'},
  'bodyweight-loadable': {
    'id': 'bodyweight-loadable',
    'name': 'Bodyweight-Loadable'
  },
  'bodyweight-only': {'id': 'bodyweight-only', 'name': 'Bodyweight-Only'},
  'cable': {'id': 'cable', 'name': 'Cable'},
  'dumbbell': {'id': 'dumbbell', 'name': 'Dumbbell'},
  'freemotion': {'id': 'freemotion', 'name': 'Freemotion'},
  'machine': {'id': 'machine', 'name': 'Machine'},
  'machine-assistance': {
    'id': 'machine-assistance',
    'name': 'Machine-Assistance'
  },
  'smith-machine': {'id': 'smith-machine', 'name': 'Smith-Machine'},
  'standard': {'id': 'standard', 'name': 'Standard'},
  'reps-only': {'id': 'reps-only', 'name': 'Reps-Only'},
  'timed': {'id': 'timed', 'name': 'Timed'},
  'distance': {'id': 'distance', 'name': 'Distance'},
};

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
