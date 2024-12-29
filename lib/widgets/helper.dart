import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:another_flushbar/flushbar.dart';
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
    String? youtubeId,
    String? searchQuery,
  }) async {
    if (youtubeId == null && searchQuery == null) return;
    var baseUrl = "https://www.youtube.com";

    var url = (youtubeId?.isNotEmpty ?? false)
        ? "$baseUrl/watch?v=$youtubeId"
        : "$baseUrl/results?search_query=${Uri.encodeComponent(searchQuery!)}";

    await launchUrlString(url, mode: LaunchMode.externalNonBrowserApplication);
  }

  static void navigateToUrl({required String url}) async {
    await launchUrlString(url, mode: LaunchMode.externalNonBrowserApplication);
  }

  static Future<dynamic> showPopUp({
    required BuildContext context,
    required String title,
    required Widget content,
    bool hasPadding = true,
    double heightPercentage = .95,
    double? specificHeight,
  }) async {
    final mediaQuery = MediaQuery.of(context);
    print('specified height: $specificHeight');
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
                      color: ConfigProvider.backgroundColorSolid,
                      child: Padding(
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
    required String cancelButtonLabel,
    required Color cancelButtonColor,
    bool hasPadding = true,
  }) async {
    var response = await showDialog<bool?>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
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
              borderRadius: BorderRadius.circular(ConfigProvider.defaultSpace),
            ),
            actions: <Widget>[
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
      barrierColor: Colors.black.withOpacity(0.1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            timePickerTheme: TimePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(ConfigProvider.defaultSpace / 2),
              ),
              dialHandColor: ConfigProvider.mainColor,
              backgroundColor: ConfigProvider.backgroundColorSolid,
              dialBackgroundColor: ConfigProvider.backgroundColor,
              helpTextStyle: TextStyleTemplates.defaultBoldTextStyle(
                ConfigProvider.mainTextColor,
              ),
              dialTextStyle: TextStyleTemplates.defaultBoldTextStyle(
                ConfigProvider.mainTextColor,
              ),
              cancelButtonStyle: TextButton.styleFrom(
                backgroundColor: ConfigProvider.backgroundColor,
                foregroundColor: Colors.black,
                textStyle: TextStyleTemplates.smallBoldTextStyle(
                  Colors.black,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(ConfigProvider.defaultSpace / 2)),
                ),
              ),
              confirmButtonStyle: TextButton.styleFrom(
                backgroundColor: ConfigProvider.backgroundColor,
                foregroundColor: ConfigProvider.mainColor,
                textStyle: TextStyleTemplates.smallBoldTextStyle(
                  ConfigProvider.mainColor,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(ConfigProvider.defaultSpace / 2)),
                ),
              ),
              hourMinuteTextStyle: TextStyleTemplates.xxLargeTextStyle(
                ConfigProvider.mainTextColor,
              ),
              hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? Colors.white
                      : Colors.black),
              hourMinuteColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? ConfigProvider.mainColor
                      : Colors.white),
              dayPeriodTextStyle: TextStyleTemplates.defaultBoldTextStyle(
                  ConfigProvider.mainTextColor),
              dayPeriodTextColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? Colors.white
                      : Colors.black), // Set the text color for AM/PM toggle
              dayPeriodColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? ConfigProvider.mainColor
                      : Colors.white),
              dayPeriodBorderSide: const BorderSide(
                color: ConfigProvider.mainColor,
                width: 4,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
