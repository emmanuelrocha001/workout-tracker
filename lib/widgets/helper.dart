import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../providers/config_provider.dart';

import './general/text_style_templates.dart';

class Helper {
  static double getTopPadding(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: false);
    var mediaQueryTopPadding = MediaQuery.of(context).padding.top;
    // update if value differs and is non-zero
    if (mediaQueryTopPadding != 0.0 &&
        mediaQueryTopPadding != configProvider.topPadding) {
      configProvider.setTopPadding(mediaQueryTopPadding);
    }
    return configProvider.topPadding;
  }

  static double getMaxContentWidth(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return width <= ConfigProvider.maxContentWidth
        ? width
        : ConfigProvider.maxContentWidth;
  }

  static void navigateToYoutube({
    String? youtubeId,
    String? searchQuery,
  }) async {
    if (youtubeId == null && searchQuery == null) return;
    var baseUrl = "https://www.youtube.com";

    var url = (youtubeId?.isNotEmpty ?? false)
        ? "$baseUrl/watch?v=$youtubeId"
        : "$baseUrl/results?search_query=${Uri.encodeComponent(searchQuery!)}";

    await launchUrlString(url, mode: LaunchMode.externalApplication);
  }

  static Future<dynamic> showPopUp({
    required BuildContext context,
    required String title,
    required Widget content,
    bool hasPadding = true,
  }) async {
    final mediaQuery = MediaQuery.of(context);
    return await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: ConfigProvider.backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              ConfigProvider.defaultSpace,
            ),
            topRight: Radius.circular(
              ConfigProvider.defaultSpace,
            ),
          ),
        ),
        builder: (ctx) {
          return SizedBox(
            height:
                (mediaQuery.size.height - Helper.getTopPadding(context)) * 1,
            // padding: hasPadding ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
            child: SafeArea(
              bottom: true,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: ConfigProvider.backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ConfigProvider.defaultSpace),
                        topRight: Radius.circular(ConfigProvider.defaultSpace),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // DefaultTextIconButton(onPressed: () {}),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: 50.0,
                            margin: const EdgeInsets.only(
                              top: ConfigProvider.defaultSpace / 2,
                            ),
                            height: ConfigProvider.defaultSpace * .75,
                            decoration: const BoxDecoration(
                              color:
                                  ConfigProvider.slightContrastBackgroundColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(ConfigProvider.defaultSpace),
                              ),
                            ),
                          ),
                        ),
                        // const Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              // color: ConfigProvider.backgroundColor,
                              color: ConfigProvider.mainColor,
                              size: ConfigProvider.defaultIconSize,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: ConfigProvider.backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: ConfigProvider.defaultSpace),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          title,
                          style: TextStyleTemplates.largeBoldTextStyle(
                            ConfigProvider.mainTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: hasPadding
                        ? const EdgeInsets.all(ConfigProvider.defaultSpace)
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
