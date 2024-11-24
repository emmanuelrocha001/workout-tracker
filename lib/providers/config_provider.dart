import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_preferences_dto.dart';

class ConfigProvider extends ChangeNotifier {
  SharedPreferencesWithCache? _cache;
  UserPreferenceDto? _userPreferences;
  ConfigProvider() {
    setupCache();
  }

  void setupCache() async {
    _cache = await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(
            // This cache will only accept the key 'inProgressWorkout'.
            allowList: <String>{preferencesKey}));
    // await clearCache();
    if (_cache != null) {
      loadPreferencesFromCache();
    }
  }

  String get preferencesKey => '${ConfigProvider.cachePrefix}_preferences';

  Future<void> clearCache() async {
    _cache?.clear();
  }

  void loadPreferencesFromCache() async {
    try {
      var cachedEncodedValue = _cache?.getString(preferencesKey);
      if (cachedEncodedValue != null) {
        print(cachedEncodedValue);
        _userPreferences =
            UserPreferenceDto.fromJson(jsonDecode(cachedEncodedValue));
        notifyListeners();
      } else {
        print('No preferences found in cache');
        _userPreferences = UserPreferenceDto();
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  void _savePreferencesToCache() {
    if (_userPreferences != null) {
      _cache?.setString(preferencesKey, jsonEncode(_userPreferences));
    }
  }

  double _topPadding = 0.0;
  double get topPadding => _topPadding;

  void setTopPadding(double topPadding) {
    if (topPadding > 0.0) _topPadding = topPadding;
  }

  String get username => _userPreferences?.userName ?? '';

  void setUsername(String value) {
    _userPreferences?.userName = value;
    notifyListeners();
    _savePreferencesToCache();
  }

  bool get showRestTimerAfterEachSet =>
      _userPreferences?.showRestTimerAfterEachSet ?? false;

  void setShowRestTimerAfterEachSet(bool value) {
    print('setShowRestTimerAfterEachSet $value');
    _userPreferences?.showRestTimerAfterEachSet = value;

    print(jsonEncode(_userPreferences));
    notifyListeners();
    _savePreferencesToCache();
  }

  bool get isMetricSystemSelected =>
      _userPreferences?.isMetricSystemSelected ?? false;

  void setIsMetricSystemSelected(bool value) {
    _userPreferences?.isMetricSystemSelected = value;
    notifyListeners();
    _savePreferencesToCache();
  }

  static const cachePrefix = 'weito_cache_2aa91e4e-24ac-4197-baaf-23ef40a0b918';
  static const decimalRegexPattern = r'^\d{0,4}$|^\d{0,4}\.{1}\d{0,2}$';
  static const digitRegexPattern = r'^\d{0,4}$';

  static const defaultDateStampFormat = 'MMM d, y hh:mm aaa';
  static const defaultShortenDateStampFormat = 'MMM d, y';
  static const defaultTimeFormat = 'hh:mm aaa';
  static const simpleDateFormat = 'EEE, MMM d';
  static const twoDigitFormat = '00';

  // COLORS -------------------------->
  static const mainTextColor = Color.fromARGB(255, 0, 0, 0);
  static const alternateTextColor = Color.fromARGB(255, 104, 104, 104);
  static const mainTextColorWithOpacityPercent = .75;
  // static const mainColor = Color.fromARGB(255, 255, 62, 62);
  static const mainColor = Color(0xff0F4C75);
  // static const mainColor = Color(0xff556E53);
  static const backgroundColorSolid = Colors.white;
  static const backgroundColor = Color.fromARGB(255, 246, 246, 246);
  static const slightContrastBackgroundColor =
      Color.fromARGB(255, 230, 230, 230);

  // SIZING -------------------------->
  static const maxContentWidth = 600.0;
  static const maxButtonSize = 200.0;
  static const double logoZize = 100.0;

  // FONT SIZE -------------------------->
  static const xSmallFontSize = 10.0;
  static const smallFontSize = 12.0;
  static const defaultFontSize = 14.0;
  static const mediumFontSize = 18.0;
  static const largeFontSize = 20.0;
  static const xLargeFontSize = 32.0;
  static const xxLargeFontSize = 64.0;
  static const defaultIconSize = 28.0;
  static const smallIconSize = 18.0;

  // SPACING
  static const defaultSpace = 8.0;
  static const mediumSpace = 16.0;
  static const largeSpace = 24.0;

  // text
  static const cancelInProgressWorkoutText =
      'Are you sure you want to cancel this workout? All progress will be lost.';

  static const cancelUpdateWorkoutText =
      'Are you sure you want to cancel workout update? All progress will be lost.';

  static const deleteWorkoutEntryText =
      'Are you sure you want to delete this workout entry? This action cannot be undone.';
}
