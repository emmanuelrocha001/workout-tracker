import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/general/default_container.dart';

import '../general/overlay_content.dart';
import '../general/labeled_row.dart';
import '../general/row_item.dart';
import '../general/default_tooltip.dart';
import '../general/default_switch.dart';
import '../general/text_style_templates.dart';
import '../../providers/config_provider.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  final double labelSize = 100.0;

  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(
      context,
    );
    return OverlayContent(
      overLayContent: Container(
        color: ConfigProvider.backgroundColorSolid,
        child: Row(
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
      ),
      content: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: ConfigProvider.defaultSpace / 2,
              ),
              DefaultContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabeledRow(
                      label: 'Auto Rest Timer',
                      labelWidth: labelSize,
                      children: [
                        RowItem(
                          isCompact: true,
                          alignment: Alignment.centerLeft,
                          child: DefaultSwitch(
                            value: configProvider.showRestTimerAfterEachSet,
                            onChanged: (bool value) {
                              configProvider
                                  .setShowRestTimerAfterEachSet(value);
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.all(ConfigProvider.defaultSpace),
                      child: Text(
                        ConfigProvider.autoRestTimerToolTip,
                        style: TextStyleTemplates.smallTextStyle(
                            ConfigProvider.mainTextColor),
                      ),
                    ),
                  ],
                ),
              ),
              DefaultContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabeledRow(
                      label: 'Auto Populate Sets',
                      labelWidth: labelSize,
                      children: [
                        RowItem(
                          isCompact: true,
                          alignment: Alignment.centerLeft,
                          child: DefaultSwitch(
                            value: configProvider
                                .autoPopulateWorkoutFromSetsHistory,
                            onChanged: (bool value) {
                              configProvider
                                  .setAutoPopulateWorkoutFromSetsHistory(value);
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.all(ConfigProvider.defaultSpace),
                      child: Text(
                        ConfigProvider
                            .autoPopulateWorkoutFromSetsHistoryToolTip,
                        style: TextStyleTemplates.smallTextStyle(
                            ConfigProvider.mainTextColor),
                      ),
                    ),
                  ],
                ),
              ),
              DefaultContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabeledRow(
                      label: 'Auto Collapse Exercise Entries',
                      labelWidth: labelSize,
                      children: [
                        RowItem(
                          isCompact: true,
                          alignment: Alignment.centerLeft,
                          child: DefaultSwitch(
                            value: configProvider.autoCollapseTrackedExercises,
                            onChanged: (bool value) {
                              configProvider
                                  .setAutoCollapseTrackeExercises(value);
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.all(ConfigProvider.defaultSpace),
                      child: Text(
                        ConfigProvider.autoCollapseTrackedExercisesToolTip,
                        style: TextStyleTemplates.smallTextStyle(
                            ConfigProvider.mainTextColor),
                      ),
                    ),
                  ],
                ),
              ),
              DefaultContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabeledRow(
                      label: 'Units',
                      labelWidth: labelSize,
                      // tooltip: ConfigProvider.unitsToggleToolTip,
                      children: [
                        RowItem(
                          isCompact: true,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              ToggleButtons(
                                isSelected:
                                    configProvider.isMetricSystemSelected
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
                                      'Lb',
                                      style:
                                          TextStyleTemplates.defaultTextStyle(
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
                                      'Kg',
                                      style:
                                          TextStyleTemplates.defaultTextStyle(
                                        configProvider.isMetricSystemSelected
                                            ? ConfigProvider.backgroundColor
                                            : ConfigProvider.mainTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.all(ConfigProvider.defaultSpace),
                      child: Text(
                        ConfigProvider.unitsToggleToolTip,
                        style: TextStyleTemplates.smallTextStyle(
                            ConfigProvider.mainTextColor),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    // Helper.navigateToUrl(
                    //     url: ConfigProvider.developerLinkdin);
                  },
                  child: Text(
                    'Developed by ${ConfigProvider.developerName}',
                    style: TextStyleTemplates.xSmallBoldTextStyle(
                        ConfigProvider.mainTextColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
