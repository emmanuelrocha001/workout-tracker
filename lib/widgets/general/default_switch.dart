import 'package:flutter/material.dart';
import '../../providers/config_provider.dart';

class DefaultSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;
  const DefaultSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: ConfigProvider.mainColor,
      inactiveThumbColor: ConfigProvider.backgroundColor,
      trackColor: WidgetStatePropertyAll(
        value
            ? ConfigProvider.mainColor.withOpacity(0.5)
            : ConfigProvider.slightContrastBackgroundColor,
      ),
      trackOutlineColor: WidgetStatePropertyAll(
        value ? ConfigProvider.mainColor : ConfigProvider.mainTextColor,
      ),
      thumbIcon: WidgetStatePropertyAll(
        Icon(
          value ? Icons.check : Icons.close,
          color: value
              ? ConfigProvider.backgroundColor
              : ConfigProvider.mainTextColor,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
