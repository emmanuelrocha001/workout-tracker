import 'package:flutter/material.dart';
import 'dart:convert';
import './providers/config_provider.dart';

class Utility {
  static Object getDeepCopy(Object object) {
    try {
      return jsonDecode(jsonEncode(object));
    } catch (e, s) {
      print(e);
      return object;
    }
  }

  static Color getTextColorBasedOnBackground({Color? backgroundColor}) {
    return _isDarkEnoughForWhiteText(
            backgroundColor ?? ConfigProvider.mainColor)
        ? Colors.white
        : Colors.black;
  }

  static bool _isDarkEnoughForWhiteText(Color backgroundColor) {
    // Calculate the relative luminance of the background color
    double luminance = backgroundColor.computeLuminance();
    // print(
    //     '${backgroundColor.alpha},${backgroundColor.red},${backgroundColor.green},${backgroundColor.blue}');
    // print('luminance: $luminance');

    // Luminance of white text
    double luminanceWhite = 1.0; // Maximum luminance

    // Calculate contrast ratio
    double contrastRatio = (luminance + 0.05) / (luminanceWhite + 0.05);
    // print('contrast ratio: $contrastRatio');
    // Check if the contrast ratio is at least 4.5:1
    return contrastRatio < (1 - (1 / 4.5));
  }

  static MaterialColor createMaterialColor(Color color) {
    final Map<int, Color> shades = {
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1.0),
    };
    return MaterialColor(color.value, shades);
  }
}
