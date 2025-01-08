import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exercise_provider.dart';
import '../widgets/workout/_workout_history.dart';

import '../providers/config_provider.dart';
import '../providers/workout_provider.dart';

import '../widgets/workout/_workout_page_.dart';
import '../widgets/preferences/preferences_page.dart';
import '../widgets/exercise/_exercises_page.dart';
import '../widgets/general/text_style_templates.dart';

import '../widgets/helper.dart';

class MainContentNavigator extends StatefulWidget {
  static const routeName = '/main';
  const MainContentNavigator({super.key});

  @override
  State<MainContentNavigator> createState() => _MainContentNavigatorState();
}

class _MainContentNavigatorState extends State<MainContentNavigator> {
  int currentPageIndex = 1;

  void navigateToPage(int index) {
    if (index > 0 && index < 2) {
      setState(() {
        currentPageIndex = index;
      });
    }
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // might need to delay this. context is possibly not ready. did not navigate while testing on web build

    var workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    if (workoutProvider.isWorkoutInProgress()) {
      currentPageIndex = 0;
    }
    Future.delayed(Duration.zero, () {
      showDataDisclaimerIfNotShown();
    });
  }

  void showDataDisclaimerIfNotShown() async {
    var configProvider = Provider.of<ConfigProvider>(context, listen: false);
    if (!configProvider.hasAcknowledgeDataStorageDisclaimer) {
      var res = await Helper.showPopUp(
          context: context,
          heightPercentage: .33,
          isDismissible: false,
          // specificHeight: 300.0,
          title: 'Data disclaimer',
          content: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    ConfigProvider.dataStorageDisclaimerText,
                    style: TextStyleTemplates.smallTextStyle(
                      ConfigProvider.mainTextColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: ConfigProvider.defaultSpace * 2,
                      top: ConfigProvider.defaultSpace,
                      left: ConfigProvider.defaultSpace * 2,
                      right: ConfigProvider.defaultSpace * 2,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: ConfigProvider.mainColor,
                        ),
                        child: Text(
                          'I Acknowledge',
                          style: TextStyleTemplates.smallBoldTextStyle(
                            ConfigProvider.backgroundColor,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));

      if (res ?? false) {
        configProvider.setHasAcknowledgeDataStorageDisclaimer();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConfigProvider.backgroundColor,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          backgroundColor: ConfigProvider.backgroundColor,
          indicatorColor: ConfigProvider.mainColor,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ConfigProvider.defaultSpace),
          ),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
              (Set<WidgetState> states) {
            // if (states.contains(WidgetState.selected)) {
            //   return textTemplates.smallTextStyle(
            //     ConfigProvider.backgroundColor,
            //   );
            // }
            return TextStyleTemplates.smallBoldTextStyle(
              Colors.black,
            );
          }),
        ),
        child: NavigationBar(
          backgroundColor: ConfigProvider.backgroundColorSolid,
          elevation: 2.0,
          onDestinationSelected: (int index) {
            var exerciseProvider =
                Provider.of<ExerciseProvider>(context, listen: false);
            exerciseProvider.clearFilters();
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: <Widget>[
            NavigationDestination(
              icon: Icon(
                Icons.fitness_center_rounded,
                color: currentPageIndex == 0
                    ? ConfigProvider.backgroundColor
                    : Colors.black,
              ),
              label: 'Workout',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.history_rounded,
                color: currentPageIndex == 1
                    ? ConfigProvider.backgroundColor
                    : Colors.black,
              ),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.build_outlined,
                color: currentPageIndex == 2
                    ? ConfigProvider.backgroundColor
                    : Colors.black,
              ),
              label: 'Exercises',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.settings_rounded,
                color: currentPageIndex == 3
                    ? ConfigProvider.backgroundColor
                    : Colors.black,
              ),
              label: 'Preferences',
            ),
          ],
        ),
      ),
      body: <Widget>[
        /// Workout
        WorkoutPage(
          navigateToWorkoutHistory: () {
            navigateToPage(1);
          },
        ),

        /// Profile
        WorkoutHistory(
          navigateToWorkout: () {
            navigateToPage(0);
          },
        ),

        /// Exercises
        const ExercisesPage(),

        // Preferences
        const PreferencesPage(),
      ][currentPageIndex],
    );
  }
}
