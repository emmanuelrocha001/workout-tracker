import 'package:flutter/material.dart';
import '../../providers/config_provider.dart';
import '../helper.dart';

class DefaultContainer extends StatelessWidget {
  final Widget child;
  final Function()? onTap;
  const DefaultContainer({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var content = onTap == null
        ? child
        : InkWell(
            onTap: onTap,
            child: child,
          );
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: ConfigProvider.defaultSpace / 2,
      ),
      color: ConfigProvider.backgroundColorSolid,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ConfigProvider.defaultSpace / 2),
      ),
      elevation: 0.0,
      child: SizedBox(
        width: Helper.getMaxContentWidth(context),
        child: Padding(
          padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
          child: content,
        ),
      ),
    );
  }
}
