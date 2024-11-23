import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/config_provider.dart';
import './row_item.dart';
import './text_style_templates.dart';

class EditTextFieldForm extends StatefulWidget {
  final String initialValue;
  const EditTextFieldForm({
    super.key,
    required this.initialValue,
  });

  @override
  State<EditTextFieldForm> createState() => _EditTextFieldFormState();
}

class _EditTextFieldFormState extends State<EditTextFieldForm> {
  TextEditingController? _controller;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      // Automatically request focus
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: ConfigProvider.defaultSpace,
            ),
            RowItem(
              isCompact: false,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: TextStyleTemplates.defaultTextStyle(
                  ConfigProvider.mainTextColor,
                ),
                decoration: InputDecoration(
                  hintStyle: TextStyleTemplates.defaultTextStyle(
                    ConfigProvider.mainTextColor,
                  ),
                  fillColor: ConfigProvider.backgroundColor,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ConfigProvider.mainColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ConfigProvider.slightContrastBackgroundColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            RowItem(
              isCompact: true,
              child: IconButton(
                icon: const Icon(Icons.check_rounded,
                    size: ConfigProvider.smallIconSize, color: Colors.green),
                onPressed: () {
                  Navigator.of(context).pop(_controller?.text);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
