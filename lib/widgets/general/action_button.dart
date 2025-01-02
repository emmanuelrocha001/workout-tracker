import 'package:flutter/material.dart';
import '../../providers/config_provider.dart';
import './text_style_templates.dart';

class ActionButton extends StatelessWidget {
  final Function()? onPressed;
  final String label;
  const ActionButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(ConfigProvider.mediumSpace),
        child: SizedBox(
          width: ConfigProvider.maxButtonWidth,
          height: ConfigProvider.defaultButtonHeight,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: ConfigProvider.mainColor,
            ),
            onPressed: onPressed,
            child: Text(
              label,
              style: TextStyleTemplates.smallBoldTextStyle(
                ConfigProvider.backgroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
