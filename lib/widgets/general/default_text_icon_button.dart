import 'package:flutter/material.dart';

class DefaultTextIconButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  const DefaultTextIconButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return TextButton.icon(
      onPressed: () {
        onPressed();
      },
      icon: const Icon(
        Icons.add,
      ),
      label: Text(
        text,
        style: theme.textTheme.labelLarge,
      ),
      style: theme.textButtonTheme.style,
    );
  }
}
