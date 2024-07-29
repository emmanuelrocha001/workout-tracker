import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../default_configs.dart';

class TextStyleTemplates {
  TextStyle xSmallTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: DefaultConfigs.xSmallFontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  TextStyle xSmallBoldTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: DefaultConfigs.xSmallFontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  TextStyle smallTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: DefaultConfigs.smallFontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  TextStyle smallBoldTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: DefaultConfigs.smallFontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  TextStyle defaultTextStyle(Color color, {double? size, FontWeight? weight}) {
    return GoogleFonts.poppins(
      fontSize: size ?? DefaultConfigs.defaultFontSize,
      fontWeight: weight ?? FontWeight.w500,
      color: color,
    );
  }

  TextStyle defaultBoldTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: DefaultConfigs.defaultFontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  TextStyle mediumTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: DefaultConfigs.mediumFontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  TextStyle mediumBoldTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: DefaultConfigs.mediumFontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  TextStyle largeTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: DefaultConfigs.largeFontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  TextStyle largeBoldTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: DefaultConfigs.largeFontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }
}
