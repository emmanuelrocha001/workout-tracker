import 'dart:convert';
import '../utility.dart';
import "../../models/muscle_group_dto.dart";
import './exercise_type_dto.dart';
import "../class_extensions.dart";

class ExerciseDto {
  late String id;
  String name;
  String muscleGroupId;
  String exerciseType;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? youtubeId;
  String? description;
  bool isCustom = false;
  String searchableString = "";
  ExerciseDimensionsDto? dimensions;

  ExerciseDto({
    required this.id,
    required this.name,
    required this.muscleGroupId,
    required this.exerciseType,
    required this.createdAt,
    required this.updatedAt,
    this.dimensions,
    this.youtubeId,
    this.description,
  });

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  ExerciseDto.newInstance({
    required this.name,
    required this.muscleGroupId,
    required this.exerciseType,
    this.description,
    this.youtubeId,
  }) {
    id = Utility.generateId();
    dimensions = ExerciseDimensionsDto.getDimensions(exerciseType);
    createdAt = DateTime.now();
    updatedAt = createdAt;
    isCustom = true;
    setSearchableString();
  }

  factory ExerciseDto.fromJson(Map<String, dynamic> json) {
    String id = json['id'].toString();
    String name = json['name'].toString();
    String muscleGroupId = json['muscleGroupId'].toString();
    String exerciseType = json['exerciseType'].toString();
    DateTime? createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    DateTime? updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : createdAt;
    String? youtubeId = json['youtubeId']?.toString();
    String? description = json['description']?.toString();
    if (id.isNullOrEmpty ||
        name.isNullOrEmpty ||
        muscleGroupId.isNullOrEmpty ||
        exerciseType.isNullOrEmpty) {
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
      dimensions: ExerciseDimensionsDto.getDimensions(exerciseType),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'muscleGroupId': muscleGroupId,
      'exerciseType': exerciseType,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'youtubeId': youtubeId,
      'description': description,
      'dimensions': dimensions,
    };
  }

  void setSearchableString() {
    searchableString =
        '${name.toLowerCase()} ${MuscleGroupDto.getMuscleGroupName(muscleGroupId).toUpperCase()}';
  }
}
