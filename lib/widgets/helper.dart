import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:url_launcher/url_launcher_string.dart';

import 'package:another_flushbar/flushbar.dart';
import '../providers/config_provider.dart';

import './general/text_style_templates.dart';

class Helper {
  static Future<String> getClipboardText() async {
    final data = await Clipboard.getData('text/plain');
    if (data != null && data.text != null) {
      return data.text!;
    } else {
      return "";
    }
  }

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

  static double getMaxContentWidth(
    BuildContext context, {
    double? maxContentWidthOverride,
  }) {
    var width = MediaQuery.of(context).size.width;
    var maxContentWidth =
        maxContentWidthOverride ?? ConfigProvider.maxContentWidth;
    return width <= maxContentWidth ? width : maxContentWidth;
  }

  static void navigateToYoutube({
    required BuildContext context,
    String? youtubeId,
    String? searchQuery,
  }) async {
    if (youtubeId == null && searchQuery == null) return;
    var baseUrl = "www.youtube.com";

    var url = (youtubeId?.isNotEmpty ?? false)
        ? "$baseUrl/watch?v=$youtubeId"
        : "$baseUrl/results?search_query=${Uri.encodeComponent(searchQuery!)}";

    var configProvider = Provider.of<ConfigProvider>(context, listen: false);
    var isMobileWeb = configProvider.isWebMobile;

    if (!isMobileWeb) {
      await launchUrlString(
        'https://$url',
        mode: LaunchMode.externalNonBrowserApplication,
      );
    } else {
      html.window.open('youtube://$url', "_self");
    }
  }

  static void navigateToUrl({required String url}) async {
    await launchUrlString(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }

  static Future<dynamic> showPopUp({
    required BuildContext context,
    required String title,
    required Widget content,
    String? subTitle,
    bool hasPadding = true,
    double heightPercentage = .95,
    double? specificHeight,
    bool isDismissible = true,
  }) async {
    final mediaQuery = MediaQuery.of(context);
    print('specified height: $specificHeight');
    print('isDismissible: $isDismissible');
    return await showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: ConfigProvider.backgroundColorSolid,
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
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: SizedBox(
              height: specificHeight ??
                  (mediaQuery.size.height - Helper.getTopPadding(context)) *
                      heightPercentage,
              // padding: hasPadding ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
              child: SafeArea(
                bottom: true,
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: ConfigProvider.backgroundColorSolid,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ConfigProvider.defaultSpace),
                          topRight:
                              Radius.circular(ConfigProvider.defaultSpace),
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
                              height: ConfigProvider.defaultSpace / 2,
                              decoration: const BoxDecoration(
                                color: ConfigProvider
                                    .slightContrastBackgroundColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(ConfigProvider.defaultSpace),
                                ),
                              ),
                            ),
                          ),
                          // const Spacer(),
                          if (isDismissible)
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: ConfigProvider.defaultSpace),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          title,
                          style: TextStyleTemplates.mediumBoldTextStyle(
                            ConfigProvider.mainTextColor,
                          ),
                        ),
                      ),
                    ),
                    if (subTitle != null && subTitle.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: ConfigProvider.defaultSpace),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            subTitle,
                            style: TextStyleTemplates.defaultTextStyle(
                              ConfigProvider.alternateTextColor,
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
            ),
          );
        });
  }

  static void showMessageBar({
    required BuildContext context,
    required String message,
    String? title,
    bool isError = false,
  }) async {
    if (!context.mounted) return;

    Flushbar(
      maxWidth: getMaxContentWidth(context),
      title: title,
      messageText: Text(
        message,
        style: TextStyleTemplates.defaultTextStyle(
          ConfigProvider.backgroundColor,
        ),
      ),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 500),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: (isError ? Colors.red : Colors.green),
      // borderColor: isError ? Colors.red : Colors.green,
      borderRadius: BorderRadius.circular(ConfigProvider.defaultSpace),
      // borderWidth: 2.0,
      margin: const EdgeInsets.all(ConfigProvider.defaultSpace),
    ).show(context);
  }

  static Future<bool?> showConfirmationDialogForm({
    required BuildContext context,
    required String message,
    required String confimationButtonLabel,
    required Color confirmationButtonColor,
    String? cancelButtonLabel,
    Color? cancelButtonColor,
    bool barrierDismissible = true,
    bool hasPadding = true,
  }) async {
    var response = await showDialog<bool?>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            contentPadding: const EdgeInsets.only(
              top: ConfigProvider.defaultSpace * 2,
              left: ConfigProvider.defaultSpace * 2,
              right: ConfigProvider.defaultSpace * 2,
            ),
            content: SizedBox(
              width: getMaxContentWidth(context, maxContentWidthOverride: 400),
              child: Text(
                message,
                style: TextStyleTemplates.defaultTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
            ),
            backgroundColor: ConfigProvider.backgroundColorSolid,
            actionsAlignment: MainAxisAlignment.end,
            actionsOverflowButtonSpacing: ConfigProvider.defaultSpace,
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(ConfigProvider.defaultSpace / 2),
            ),
            actionsPadding: const EdgeInsets.only(
              bottom: ConfigProvider.defaultSpace * 2,
              top: ConfigProvider.defaultSpace,
              left: ConfigProvider.defaultSpace * 2,
              right: ConfigProvider.defaultSpace * 2,
            ),
            actions: <Widget>[
              if (cancelButtonLabel != null && cancelButtonColor != null)
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: cancelButtonColor,
                  ),
                  child: Text(
                    cancelButtonLabel,
                    style: TextStyleTemplates.smallBoldTextStyle(
                      ConfigProvider.mainTextColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: confirmationButtonColor,
                ),
                child: Text(
                  confimationButtonLabel,
                  style: TextStyleTemplates.smallBoldTextStyle(
                    ConfigProvider.backgroundColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });

    return response;
  }

  static Future<dynamic> showDialogForm({
    required BuildContext context,
    required Widget content,
    bool hasPadding = true,
    bool barrierDismissible = true,
    double? maxContentWidthOverride = 400,
  }) async {
    return await showDialog<dynamic>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext alertDialogContext) {
          return AlertDialog(
            scrollable: true,
            content: SizedBox(
              width: getMaxContentWidth(
                context,
                maxContentWidthOverride: maxContentWidthOverride,
              ),
              child: content,
            ),
            backgroundColor: ConfigProvider.backgroundColorSolid,
            actionsAlignment: MainAxisAlignment.center,
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ConfigProvider.defaultSpace),
            ),
            // buttonPadding: const EdgeInsets.all(ConfigProvider.defaultSpace),
          );
        });
  }

  static Future<TimeOfDay?> showTimePickerDefault({
    required BuildContext context,
    required TimeOfDay initialTime,
    String prompt = "SELECT TIME",
  }) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.dialOnly,
      helpText: prompt,
      cancelText: "CANCEL",
      confirmText: "OK",
    );
  }

  static Future<DateTime?> showDatePickerDefault({
    required BuildContext context,
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String prompt = "SELECT DATE",
  }) async {
    // allow to set
    firstDate ??= DateTime(ConfigProvider.earliestAllowedWorkoutYear, 1, 1);
    // allow 1 month in future
    lastDate ??= DateTime.now().add(const Duration(days: 30));
    return await showDatePicker(
      helpText: prompt,
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      cancelText: "CANCEL",
      confirmText: "OK",
    );
  }
}
