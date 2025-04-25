import 'package:flutter/material.dart';
import '../providers/config_provider.dart';
// widgets
import '../widgets/general/loading.dart';
import '../widgets/general/text_style_templates.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    const size = 100.0;
    return Scaffold(
      backgroundColor: ConfigProvider.backgroundColorSolid,
      body: Center(
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
                      'RepPal',
                      style: TextStyleTemplates.largeBoldTextStyle(
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
              const SizedBox(width: size, height: size, child: Loading()),
            ],
          ),
        ),
      ),
    );
  }
}
