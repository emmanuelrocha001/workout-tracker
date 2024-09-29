import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/config_provider.dart';

class TextStyleTemplates {
  static TextStyle xSmallTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.xSmallFontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle xSmallBoldTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.xSmallFontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle smallTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.smallFontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle smallBoldTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.smallFontSize,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle defaultTextStyle(Color color,
      {double? size, FontWeight? weight}) {
    return GoogleFonts.poppins(
      fontSize: size ?? ConfigProvider.defaultFontSize,
      fontWeight: weight ?? FontWeight.w500,
      color: color,
    );
  }

  static TextStyle defaultBoldTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.defaultFontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle mediumTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.mediumFontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle mediumBoldTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.mediumFontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle largeTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.largeFontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle largeBoldTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.largeFontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }
}
