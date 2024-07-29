import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/providers/exercise_provider.dart';
import './widgets/exercise_selection_button.dart';

import './default_configs.dart';
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
        ChangeNotifierProvider<ExerciseProvider>(
            create: (_) => ExerciseProvider())
      ],
      child: MaterialApp(
        title: 'Workout Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // #EE8572
          // 00A896 percian green
          // buttonTheme: ButtonThemeData(
          //   buttonColor: DefaultConfigs.mainColor,
          //   textTheme: ButtonTextTheme.primary,
          // ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: DefaultConfigs.mainColor,
            selectionColor: Colors.grey.shade300,
            selectionHandleColor: DefaultConfigs.mainColor,
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
                    return DefaultConfigs.mainTextColor.withOpacity(
                        .1); // The color when the button is pressed
                  } else {
                    return DefaultConfigs.mainTextColor
                        .withOpacity(.1); // Transparent otherwise
                  }
                },
              ),
              iconColor: WidgetStateProperty.all(DefaultConfigs.mainColor),
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
              iconColor: WidgetStateProperty.all(DefaultConfigs.mainColor),
              iconSize: WidgetStateProperty.all(32),
            ),
          ),
          primarySwatch: Utility.createMaterialColor(DefaultConfigs.mainColor),
          primaryColor: DefaultConfigs.mainColor,
          highlightColor: Colors.grey.shade200,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const Scaffold(
          // backgroundColor: Color.fromARGB(255, 44, 78, 128),
          body: Center(
            child: ExerciseSelectionButton(),
          ),
        ),
      ),
    );
  }
}
