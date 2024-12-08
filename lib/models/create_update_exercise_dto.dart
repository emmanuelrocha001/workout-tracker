class CreateUpdateExerciseDto {
  String name = "";
  String muscleGroupId = "";
  String exerciseType = "";
  String? description;
  String? youtubeId;

  CreateUpdateExerciseDto({
    required this.name,
    required this.muscleGroupId,
    required this.exerciseType,
    this.description,
    this.youtubeId,
  });
}
