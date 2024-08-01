import 'package:flutter/material.dart';
import '../providers/config_provider.dart';
// widgets
import '../widgets/general/loading.dart';
import '../widgets/general/text_style_templates.dart';

class SplashScreen extends StatelessWidget {
  final bool renderWithScaffold;
  const SplashScreen({
    super.key,
    this.renderWithScaffold = false,
  });
  @override
  Widget build(BuildContext context) {
    const size = 100.0;
    var mediaQuery = MediaQuery.of(context);
    var textTemplates = TextStyleTemplates();
    var content = Container(
      height: mediaQuery.size.height,
      width: mediaQuery.size.width,
      color: ConfigProvider.backgroundColor,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
              alignment: Alignment.center,
              height: size,
              width: size,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(
                  //   Icons.fitness_center,
                  //   size: size / 4,
                  //   color: ConfigProvider.mainColor,
                  // ),
                  Text(
                    'eRP',
                    style: textTemplates.largeBoldTextStyle(
                      ConfigProvider.mainColor,
                    ),
                  ),
                ],
              ),
              // child: Image.asset(
              //   ConfigProvider.logoImagePath,
              //   fit: BoxFit.contain,
              //   width: ConfigProvider.logoSize,
              //   height: ConfigProvider.logoSize,
              // ),
            ),
            Container(width: size, height: size, child: Loading()),
          ],
        ),
      ),
    );
    return !renderWithScaffold
        ? content
        : Scaffold(
            // backgroundColor: ConfigProvider.LEAFY_GREEN,
            body: content,
          );
  }
}