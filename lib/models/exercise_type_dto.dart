import 'filters_dto.dart';

const exerciseTypes = {
  'barbell': {'id': 'barbell', 'name': 'barbell'},
  'bodyweight-loadable': {
    'id': 'bodyweight-loadable',
    'name': 'bodyweight-loadable'
  },
  'bodyweight-only': {'id': 'bodyweight-only', 'name': 'bodyweight-only'},
  'cable': {'id': '4', 'name': 'cable'},
  'dumbbell': {'id': 'dumbbell', 'name': 'dumbbell'},
  'freemotion': {'id': 'freemotion', 'name': 'freemotion'},
  'machine': {'id': 'machine', 'name': 'machine'},
  'machine-assistance': {
    'id': 'machine-assistance',
    'name': 'machine-assistance'
  },
  'smith-machine': {'id': 'smith-machine', 'name': 'smith-machine'}
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
