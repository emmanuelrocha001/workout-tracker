import 'package:flutter/material.dart';
import '../../providers/config_provider.dart';
import '../general/text_style_templates.dart';

class DefaultTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final String? Function(String?)? validator;

  const DefaultTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.nextFocusNode,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction:
          nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (value) {
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
      validator: validator,
      cursorColor: ConfigProvider.mainColor,
      style: TextStyleTemplates.defaultTextStyle(
        ConfigProvider.mainTextColor,
      ),
      decoration: InputDecoration(
        hintStyle: TextStyleTemplates.defaultTextStyle(
          ConfigProvider.mainTextColor,
        ),
        fillColor: ConfigProvider.backgroundColorSolid,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ConfigProvider.mainColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ConfigProvider.slightContrastBackgroundColor,
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
      ),
    );
  }
}
