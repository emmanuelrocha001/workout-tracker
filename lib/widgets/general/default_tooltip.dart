import 'package:flutter/material.dart';
import './text_style_templates.dart';
import '../../providers/config_provider.dart';

class DefaultTooltip extends StatelessWidget {
  final String message;
  const DefaultTooltip({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      triggerMode: TooltipTriggerMode.tap,
      textStyle:
          TextStyleTemplates.smallTextStyle(ConfigProvider.backgroundColor),
      enableFeedback: true,
      showDuration: const Duration(seconds: 15),
      child: const Icon(
        Icons.info_outline_rounded,
        color: ConfigProvider.mainColor,
        size: ConfigProvider.mediumIconSize,
      ),
    );
  }
}
