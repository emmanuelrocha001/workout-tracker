import "../class_extensions.dart";

class ExerciseDto {
  final String id;
  final String name;
  final String muscleGroupId;
  final String exerciseType;
  final String createdAt;
  final String updatedAt;
  final String? youtubeId;
  final String? description;

  ExerciseDto({
    required this.id,
    required this.name,
    required this.muscleGroupId,
    required this.exerciseType,
    required this.createdAt,
    required this.updatedAt,
    this.youtubeId,
    this.description,
  });

  @override
  String toString() {
    return '\nExerciseDto{\nid: $id, \nname: $name, \nmuscleGroupId: $muscleGroupId, \nexerciseType: $exerciseType, \ncreatedAt: $createdAt, \nupdatedAt: $updatedAt, \nyoutubeId: $youtubeId, \ndescription: $description}';
  }

  factory ExerciseDto.fromJson(Map<String, dynamic> value) {
    String id = value['id'].toString();
    String name = value['name'].toString();
    String muscleGroupId = value['muscleGroupId'].toString();
    String exerciseType = value['exerciseType'].toString();
    String createdAt = value['createdAt'].toString();
    String updatedAt = value['updatedAt'].toString();
    String? youtubeId = value['youtubeId']?.toString();
    String? description = value['description']?.toString();
    if (id.isNullOrEmpty ||
        name.isNullOrEmpty ||
        muscleGroupId.isNullOrEmpty ||
        exerciseType.isNullOrEmpty ||
        createdAt.isNullOrEmpty ||
        updatedAt.isNullOrEmpty) {
      throw Exception("Invalid Exercise data");
    }

    return ExerciseDto(
      id: id,
      name: name,
      muscleGroupId: muscleGroupId,
      exerciseType: exerciseType,
      createdAt: createdAt,
      updatedAt: updatedAt,
      youtubeId: youtubeId,
      description: description,
    );
  }
}
