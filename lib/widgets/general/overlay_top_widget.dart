import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/config_provider.dart';
import '../helper.dart';

class OverlayContent extends StatelessWidget {
  final Widget content;
  final Widget overLayContent;
  final double padding;
  const OverlayContent(
      {super.key,
      required this.content,
      required this.overLayContent,
      this.padding = 60.0});

  @override
  Widget build(BuildContext context) {
    var topPadding = Helper.getTopPadding(context);
    return Center(
      child: SizedBox(
        width: Helper.getMaxContentWidth(context),
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: padding),
                child: content,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                // width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: topPadding),
                height: padding + topPadding,
                // padding:
                //     EdgeInsets.only(top: topPadding + configProvider.topPadding),
                decoration: const BoxDecoration(
                  color: ConfigProvider.backgroundColor,
                  border: Border(
                    bottom: BorderSide(
                      color: ConfigProvider.slightContrastBackgroundColor,
                      width: 1,
                    ),
                  ),
                ),
                child: overLayContent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
