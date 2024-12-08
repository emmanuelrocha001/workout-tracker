import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../general/overlay_content.dart';
import '../general/labeled_row.dart';
import '../general/row_item.dart';
import '../general/overlay_content.dart';
import '../general/default_tooltip.dart';
import '../general/edit_text_field_form.dart';
import '../general/text_style_templates.dart';
import '../../providers/config_provider.dart';

import '../helper.dart';
import '../../utility.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  final double labelSize = 100.0;

  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(
      context,
    );
    return OverlayContent(
      overLayContent: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(ConfigProvider.defaultSpace),
            child: Text(
              "Preferences",
              style: TextStyleTemplates.mediumBoldTextStyle(
                  ConfigProvider.mainTextColor),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: ConfigProvider.defaultSpace),
            child: DefaultTooltip(
              message: ConfigProvider.preferencesPageToolTip,
            ),
          ),
          const Spacer(),
        ],
      ),
      content: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              ConfigProvider.defaultSpace,
            ),
            child: SizedBox(
              width: Helper.getMaxContentWidth(context,
                  maxContentWidthOverride: 350.0),
              child: Column(
                children: [
                  // LabeledRow(
                  //   labelWidth: labelSize,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   label: 'USERNAME',
                  //   children: [
                  //     RowItem(
                  //       isCompact: false,
                  //       alignment: Alignment.centerLeft,
                  //       child: SizedBox(
                  //         // width: 200.0,
                  //         child: Text(
                  //           configProvider.username,
                  //           style: TextStyleTemplates.defaultTextStyle(
                  //             ConfigProvider.mainTextColor,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     RowItem(
                  //       isCompact: true,
                  //       child: IconButton(
                  //         icon: const Icon(
                  //           Icons.edit,
                  //           size: ConfigProvider.smallIconSize,
                  //           color: ConfigProvider.mainColor,
                  //         ),
                  //         onPressed: () async {
                  //           var input = await Helper.showPopUp(
                  //             title: 'Edit Username',
                  //             context: context,
                  //             specificHeight: 180.0,
                  //             content: EditTextFieldForm(
                  //               initialValue: configProvider.username,
                  //             ),
                  //           );
                  //           if (input != null &&
                  //               input is String &&
                  //               input.isNotEmpty &&
                  //               input != configProvider.username) {
                  //             configProvider.setUsername(input);
                  //           }
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(
                    height: ConfigProvider.defaultSpace,
                  ),
                  LabeledRow(
                    label: 'Auto Rest Timer',
                    tooltip: ConfigProvider.autoRestTimerToolTip,
                    labelWidth: labelSize,
                    children: [
                      RowItem(
                        isCompact: true,
                        alignment: Alignment.centerLeft,
                        child: Switch(
                          activeColor: ConfigProvider.mainColor,
                          thumbIcon: WidgetStatePropertyAll(
                            Icon(
                              configProvider.showRestTimerAfterEachSet
                                  ? Icons.check
                                  : Icons.close,
                              color: ConfigProvider.backgroundColor,
                            ),
                          ),
                          value: configProvider.showRestTimerAfterEachSet,
                          onChanged: (bool value) {
                            configProvider.setShowRestTimerAfterEachSet(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  LabeledRow(
                    label: 'Auto Populate Sets',
                    tooltip: ConfigProvider
                        .autoPopulateWorkoutFromSetsHistoryToolTip,
                    labelWidth: labelSize,
                    children: [
                      RowItem(
                        isCompact: true,
                        alignment: Alignment.centerLeft,
                        child: Switch(
                          activeColor: ConfigProvider.mainColor,
                          thumbIcon: WidgetStatePropertyAll(
                            Icon(
                              configProvider.autoPopulateWorkoutFromSetsHistory
                                  ? Icons.check
                                  : Icons.close,
                              color: ConfigProvider.backgroundColor,
                            ),
                          ),
                          value:
                              configProvider.autoPopulateWorkoutFromSetsHistory,
                          onChanged: (bool value) {
                            configProvider
                                .setAutoPopulateWorkoutFromSetsHistory(value);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: ConfigProvider.defaultSpace,
                  ),
                  LabeledRow(
                    label: 'Units',
                    labelWidth: labelSize,
                    tooltip: ConfigProvider.unitsToggleToolTip,
                    children: [
                      RowItem(
                        isCompact: true,
                        alignment: Alignment.centerLeft,
                        child: ToggleButtons(
                          isSelected: configProvider.isMetricSystemSelected
                              ? [false, true]
                              : [true, false],
                          onPressed: (int index) {
                            configProvider
                                .setIsMetricSystemSelected(index == 1);
                          },
                          borderRadius: BorderRadius.circular(
                            ConfigProvider.defaultSpace,
                          ),
                          fillColor: ConfigProvider.mainColor,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(
                                  ConfigProvider.defaultSpace / 2),
                              child: Text(
                                'Imperial',
                                style: TextStyleTemplates.defaultTextStyle(
                                  configProvider.isMetricSystemSelected
                                      ? ConfigProvider.mainTextColor
                                      : ConfigProvider.backgroundColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(
                                  ConfigProvider.defaultSpace / 2),
                              child: Text(
                                'Metric',
                                style: TextStyleTemplates.defaultTextStyle(
                                  configProvider.isMetricSystemSelected
                                      ? ConfigProvider.backgroundColor
                                      : ConfigProvider.mainTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
