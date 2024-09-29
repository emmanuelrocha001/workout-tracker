import 'package:flutter/services.dart';
import '../../providers/config_provider.dart';
import '../../utility.dart';

class CustomNumberInputFormatter extends TextInputFormatter {
  final bool allowDecimals;
  CustomNumberInputFormatter({this.allowDecimals = false});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    RegExp pattern = RegExp(allowDecimals
        ? ConfigProvider.decimalRegexPattern
        : ConfigProvider.digitRegexPattern);

    if (pattern.hasMatch(newValue.text)) {
      print('from formatter ${newValue.text}');
      return TextEditingValue(
        text: newValue.text,
        selection: TextSelection.collapsed(offset: newValue.text.length),
      );
    }
    print('from formatter ${oldValue.text}');
    return oldValue;
  }
}
