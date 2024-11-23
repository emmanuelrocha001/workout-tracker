import 'package:flutter/material.dart';
import '../../providers/config_provider.dart';

class RowItem extends StatelessWidget {
  final Widget child;
  final bool isCompact;
  final double minWidth;
  final double? maxWidth;
  final Alignment alignment;
  final bool hasCompactPadding;

  const RowItem({
    super.key,
    required this.child,
    this.isCompact = false,
    this.hasCompactPadding = false,
    this.alignment = Alignment.center,
    this.minWidth = 50.0,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return isCompact
        ? Padding(
            padding: const EdgeInsets.only(top: 1),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: minWidth,
                maxWidth: maxWidth ?? double.infinity,
              ),
              child: Align(
                alignment: alignment,
                child: child,
              ),
            ),
          )
        : Expanded(
            flex: 1,
            child: Align(
              alignment: alignment,
              child: Padding(
                padding: hasCompactPadding
                    ? const EdgeInsets.only(top: 1)
                    : const EdgeInsets.all(ConfigProvider.defaultSpace / 2),
                child: child,
              ),
            ),
          );
  }
}
