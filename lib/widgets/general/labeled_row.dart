import 'package:flutter/material.dart';
import '../../providers/config_provider.dart';
import './text_style_templates.dart';
import './row_item.dart';

class LabeledRow extends StatelessWidget {
  static const double defaultLabelWidth = 100.0;
  final String label;
  final List<Widget> children;
  const LabeledRow({
    super.key,
    required this.label,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    // center left . set max label width

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RowItem(
          isCompact: true,
          minWidth: defaultLabelWidth,
          maxWidth: defaultLabelWidth,
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
