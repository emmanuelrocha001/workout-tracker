import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import './config_provider.dart';
import '../models/exercise_dto.dart';
import '../models/template_dto.dart';

class TemplatesProvider with ChangeNotifier {
  final String _templatesFilePath = 'assets/json_docs/_TEMPLATES.json';

  List<TemplateDto> _systemDefinedTemplates = [];
  List<TemplateDto> _templates = [];
  List<TemplateDto> _filteredTemplates = [];

  TemplatesProvider() {
    loadSystemDefinedTemplates();
  }

  Future<void> loadSystemDefinedTemplates() async {
    // Load templates from assets
    try {
      var templatesEncodedString =
          await rootBundle.loadString(_templatesFilePath);

      List<dynamic> tempTemplates = json.decode(templatesEncodedString);
      _systemDefinedTemplates = tempTemplates.map((x) {
        var temp = TemplateDto.fromJson(x);
        return temp;
      })
          // .where(
          //   (y) =>
          //       y.id == "vcpphbkf862f" ||
          //       y.id == "4bwysbvdnxm6" ||
          //       y.id == "nqogle4n4nks",
          // )
          .toList();
      _templates = [..._systemDefinedTemplates];
      _filteredTemplates = [..._templates];
    } catch (e, s) {
      print(e);
      print(s);
    }
    notifyListeners();
  }

  List<TemplateDto> get templates => [..._filteredTemplates];
}
