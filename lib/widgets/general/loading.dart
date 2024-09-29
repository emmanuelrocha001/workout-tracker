import 'package:flutter/material.dart';
// style
import '../../providers/config_provider.dart';

class Loading extends StatelessWidget {
  final Color? color;
  final Color? backgroundColor;
  const Loading({
    super.key,
    this.color,
    this.backgroundColor,
  });
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: backgroundColor != null
          ? backgroundColor?.withOpacity(.5)
          : Colors.white.withOpacity(.5),
      valueColor:
          AlwaysStoppedAnimation<Color>(color ?? ConfigProvider.mainColor),
      strokeWidth: 5,
    );
  }
}
