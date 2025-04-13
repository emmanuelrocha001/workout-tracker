import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker/models/exercise_dto.dart';
import '../../providers/config_provider.dart';
import 'package:workout_tracker/widgets/general/labeled_row.dart';
import '../general/text_style_templates.dart';
import '../general/row_item.dart';
import '../../models/muscle_group_dto.dart';
import '../general/pill_container.dart';
import '../helper.dart';

class ExerciseDetails extends StatelessWidget {
  final ExerciseDto exercise;
  const ExerciseDetails({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    print('exercise details build');
    var dateFormat = DateFormat(ConfigProvider.defaultDateStampFormatWithTime);
    return SingleChildScrollView(
      child: Column(
        children: [
          LabeledRow(
            label: 'Name',
            children: [
              RowItem(
                alignment: Alignment.centerLeft,
                child: Text(
                  exercise?.name ?? '',
                  style: TextStyleTemplates.defaultTextStyle(
                    ConfigProvider.mainTextColor,
                  ),
                ),
              )
            ],
          ),
          LabeledRow(
            label: 'Description',
            children: [
              RowItem(
                alignment: Alignment.centerLeft,
                child: Text(
                  exercise?.description ?? '',
                  style: TextStyleTemplates.defaultTextStyle(
                    ConfigProvider.mainTextColor,
                  ),
                ),
              )
            ],
          ),
          LabeledRow(
            label: 'YouTube Id',
            tooltip:
                "This Id will be used to redirect to the specified video. If left blank, the exercise name will be used as part of the search query.",
            children: [
              RowItem(
                alignment: Alignment.centerLeft,
                child: Text(
                  exercise?.youtubeId ?? '',
                  style: TextStyleTemplates.defaultTextStyle(
                    ConfigProvider.mainTextColor,
                  ),
                ),
              ),
            ],
          ),
          if (exercise.youtubeId != null && exercise.youtubeId!.isNotEmpty)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    ConfigProvider.defaultSpace,
                  ),
                  child: Image.network(
                    'https://img.youtube.com/vi/${exercise?.youtubeId}/maxresdefault.jpg',
                    width: ConfigProvider.defaultThumbnailWidth,
                    height: ConfigProvider.defaultThumbnailHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                ),
                SizedBox(
                  width: ConfigProvider.defaultThumbnailWidth,
                  height: ConfigProvider.defaultThumbnailHeight,
                  child: Center(
                    child: IconButton(
                      alignment: Alignment.center,
                      style: TextButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.black.withOpacity(0.25),
                      ),
                      icon: const Icon(
                        size: ConfigProvider.defaultIconSize * 1.5,
                        Icons.play_circle_outline_rounded,
                        color: ConfigProvider.backgroundColorSolid,
                      ),
                      onPressed: () {
                        Helper.navigateToYoutube(
                          context: context,
                          youtubeId: exercise.youtubeId,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          LabeledRow(
            label: 'Muscle Group',
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PillContainer(
                color: ConfigProvider.backgroundColor,
                child: Text(
                  MuscleGroupDto.getMuscleGroupName(exercise!.muscleGroupId)
                      .toUpperCase(),
                  style: TextStyleTemplates.defaultTextStyle(
                    ConfigProvider.mainTextColor,
                  ),
                ),
              )
            ],
          ),
          LabeledRow(
            label: 'Exercice Type',
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PillContainer(
                color: ConfigProvider.backgroundColor,
                child: Text(
                  exercise.exerciseType.toUpperCase(),
                  style: TextStyleTemplates.defaultTextStyle(
                    ConfigProvider.mainTextColor,
                  ),
                ),
              ),
            ],
          ),
          LabeledRow(
            label: 'Created At',
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                dateFormat.format(exercise.createdAt!),
                style: TextStyleTemplates.defaultTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
            ],
          ),
          LabeledRow(
            label: 'Updated At',
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                dateFormat.format(exercise.updatedAt!),
                style: TextStyleTemplates.defaultTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
