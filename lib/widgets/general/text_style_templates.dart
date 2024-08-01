import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/config_provider.dart';

class TextStyleTemplates {
  TextStyle xSmallTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.xSmallFontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  TextStyle xSmallBoldTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.xSmallFontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  TextStyle smallTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.smallFontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  TextStyle smallBoldTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.smallFontSize,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  TextStyle defaultTextStyle(Color color, {double? size, FontWeight? weight}) {
    return GoogleFonts.poppins(
      fontSize: size ?? ConfigProvider.defaultFontSize,
      fontWeight: weight ?? FontWeight.w500,
      color: color,
    );
  }

  TextStyle defaultBoldTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.defaultFontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  TextStyle mediumTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.mediumFontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  TextStyle mediumBoldTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.mediumFontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  TextStyle largeTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.largeFontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  TextStyle largeBoldTextStyle(Color color) {
    return GoogleFonts.poppins(
      fontSize: ConfigProvider.largeFontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }
}
