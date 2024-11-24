import 'package:flutter/material.dart';
import '../../providers/config_provider.dart';
import './text_style_templates.dart';
import './row_item.dart';

class LabeledRow extends StatelessWidget {
  static const double defaultLabelWidth = 100.0;
  final String label;
  final double labelWidth;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  const LabeledRow({
    super.key,
    required this.label,
    required this.children,
    this.labelWidth = defaultLabelWidth,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    // center left . set max label width

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
    );
  }
}
