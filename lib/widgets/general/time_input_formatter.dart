import 'package:flutter/services.dart';

/// Custom input formatter for time (hh:mm:ss).
/// Note, this formatter does not validate the time input. For example, 25:61:61 would be a valid formatted value.
class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Remove any non-numeric characters
    var newDigitsOnly = text.replaceAll(RegExp(r'\D'), '');

    if (newDigitsOnly.length > 5) {
      return oldValue;
    }

    String formatted = '';

    for (int i = 0; i < newDigitsOnly.length; i++) {
      if (i == 2 || i == 4) {
        formatted = ':$formatted';
      }
      formatted = newDigitsOnly[newDigitsOnly.length - 1 - i] + formatted;
    }
    // TODO is it worth validating time input. e.g. 25:61:61
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Pads the time input with zeros for format hh:mm:ss. For example, 22:23 would be formatted to 0:22:23.
  static String? padFormattedTimeInput(String? formattedTime) {
    if (formattedTime == null) {
      return formattedTime;
    }
    final digitsOnly = formattedTime.replaceAll(RegExp(r'\D'), '');
    var formatted = digitsOnly.padLeft(6, '0');
    return '${formatted.substring(0, 2)}:${formatted.substring(2, 4)}:${formatted.substring(4, 6)}';
  }
}
