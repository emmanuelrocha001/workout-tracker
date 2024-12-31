import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/config_provider.dart';

import "../general/pill_container.dart";

import '../general/text_style_templates.dart';

class FilteredBy extends StatelessWidget {
  final List<String> filters;
  final void Function() onClearFilters;
  final void Function() onFilter;
  const FilteredBy({
    super.key,
    required this.filters,
    required this.onClearFilters,
    required this.onFilter,
  });

  bool hasAppliedFilter() {
    for (var filter in filters) {
      if (filter.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  Iterable<Widget> _getFilters() {
    return filters.where((x) => x.isNotEmpty).map(
          (filter) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: ConfigProvider.defaultSpace / 2),
                child: PillContainer(
                  color: ConfigProvider.backgroundColor,
                  child: Text(
                    filter.toUpperCase(),
                    style: TextStyleTemplates.smallBoldTextStyle(
                      ConfigProvider.mainTextColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: ConfigProvider.defaultSpace,
              ),
            ],
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: false);
    return Container(
      // color: Colors.purple,
      padding: const EdgeInsets.only(
        left: ConfigProvider.defaultSpace,
        right: ConfigProvider.defaultSpace,
        // top: ConfigProvider.defaultSpace / 2,
      ),
      alignment: Alignment.centerRight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ..._getFilters(),
              const SizedBox(width: ConfigProvider.defaultSpace / 2),
              if (hasAppliedFilter())
                TextButton(
                  onPressed: onClearFilters,
                  style: TextButton.styleFrom(
                    visualDensity: configProvider.isMobile
                        ? VisualDensity.compact
                        : VisualDensity.standard,
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    "CLEAR",
                    style: TextStyleTemplates.smallBoldTextStyle(
                      ConfigProvider.backgroundColor,
                    ),
                  ),
                ),
              const SizedBox(width: ConfigProvider.defaultSpace),
              IconButton(
                visualDensity: configProvider.isMobile
                    ? VisualDensity.compact
                    : VisualDensity.standard,
                icon: const Icon(
                  size: ConfigProvider.defaultIconSize,
                  Icons.filter_list_outlined,
                  color: ConfigProvider.mainColor,
                ),
                onPressed: onFilter,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
