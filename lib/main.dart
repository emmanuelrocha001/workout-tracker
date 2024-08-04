import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/providers/config_provider.dart';
import './providers/exercise_provider.dart';

import './screens/main_content_navigator.dart';
import './screens/initial_screen.dart';
import './screens/splash_screen.dart';
import './widgets/exercise_selection_button.dart';
import './providers/config_provider.dart';
import './utility.dart';

void main() {
  runApp(const WorkoutTracker());
}

class WorkoutTracker extends StatelessWidget {
  const WorkoutTracker({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConfigProvider>(
          create: (_) => ConfigProvider(),
        ),
        ChangeNotifierProvider<ExerciseProvider>(
          create: (_) => ExerciseProvider(),
        )
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            print('unfocusing');
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: MaterialApp(
          title: 'Workout Tracker',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
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
            textTheme: const TextTheme(
              labelLarge: TextStyle(color: Colors.black),
            ),
            iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                iconColor: WidgetStateProperty.all(ConfigProvider.mainColor),
                iconSize: WidgetStateProperty.all(32),
              ),
            ),
            primarySwatch:
                Utility.createMaterialColor(ConfigProvider.mainColor),
            primaryColor: ConfigProvider.mainColor,
            highlightColor: Colors.grey.shade200,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
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
