import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/config_provider.dart';
import './row_item.dart';
import './text_style_templates.dart';
import './default_text_field.dart';

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
              child: DefaultTextField(
                controller: _controller,
                focusNode: _focusNode,
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
