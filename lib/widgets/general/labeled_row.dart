import 'package:flutter/material.dart';
import '../../providers/config_provider.dart';
import './text_style_templates.dart';
import './row_item.dart';
import './default_tooltip.dart';

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
              if (tooltip != null) DefaultTooltip(message: tooltip!),
            ],
          ),
        if (!isSideLabel)
          const Padding(
            padding: EdgeInsets.all(ConfigProvider.defaultSpace / 2),
            child: Divider(
              height: ConfigProvider.defaultSpace / 2,
              color: ConfigProvider.backgroundColor,
              // thickness: 1.0,
            ),
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
