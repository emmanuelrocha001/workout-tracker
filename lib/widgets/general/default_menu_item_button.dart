import 'package:flutter/material.dart';
import '../../providers/config_provider.dart';
import './text_style_templates.dart';

class DefaultMenuItemButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String? label;
  final Color? labelColor;
  final bool showBorder;
  final Function()? onPressed;

  const DefaultMenuItemButton({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor,
    this.labelColor,
    this.onPressed,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Icon(
      icon,
      color: iconColor ?? ConfigProvider.mainColor,
    );

    if (label != null) {
      content = Row(
        children: [
          content,
          Padding(
            padding: const EdgeInsets.all(ConfigProvider.defaultSpace / 2),
            child: Text(
              label!,
              style: TextStyleTemplates.smallBoldTextStyle(
                labelColor ?? ConfigProvider.mainTextColor,
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(
                bottom: BorderSide(
                  width: 1,
                  color: ConfigProvider.backgroundColor,
                ),
              )
            : null,
      ),
      child: MenuItemButton(
        onPressed: onPressed,
        child: content,
      ),
    );
  }
}
