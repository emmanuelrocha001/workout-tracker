import 'package:flutter/material.dart';
import 'package:workout_tracker/default_configs.dart';
import 'package:workout_tracker/utility.dart';

import './general/text_style_templates.dart';

class Helper {
  static Future<dynamic> showPopUp({
    required BuildContext context,
    required String title,
    required Widget content,
    bool hasPadding = true,
  }) async {
    var textTemplates = TextStyleTemplates();
    final mediaQuery = MediaQuery.of(context);
    return await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: DefaultConfigs.backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              DefaultConfigs.defaultSpace,
            ),
            topRight: Radius.circular(
              DefaultConfigs.defaultSpace,
            ),
          ),
        ),
        builder: (ctx) {
          return Container(
            height: (mediaQuery.size.height - mediaQuery.padding.top) * .9,
            // padding: hasPadding ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
            child: SafeArea(
              bottom: true,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      // color: DefaultConfigs.mainColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(DefaultConfigs.defaultSpace),
                        topRight: Radius.circular(DefaultConfigs.defaultSpace),
                      ),
                    ),
                    child: Row(
                      children: [
                        // DefaultTextIconButton(onPressed: () {}),
                        Spacer(),
                        Container(
                          margin: const EdgeInsets.all(
                            DefaultConfigs.defaultSpace,
                          ),
                          decoration: const BoxDecoration(
                            // color: DefaultConfigs.mainColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              // color: DefaultConfigs.backgroundColor,
                              color: DefaultConfigs.mainColor,
                              size: DefaultConfigs.defaultIconSize,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        title,
                        style: textTemplates.largeBoldTextStyle(
                          DefaultConfigs.mainTextColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: hasPadding
                        ? const EdgeInsets.all(8.0)
                        : EdgeInsets.zero,
                    child: content,
                  )),
                ],
              ),
            ),
          );
        });
  }

  // static Future<dynamic> showMyDialog({
  //   required BuildContext context,
  //   required Widget content,
  // }) async {
  //   var _theme = Theme.of(context);
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.white,
  //         surfaceTintColor: Colors.white,
  //         shadowColor: Colors.white,
  //         shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.zero,
  //         ),
  //         title: Column(
  //           children: [
  //             Row(
  //               children: [
  //                 DefaultTextIconButton(onPressed: () {}),
  //                 const Spacer(),
  //                 IconButton(
  //                   icon: const Icon(Icons.close),
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //               ],
  //             ),
  //             const Align(
  //               alignment: Alignment.topLeft,
  //               child: Text(
  //                 'Excercise',
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ),
  //             const Padding(padding: EdgeInsets.all(8.0)),
  //             const SearchForm(),
  //           ],
  //         ),
  //         content: SizedBox(
  //           width: 600,
  //           height: 600,
  //           child: content,
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Approve'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
