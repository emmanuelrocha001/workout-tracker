import 'package:flutter/material.dart';

class ConfigProvider extends ChangeNotifier {
  ConfigProvider() {}

  double _topPadding = 0.0;
  double get topPadding => _topPadding;

  void setTopPadding(double topPadding) {
    if (topPadding > 0.0) _topPadding = topPadding;
  }

  static const decimalRegexPattern = r'^\d{0,4}$|^\d{0,4}\.{1}\d{0,2}$';
  static const digitRegexPattern = r'^\d{0,4}$';

  static const defaultDateStampFormat = 'MMM d, y hh:mm aaa';
  static const defaultShortenDateStampFormat = 'MMM d, y';
  static const defaultTimeFormat = 'hh:mm aaa';
  static const simpleDateFormat = 'EEE, MMM d';
  static const twoDigitFormat = '00';

  // COLORS -------------------------->
  static const mainTextColor = Color.fromARGB(255, 0, 0, 0);
  static const alternateTextColor = Color.fromARGB(255, 104, 104, 104);
  static const mainTextColorWithOpacityPercent = .75;
  // static const mainColor = Color.fromARGB(255, 255, 62, 62);
  static const mainColor = Color(0xff0F4C75);
  // static const mainColor = Color(0xff556E53);
  static const backgroundColorSolid = Colors.white;
  static const backgroundColor = Color.fromARGB(255, 246, 246, 246);
  static const slightContrastBackgroundColor =
      Color.fromARGB(255, 230, 230, 230);

  // SIZING -------------------------->
  static const maxContentWidth = 600.0;
  static const maxButtonSize = 200.0;
  static const double logoZize = 100.0;

  // FONT SIZE -------------------------->
  static const xSmallFontSize = 10.0;
  static const smallFontSize = 12.0;
  static const defaultFontSize = 14.0;
  static const mediumFontSize = 18.0;
  static const largeFontSize = 20.0;
  static const xLargeFontSize = 32.0;
  static const xxLargeFontSize = 64.0;
  static const defaultIconSize = 28.0;
  static const smallIconSize = 18.0;

  // SPACING
  static const defaultSpace = 8.0;
  static const mediumSpace = 16.0;
  static const largeSpace = 24.0;

  // text
  static const cancelInProgressWorkoutText =
      'Are you sure you want to cancel this workout? All progress will be lost.';

  static const cancelUpdateWorkoutText =
      'Are you sure you want to cancel workout update? All progress will be lost.';

  static const deleteWorkoutEntryText =
      'Are you sure you want to delete this workout entry? This action cannot be undone.';
}
