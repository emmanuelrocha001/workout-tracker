import 'package:flutter/material.dart';
import '../../providers/config_provider.dart';
import './text_style_templates.dart';
import './row_item.dart';

class LabeledRow extends StatelessWidget {
  static const double defaultLabelWidth = 100.0;
  final String label;
  final String? tooltip;
  final double labelWidth;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final bool isSideLabel;
  const LabeledRow({
    super.key,
    required this.label,
    required this.children,
    this.isSideLabel = false,
    this.labelWidth = defaultLabelWidth,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    // center left . set max label width

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSideLabel)
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
                child: Text(
                  label,
                  style: TextStyleTemplates.defaultBoldTextStyle(
                    ConfigProvider.mainTextColor,
                  ),
                ),
              ),
              if (tooltip != null)
                Tooltip(
                  message: tooltip!,
                  triggerMode: TooltipTriggerMode.tap,
                  textStyle: TextStyleTemplates.smallTextStyle(
                      ConfigProvider.backgroundColor),
                  enableFeedback: true,
                  showDuration: const Duration(seconds: 10),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: ConfigProvider.mainColor,
                    size: ConfigProvider.mediumIconSize,
                  ),
                ),
            ],
          ),
        Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isSideLabel)
              RowItem(
                isCompact: true,
                minWidth: labelWidth,
                maxWidth: labelWidth,
                alignment: Alignment.centerLeft,
                child: Text(
                  overflow: TextOverflow.fade,
                  label,
                  style: TextStyleTemplates.defaultBoldTextStyle(
                    ConfigProvider.mainTextColor,
                  ),
                ),
              ),
            const SizedBox(
              width: ConfigProvider.defaultSpace,
            ),
            ...children
          ],
        ),
      ],
    );
  }
}
