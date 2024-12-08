import "package:workout_tracker/models/filters_dto.dart";

import "../class_extensions.dart";

const muscleGroups = {
  "1": {"name": "Chest", "startingSets": 2, "deloadSets": 2},
  "2": {"name": "Back", "startingSets": 2, "deloadSets": 2},
  "3": {"name": "Triceps", "startingSets": 2, "deloadSets": 2},
  "4": {"name": "Biceps", "startingSets": 3, "deloadSets": 2},
  "5": {"name": "Shoulders", "startingSets": 3, "deloadSets": 2},
  "6": {"name": "Quads", "startingSets": 2, "deloadSets": 2},
  "7": {"name": "Glutes", "startingSets": 2, "deloadSets": 2},
  "8": {"name": "Hamstrings", "startingSets": 1, "deloadSets": 2},
  "9": {"name": "Calves", "startingSets": 2, "deloadSets": 2},
  "10": {"name": "Traps", "startingSets": 2, "deloadSets": 0},
  "11": {"name": "Forearms", "startingSets": 3, "deloadSets": 0},
  "12": {"name": "Abs", "startingSets": 2, "deloadSets": 2},
  "13": {"name": "Full Body", "startingSets": 2, "deloadSets": 2},
  "14": {"name": "Cardio", "startingSets": 2, "deloadSets": 2},
  "15": {"name": "Other", "startingSets": 2, "deloadSets": 2},
};

class MuscleGroupDto {
  final String id;
  final String name;
  final int startingSets;
  final int deloadSets;

  MuscleGroupDto({
    required this.id,
    required this.name,
    required this.startingSets,
    required this.deloadSets,
  });

  @override
  String toString() {
    return '\nMuscleGroupDto{\nid: $id, \nname: $name, \nstartingSets: $startingSets, \ndeloadSets: $deloadSets}';
  }

  static String getMuscleGroupName(String id) {
    return muscleGroups[id]!['name'].toString();
  }

  static const String filterName = "Muscle Group";

  static List<MuscleGroupDto> getMuscleGroups() {
    return muscleGroups.keys
        .map((key) => MuscleGroupDto.fromJson(key, muscleGroups[key]!))
        .toList();
  }

  static FiltersDto toFiltersDto(List<MuscleGroupDto> muscleGroups) {
    return FiltersDto(
      name: filterName,
      filters: muscleGroups
          .map(
            (muscleGroup) => FilterDto(
              displayValue: muscleGroup.name,
              value: muscleGroup.id,
            ),
          )
          .toList(),
    );
  }

  static bool isValidMuscleGroupId(String muscleGroupId) {
    return muscleGroups.containsKey(muscleGroupId);
  }

  factory MuscleGroupDto.fromJson(String key, Map<String, dynamic> value) {
    String id = key;
    String name = value['name']!.toString();
    int startingSets = value['startingSets']!;
    int deloadSets = value['deloadSets']!;
    if (id.isNullOrEmpty || name.isNullOrEmpty) {
      throw Exception("Invalid Exercise data");
    }

    return MuscleGroupDto(
      id: id,
      name: name,
      startingSets: startingSets,
      deloadSets: deloadSets,
    );
  }
}
