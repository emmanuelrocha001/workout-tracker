import 'package:flutter/material.dart';
import '../../providers/config_provider.dart';
import '../general/text_style_templates.dart';

class DefaultTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  const DefaultTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction:
          nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
      onSubmitted: (value) {
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
      cursorColor: ConfigProvider.mainColor,
      style: TextStyleTemplates.defaultTextStyle(
        ConfigProvider.mainTextColor,
      ),
      decoration: InputDecoration(
        hintStyle: TextStyleTemplates.defaultTextStyle(
          ConfigProvider.mainTextColor,
        ),
        fillColor: ConfigProvider.backgroundColor,
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
      ),
    );
  }
}