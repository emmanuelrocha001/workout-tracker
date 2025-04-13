import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker/models/create_update_exercise_dto.dart';
import 'package:workout_tracker/models/exercise_dto.dart';
import 'package:workout_tracker/models/exercise_type_dto.dart';
import '../../providers/config_provider.dart';
import 'package:workout_tracker/widgets/general/labeled_row.dart';
import '../general/text_style_templates.dart';
import '../general/row_item.dart';
import '../general/default_text_field.dart';
import '../../models/filters_dto.dart';
import '../../models/muscle_group_dto.dart';
import '../general/default_dropdown.dart';
import '../general/pill_container.dart';
import '../general/action_button.dart';
import '../helper.dart';

class CreateUpdateExerciseForm extends StatefulWidget {
  final ExerciseDto? exercise;
  const CreateUpdateExerciseForm({
    super.key,
    this.exercise,
  });

  @override
  State<CreateUpdateExerciseForm> createState() =>
      _CreateUpdateExerciseFormState();
}

class _CreateUpdateExerciseFormState extends State<CreateUpdateExerciseForm> {
  final _formKey = GlobalKey<FormState>();
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
    _nameController = TextEditingController(text: widget.exercise?.name);
    _descriptionController =
        TextEditingController(text: widget.exercise?.description);
    _youtubeIdController =
        TextEditingController(text: widget.exercise?.youtubeId);
    muscleGroupSelection = MuscleGroupDto.toFiltersDto(
      MuscleGroupDto.getMuscleGroups(),
    );
    muscleGroupSelection!.selectedValue = widget.exercise?.muscleGroupId ?? '';

    exerciseTypeSelection = ExerciseTypeDto.toFiltersDto(
      ExerciseTypeDto.getExerciseTypes(),
    );
    exerciseTypeSelection!.selectedValue = widget.exercise?.exerciseType ?? '';
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required.';
    }
    return null;
  }

  String? _validateMuscleGroup(String? value) {
    print('muscle group value $value');
    if (value == null || value.isEmpty) {
      return 'Muscle Group is required.';
    }
    return null;
  }

  String? _validateExerciseType(String? value) {
    print('exercise type value $value');
    if (value == null || value.isEmpty) {
      return 'Exercise Type is required.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print('exercise details build');
    var dateFormat = DateFormat(ConfigProvider.defaultDateStampFormatWithTime);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            LabeledRow(
              label: 'Name',
              children: [
                RowItem(
                  alignment: Alignment.centerLeft,
                  child: DefaultTextField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    nextFocusNode: _descriptionFocusNode,
                    validator: _validateName,
                  ),
                )
              ],
            ),
            LabeledRow(
              label: 'Description',
              children: [
                RowItem(
                  alignment: Alignment.centerLeft,
                  child: DefaultTextField(
                    controller: _descriptionController,
                    focusNode: _descriptionFocusNode,
                    nextFocusNode: _youtubeIdFocusNode,
                  ),
                )
              ],
            ),
            LabeledRow(
              label: 'YouTube Id',
              tooltip:
                  "Enter a YouTube video ID or paste a full YouTube link — we’ll extract the ID for you.",
              children: [
                RowItem(
                  alignment: Alignment.centerLeft,
                  child: DefaultTextField(
                    controller: _youtubeIdController,
                    focusNode: _youtubeIdFocusNode,
                  ),
                ),
                IconButton(
                  tooltip: 'Pase from clipboard',
                  icon: const Icon(
                    // Icons.auto_graph_rounded,
                    Icons.paste_rounded,
                    color: ConfigProvider.mainColor,
                    size: ConfigProvider.defaultIconSize,
                  ),
                  // style: _theme.iconButtonTheme.style,
                  onPressed: () async {
                    var latestClipboardValue = await Helper.getClipboardText();
                    _youtubeIdController!.text = latestClipboardValue;
                  },
                ),
              ],
            ),
            if (muscleGroupSelection != null)
              LabeledRow(
                label: 'Muscle Group',
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DefaultDropDownMenu(
                    selection: muscleGroupSelection!,
                    onSelected: (value) {
                      print(value);
                      setState(() {
                        muscleGroupSelection!.selectedValue = value;
                      });
                    },
                    focusNode: _muscleGroupFocusNode,
                    validator: _validateMuscleGroup,
                  )
                ],
              ),
            if (exerciseTypeSelection != null)
              LabeledRow(
                label: 'Exercice Type',
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  exerciseTypeSelection != null && widget.exercise == null
                      ? DefaultDropDownMenu(
                          selection: exerciseTypeSelection!,
                          validator: _validateExerciseType,
                          onSelected: (value) {
                            print(value);
                            setState(() {
                              exerciseTypeSelection!.selectedValue = value;
                            });
                          },
                          focusNode: _exerciseTypeFocusNode,
                        )
                      : PillContainer(
                          color: ConfigProvider.backgroundColor,
                          child: Text(
                            '${widget.exercise?.exerciseType}'.toUpperCase(),
                            style: TextStyleTemplates.defaultTextStyle(
                              ConfigProvider.mainTextColor,
                            ),
                          ),
                        ),
                ],
              ),
            if (widget.exercise != null)
              LabeledRow(
                label: 'Created At',
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    dateFormat.format(widget.exercise!.createdAt!),
                    style: TextStyleTemplates.defaultTextStyle(
                      ConfigProvider.mainTextColor,
                    ),
                  ),
                ],
              ),
            if (widget.exercise != null)
              LabeledRow(
                label: 'Updated At',
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    dateFormat.format(widget.exercise!.updatedAt!),
                    style: TextStyleTemplates.defaultTextStyle(
                      ConfigProvider.mainTextColor,
                    ),
                  ),
                ],
              ),
            ActionButton(
              label: widget.exercise == null ? "CREATE" : "UPDATE",
              onPressed: () {
                var isValid = _formKey.currentState!.validate();
                if (isValid) {
                  Navigator.of(context).pop(
                    CreateUpdateExerciseDto(
                      name: _nameController!.text,
                      description: _descriptionController!.text,
                      youtubeId: _youtubeIdController!.text,
                      muscleGroupId: muscleGroupSelection!.selectedValue,
                      exerciseType: exerciseTypeSelection!.selectedValue,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
