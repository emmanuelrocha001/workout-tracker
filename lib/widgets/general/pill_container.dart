import 'package:flutter/material.dart';

class PillContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  const PillContainer({super.key, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}
