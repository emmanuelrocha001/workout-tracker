import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import './providers/config_provider.dart';
import 'package:uuid/uuid.dart';
import './models/aux_models.dart';

class Utility {
  static String getElapsedTimeString({
    required TimeDiff timeDiff,
    bool includeTimeUnits = false,
    bool includeHours = true,
  }) {
    var formatter = NumberFormat(ConfigProvider.twoDigitFormat);
    var hoursString = includeHours
        ? "${formatter.format(timeDiff.hours)}${includeTimeUnits ? "h" : ""}:"
        : "";
    return '${timeDiff.isNegativeTimeDiff ? "-" : ""} $hoursString${formatter.format(timeDiff.minutes)}${includeTimeUnits ? "m" : ""}:${formatter.format(timeDiff.seconds)}${includeTimeUnits ? "s" : ""}';
  }

  static TimeDiff getTimeDifference({
    required DateTime startTime,
    required DateTime endTime,
  }) {
    var totalSeconds = 0;
    var isStartTimeBeforeEndTime = startTime.isBefore(endTime);
    if (isStartTimeBeforeEndTime) {
      totalSeconds = endTime.difference(startTime).inSeconds;
    } else {
      totalSeconds = startTime.difference(endTime).inSeconds;
    }

    return getTimeDifferenceAsTimeDiff(totalSeconds, !isStartTimeBeforeEndTime);
  }

  static TimeDiff getTimeDifferenceAsTimeDiff(
    int totalSeconds,
    bool isNegativeTimeDiff,
  ) {
    const secondsInDay = 60 * 60 * 24;
    var days = (totalSeconds / (secondsInDay)).floor();
    totalSeconds -= (days * secondsInDay);

    const secondsInHour = 60 * 60;
    var hours = (totalSeconds / (secondsInHour)).floor();
    totalSeconds -= (hours * secondsInHour);

    const secondsInMinute = 60;
    var minutes = (totalSeconds / (secondsInMinute)).floor();
    totalSeconds -= (minutes * secondsInMinute);

    var seconds = totalSeconds;

    return TimeDiff(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      isNegativeTimeDiff: isNegativeTimeDiff,
    );
  }

  static generateId() {
    return const Uuid().v4();
  }

  static formatNumberInput(String value) {
    if (value.isEmpty) {
      return '0';
    }

    var parsedValue = double.parse(value);
    return parsedValue
        .toStringAsFixed(parsedValue.truncateToDouble() == parsedValue ? 0 : 2);
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
