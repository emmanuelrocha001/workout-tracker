import 'package:flutter/material.dart';

import '../../providers/config_provider.dart';
import '../general/text_style_templates.dart';
import '../../utility.dart';

class OverlayActionButton extends StatelessWidget {
  final Widget content;
  final bool showActionButton;
  final String label;
  final Function() onPressed;

  const OverlayActionButton({
    super.key,
    required this.content,
    required this.showActionButton,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        content,
        if (showActionButton)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: ConfigProvider.largeSpace * 2,
              color: Colors.black.withOpacity(.1),
              child: Center(
                child: SizedBox(
                  width: ConfigProvider.maxButtonWidth,
                  child: TextButton(
                    onPressed: onPressed,
                    style: TextButton.styleFrom(
                      backgroundColor: ConfigProvider.mainColor,
                    ),
                    child: Text(
                      label,
                      style: TextStyleTemplates.smallBoldTextStyle(
                        Utility.getTextColorBasedOnBackground(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
