import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../providers/config_provider.dart';
import '../../models/filters_dto.dart';
import '../general/text_style_templates.dart';
import '../custom/DropDownMenuFormfield.dart';

class DefaultDropDownMenu extends StatelessWidget {
  final FiltersDto selection;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final Function(String) onSelected;
  final String? Function(String?)? validator;
  const DefaultDropDownMenu(
      {super.key,
      required this.selection,
      required this.onSelected,
      this.focusNode,
      this.nextFocusNode,
      this.validator});

  @override
  Widget build(BuildContext context) {
    print("building");
    print(selection.selectedValue);
    return DropdownMenuFormField<String>(
      validator: validator,
      initialSelection: selection.selectedValue,
      focusNode: focusNode,
      menuHeight: 250.0,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyleTemplates.defaultTextStyle(
          ConfigProvider.mainTextColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ConfigProvider.mainColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        errorStyle: TextStyleTemplates.smallTextStyle(
          Colors.red,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ConfigProvider.slightContrastBackgroundColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      textStyle: TextStyleTemplates.defaultTextStyle(
        ConfigProvider.mainTextColor,
      ),
      trailingIcon: const Icon(
        size: ConfigProvider.defaultIconSize,
        Icons.expand_more_rounded,
        color: ConfigProvider.mainColor,
      ),
      selectedTrailingIcon: const Icon(
        size: ConfigProvider.defaultIconSize,
        Icons.expand_less_rounded,
        color: ConfigProvider.mainColor,
      ),
      menuStyle: const MenuStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(
          ConfigProvider.backgroundColor,
        ),
      ),
      onSelected: (value) {
        if (value != null) {
          print("selected value: $value");
          onSelected(value);
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        }
      },
      dropdownMenuEntries: selection.filters.map((value) {
        if (selection.selectedValue == value.value) {
          print(
              "selected value: ${selection.selectedValue}. on building value: ${value.value}");
        }
        return DropdownMenuEntry<String>(
          label: value.displayValue,
          value: value.value,
          style: ButtonStyle(
            textStyle: WidgetStatePropertyAll<TextStyle>(
              TextStyleTemplates.defaultTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
