import 'package:flutter/material.dart';
import '../../providers/config_provider.dart';

class RowItem extends StatelessWidget {
  final Widget child;
  final bool isCompact;
  final double minWidth;

  const RowItem(
      {super.key,
      required this.child,
      this.isCompact = false,
      this.minWidth = 50.0});

  @override
  Widget build(BuildContext context) {
    return isCompact
        ? Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: minWidth,
                ),
                child: child,
              ),
            ),
          )
        : Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(ConfigProvider.defaultSpace / 2),
                child: child,
              ),
            ),
          );
  }
}
