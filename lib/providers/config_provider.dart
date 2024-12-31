// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_preferences_dto.dart';

class ConfigProvider extends ChangeNotifier {
  SharedPreferencesWithCache? _cache;
  UserPreferenceDto? _userPreferences;
  bool _isNativeMobile = false;
  bool _isWebMobile = false;
  ConfigProvider() {
    checkPlatform();
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

  void checkPlatform() {
    _isWebMobile = _setIsMobileWeb();
    _isNativeMobile = !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  }

  bool _setIsMobileWeb() {
    if (!kIsWeb) {
      return false;
    }
    var userAgent = (html.window.navigator.userAgent).toLowerCase();
    return userAgent.contains('mobile') || // General mobile devices
        userAgent.contains('android') || // Android devices
        userAgent.contains('iphone') || // iPhone
        userAgent.contains('ipad'); // iPad
  }

  bool get isNativeMobile => _isNativeMobile;
  bool get isWebMobile => _isWebMobile;
  bool get isMobile => _isNativeMobile || _isWebMobile;

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

  bool get autoPopulateWorkoutFromSetsHistory =>
      _userPreferences?.autoPopulateWorkoutFromSetsHistory ?? false;

  void setAutoPopulateWorkoutFromSetsHistory(bool value) {
    _userPreferences?.autoPopulateWorkoutFromSetsHistory = value;
    notifyListeners();
    _savePreferencesToCache();
  }

  bool get hasAcknowledgeDataStorageDisclaimer =>
      _userPreferences?.hasAcknowledgeDataStorageDisclaimer ?? false;

  void setHasAcknowledgeDataStorageDisclaimer() {
    _userPreferences?.hasAcknowledgeDataStorageDisclaimer = true;
    notifyListeners();
    _savePreferencesToCache();
  }

  static const developerName = "Emmanuel R.";
  static const developerLinkdin = "https://www.linkedin.com/in/emmanuel-rocha";
  static const cachePrefix = 'erp_cache_2aa91e4e-24ac-4197-baaf-23ef40a0b918';
  static const decimalRegexPattern = r'^\d{0,4}$|^\d{0,4}\.{1}\d{0,2}$';
  static const digitRegexPattern = r'^\d{0,4}$';

  static const defaultDateStampFormatWithTime = 'MMM d, y hh:mm aaa';
  static const defaultDateStampFormat = 'MMM d, y';
  static const defaulDateStampWithDayOfWeekFormat = 'EEE, MMM d, y';
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
  // static const mainColor = Color.fromARGB(255, 227, 37, 12);
  static const backgroundColorSolid = Colors.white;
  static const backgroundColor = Color.fromARGB(255, 246, 246, 246);
  static const slightContrastBackgroundColor =
      Color.fromARGB(255, 230, 230, 230);

  // SIZING -------------------------->
  static const maxContentWidth = 600.0;
  static const maxButtonWidth = 300.0;
  static const defaultButtonHeight = 40.0;
  static const double logoZize = 100.0;

  // FONT SIZE -------------------------->
  static const xSmallFontSize = 10.0;
  static const smallFontSize = 12.0;
  static const defaultFontSize = 14.0;
  static const mediumFontSize = 18.0;
  static const largeFontSize = 20.0;
  static const xLargeFontSize = 32.0;
  static const xxLargeFontSize = 64.0;
  static const defaultIconSize = 26.0;
  static const mediumIconSize = 22.0;
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

  static const autoRestTimerToolTip =
      'Automatically start a rest timer after each set.';

  static const autoPopulateWorkoutFromSetsHistoryToolTip =
      'Automatically populate exercises from latest tracked sets. This applies to any exercise that is manually added during a workout.';

  static const unitsToggleToolTip =
      "Toggle between imperial and metric units. Note, this will not translate existing data.";

  static const autoTimingToggleToolTip =
      'Workout duration will be calculated automatically based on the specified start time.';

  static const workoutNickNameInputToolTip = 'Friendly name for this workout.';

  static const exercisesPageToolTip =
      'Add new exercises, review existing ones, and make edits. Note: System defined exercises cannot be modified or deleted.';
  static const workoutPageToolTip = 'Start a new workout.';

  static const workoutHistoryToolTip =
      'Review your workout history, edit past entries, and start workouts based on previous sessions';

  static const preferencesPageToolTip =
      'Customize your settings to tailor the app experience to your preferences and needs.';

  static const deleteUserDefinedExerciseText =
      'Are you sure you want to delete this exercise? This action cannot be undone.';

  static const dataStorageDisclaimerText =
      "ERP uses local storage to save your data, meaning all information is stored directly on your device and not on any external servers. While we make every effort to ensure the app functions reliably, we cannot guarantee complete data persistence due to factors beyond our control, such as device-specific issues, software updates, or accidental data deletion.";
}
