import 'package:flutter/material.dart';
import 'package:workout_tracker/providers/config_provider.dart';

class PillContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? height;
  final Color? outlineColor;
  const PillContainer({
    super.key,
    required this.child,
    this.color,
    this.height,
    this.outlineColor,
  });

  @override
  Widget build(BuildContext context) {
    var content = Container(
      // alignment: Alignment.center,
      height: height,
      padding: const EdgeInsets.all(ConfigProvider.defaultSpace / 2),
      decoration: BoxDecoration(
        color: color ??
            (outlineColor != null
                ? outlineColor!.withOpacity(.1)
                : Colors.grey.shade100),
        borderRadius: BorderRadius.circular(ConfigProvider.defaultSpace / 2),
        border: outlineColor != null
            ? Border.all(
                color: outlineColor!,
                width: 2,
              )
            : null,
      ),
      child: child,
    );

    return color == null && outlineColor != null
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                ConfigProvider.defaultSpace / 2,
              ),
            ),
            child: content,
          )
        : content;
  }
}
