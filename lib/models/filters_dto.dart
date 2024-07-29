class FiltersDto {
  final List<FilterDto> filters;
  final String name;
  String selectedValue = "";
  String tempSelectedValue = "";

  FiltersDto({required this.name, required this.filters});
}

class FilterDto {
  final String displayValue;
  final String value;

  FilterDto({
    required this.displayValue,
    required this.value,
  });
}
