import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/providers/config_provider.dart';
import './providers/exercise_provider.dart';
import 'providers/workout_provider.dart';

import './screens/main_content_navigator.dart';
import './screens/initial_screen.dart';
import './screens/splash_screen.dart';
import './providers/config_provider.dart';
import './widgets/general/text_style_templates.dart';
import './utility.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const WorkoutTracker());
  });
}

class WorkoutTracker extends StatelessWidget {
  const WorkoutTracker({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConfigProvider>(
          lazy: false,
          create: (_) => ConfigProvider(),
        ),
        ChangeNotifierProvider<ExerciseProvider>(
          lazy: false,
          create: (_) => ExerciseProvider(),
        ),
        ChangeNotifierProxyProvider<ExerciseProvider, WorkoutProvider>(
          lazy: false,
          create: (_) => WorkoutProvider(),
          update: (_, exerciseProvider, workoutProvider) {
            // only updates once per lifetime, when the exerciseProvider has been initialized with exercises
            return workoutProvider != null &&
                    workoutProvider.isInitializedWithExerciseProvider
                ? workoutProvider
                : WorkoutProvider(
                    exercises: exerciseProvider.exercises,
                  );
          },
        )
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: MaterialApp(
          title: 'RepPal',
          // color: ConfigProvider.mainColor,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: ConfigProvider.backgroundColorSolid,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: ConfigProvider.mainColor,
              selectionColor: Colors.grey.shade300,
              selectionHandleColor: ConfigProvider.mainColor,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                foregroundColor: WidgetStateProperty.all(Colors.black),
                overlayColor: WidgetStateProperty.resolveWith(
                  (states) {
                    if (states.contains(WidgetState.pressed)) {
                      return ConfigProvider.mainTextColor.withOpacity(
                          .1); // The color when the button is pressed
                    } else {
                      return ConfigProvider.mainTextColor
                          .withOpacity(.1); // Transparent otherwise
                    }
                  },
                ),
                iconColor: WidgetStateProperty.all(ConfigProvider.mainColor),
                iconSize: WidgetStateProperty.all(32),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            textTheme: TextTheme(
                // labelLarge: TextStyle(color: Colors.black),
                titleSmall: TextStyleTemplates.mediumBoldTextStyle(
              ConfigProvider.mainTextColor,
            )),
            iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                iconColor: WidgetStateProperty.all(ConfigProvider.mainColor),
                iconSize: WidgetStateProperty.all(32),
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(ConfigProvider.defaultSpace / 2),
              ),
              dialHandColor: ConfigProvider.mainColor,
              backgroundColor: ConfigProvider.backgroundColorSolid,
              dialBackgroundColor: ConfigProvider.backgroundColor,
              helpTextStyle: TextStyleTemplates.mediumTextStyle(
                ConfigProvider.mainTextColor,
              ),
              dialTextStyle: TextStyleTemplates.mediumTextStyle(
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
            datePickerTheme: DatePickerThemeData(
              backgroundColor: ConfigProvider.backgroundColorSolid,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(ConfigProvider.defaultSpace / 2),
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
              headerHeadlineStyle: TextStyleTemplates.xLargeTextStyle(
                ConfigProvider.mainTextColor,
              ),
              dayStyle: TextStyleTemplates.mediumTextStyle(
                ConfigProvider.mainTextColor,
              ),
              yearStyle: TextStyleTemplates.mediumTextStyle(
                ConfigProvider.mainTextColor,
              ),
              weekdayStyle: TextStyleTemplates.mediumBoldTextStyle(
                ConfigProvider.mainTextColor,
              ),
              headerHelpStyle: TextStyleTemplates.mediumTextStyle(
                ConfigProvider.mainTextColor,
              ),
              // todayBackgroundColor:
              //     WidgetStatePropertyAll(ConfigProvider.mainColor),
            ),
            // primaryTextTheme: TextTheme(
            //   titleSmall: TextStyleTemplates.largeBoldTextStyle(
            //     ConfigProvider.mainTextColor,
            //   ),
            // ),
            primarySwatch:
                Utility.createMaterialColor(ConfigProvider.mainColor),
            primaryColor: ConfigProvider.mainColor,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch:
                  Utility.createMaterialColor(ConfigProvider.mainColor),
            ),
            // tabBarTheme: const TabBarTheme(
            //   indicatorColor: Colors.red,
            //   dividerColor: ConfigProvider.backgroundColor,
            // ),

            highlightColor: Colors.grey.shade200,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          color: ConfigProvider.backgroundColorSolid,
          home: const InitialScreen(),
          routes: {
            InitialScreen.routeName: (ctx) => const InitialScreen(),
            MainContentNavigator.routeName: (ctx) =>
                const MainContentNavigator(),
          },
        ),
      ),
    );
  }
}
