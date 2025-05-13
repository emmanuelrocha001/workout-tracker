import 'package:flutter/material.dart';
import '../../models/template_dto.dart';
import '../../providers/config_provider.dart';
import '../general/text_style_templates.dart';
import '../general/pill_container.dart';

class TemplateDayListItem extends StatelessWidget {
  final TemplateDayDto day;
  final String name;
  final String emphasis;
  final String sex;
  final int numberOfDays;
  final Function onSelect;

  final int? selectedPosition;
  const TemplateDayListItem({
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
      shape: const BorderDirectional(
        top: BorderSide(
          width: 1,
          color: ConfigProvider.slightContrastBackgroundColor,
        ),
      ),
      child: ListTile(
        onTap: () => onSelect(),
        leading: Radio(
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          ],
        ),
        trailing: IconButton(
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
    );
  }
}
