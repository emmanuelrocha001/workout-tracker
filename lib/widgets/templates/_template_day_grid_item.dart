import 'package:flutter/material.dart';
import '../../models/template_dto.dart';
import '../../providers/config_provider.dart';
import '../general/text_style_templates.dart';
import '../general/pill_container.dart';

class TemplateDayGridItem extends StatelessWidget {
  final TemplateDayDto day;
  final String name;
  final String emphasis;
  final String sex;
  final int numberOfDays;
  final Function onSelect;

  final int? selectedPosition;
  const TemplateDayGridItem({
    super.key,
    required this.day,
    required this.name,
    required this.emphasis,
    required this.sex,
    required this.numberOfDays,
    required this.onSelect,
    required this.selectedPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ConfigProvider.backgroundColorSolid,
      elevation: 0,
      shape: Border.all(
        width: 1,
        color: ConfigProvider.slightContrastBackgroundColor,
      ),
      child: ListTile(
        onTap: () => onSelect(),
        title: Column(
          spacing: ConfigProvider.defaultSpace / 4,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (onSelect != null)
              Align(
                alignment: Alignment.topLeft,
                child: Radio(
                  value: day.position,
                  groupValue: selectedPosition,
                  // activeColor: const Color.fromARGB(255, 44, 78, 128),
                  fillColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      return ConfigProvider.mainColor;
                    },
                  ),
                  onChanged: null,
                  toggleable: false,
                ),
              ),
            Text(
              'DAY ${day.position + 1}',
              style: TextStyleTemplates.smallTextStyle(
                ConfigProvider.mainTextColor.withOpacity(
                  ConfigProvider.mainTextColorWithOpacityPercent,
                ),
              ),
            ),
            Text(
              name,
              style: TextStyleTemplates.defaultTextStyle(
                ConfigProvider.mainTextColor,
              ),
            ),
            PillContainer(
              color: ConfigProvider.backgroundColor,
              child: Text(
                sex.toUpperCase(),
                style: TextStyleTemplates.defaultTextStyle(
                  ConfigProvider.mainTextColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: ConfigProvider.defaultSpace / 2),
              child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    color: ConfigProvider.mainColor,
                    size: ConfigProvider.defaultIconSize,
                  ),
                  // style: const ButtonStyle(
                  //   visualDensity: VisualDensity.compact,
                  // ),
                  onPressed: () {},
                ),
              ),
            ),

            // PillContainer(
            //   color: ConfigProvider.backgroundColor,
            //   child: Text(
            //     'DAY ${day.position + 1}',
            //     style: TextStyleTemplates.defaultTextStyle(
            //       ConfigProvider.mainTextColor,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
