import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker/models/exercise_dto.dart';
import 'package:workout_tracker/models/exercise_type_dto.dart';
import '../../providers/config_provider.dart';
import 'package:workout_tracker/widgets/general/labeled_row.dart';
import '../general/text_style_templates.dart';
import '../general/row_item.dart';
import '../general/edit_text_field_form.dart';
import '../helper.dart';
import '../general/default_text_field.dart';
import '../../models/filters_dto.dart';
import '../../models/muscle_group_dto.dart';
import '../general/default_dropdown.dart';
import '../general/pill_container.dart';

class ExerciseDetails extends StatefulWidget {
  final ExerciseDto exercise;
  final bool inEditMode;
  const ExerciseDetails({
    super.key,
    required this.exercise,
    this.inEditMode = false,
  });

  @override
  State<ExerciseDetails> createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> {
  TextEditingController? _nameController;
  final _nameFocusNode = FocusNode();
  TextEditingController? _descriptionController;
  final _descriptionFocusNode = FocusNode();
  TextEditingController? _youtubeIdController;
  final _youtubeIdFocusNode = FocusNode();
  final _muscleGroupFocusNode = FocusNode();
  final _exerciseTypeFocusNode = FocusNode();

  FiltersDto? muscleGroupSelection;
  FiltersDto? exerciseTypeSelection;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController(text: widget.exercise.name);
    _descriptionController =
        TextEditingController(text: widget.exercise.description);
    _youtubeIdController =
        TextEditingController(text: widget.exercise.youtubeId);
    muscleGroupSelection = MuscleGroupDto.toFiltersDto(
      MuscleGroupDto.getMuscleGroups(),
    );
    muscleGroupSelection!.selectedValue = widget.exercise.muscleGroupId;

    exerciseTypeSelection = ExerciseTypeDto.toFiltersDto(
      ExerciseTypeDto.getExerciseTypes(),
    );
    exerciseTypeSelection!.selectedValue = widget.exercise.exerciseType;
  }

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat(ConfigProvider.defaultDateStampFormatWithTime);

    return Column(
      children: [
        LabeledRow(
          label: 'Name',
          children: [
            RowItem(
              alignment: Alignment.centerLeft,
              child: widget.inEditMode
                  ? DefaultTextField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      nextFocusNode: _descriptionFocusNode,
                    )
                  : Text(
                      widget.exercise.name,
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
              child: widget.inEditMode
                  ? DefaultTextField(
                      controller: _descriptionController,
                      focusNode: _descriptionFocusNode,
                      nextFocusNode: _youtubeIdFocusNode,
                    )
                  : Text(
                      widget.exercise.description ?? '',
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
              child: widget.inEditMode
                  ? DefaultTextField(
                      controller: _youtubeIdController,
                      focusNode: _youtubeIdFocusNode,
                    )
                  : Text(
                      widget.exercise.youtubeId ?? '',
                      style: TextStyleTemplates.defaultTextStyle(
                        ConfigProvider.mainTextColor,
                      ),
                    ),
            )
          ],
        ),
        if (muscleGroupSelection != null)
          LabeledRow(
            label: 'Muscle Group',
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.inEditMode
                  ? DefaultDropDownMenu(
                      selection: muscleGroupSelection!,
                      onSelected: (value) {
                        print(value);
                        setState(() {
                          muscleGroupSelection!.selectedValue = value;
                        });
                      },
                      focusNode: _muscleGroupFocusNode,
                    )
                  : PillContainer(
                      color: ConfigProvider.slightContrastBackgroundColor,
                      child: Text(
                        MuscleGroupDto.getMuscleGroupName(
                                widget.exercise.muscleGroupId)
                            .toUpperCase(),
                        style: TextStyleTemplates.defaultTextStyle(
                          ConfigProvider.mainTextColor,
                        ),
                      ),
                    )
            ],
          ),
        if (exerciseTypeSelection != null)
          LabeledRow(
            label: 'Exercice Type',
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.inEditMode
                  ? DefaultDropDownMenu(
                      selection: exerciseTypeSelection!,
                      onSelected: (value) {
                        print(value);
                        setState(() {
                          exerciseTypeSelection!.selectedValue = value;
                        });
                      },
                      focusNode: _exerciseTypeFocusNode,
                    )
                  : PillContainer(
                      color: ConfigProvider.slightContrastBackgroundColor,
                      child: Text(
                        widget.exercise.exerciseType.toUpperCase(),
                        style: TextStyleTemplates.defaultTextStyle(
                          ConfigProvider.mainTextColor,
                        ),
                      ),
                    ),
            ],
          ),
        if (!widget.inEditMode)
          LabeledRow(
            label: 'Created At',
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                dateFormat.format(widget.exercise.createdAt!),
                style: TextStyleTemplates.defaultTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
            ],
          ),
        if (!widget.inEditMode)
          LabeledRow(
            label: 'Updated At',
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                dateFormat.format(widget.exercise.updatedAt!),
                style: TextStyleTemplates.defaultTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
