import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/widgets/workout/_workout_history_.dart';

import '../providers/config_provider.dart';
import '../providers/workout_provider.dart';

import '../widgets/workout/_workout_page_.dart';
import '../widgets/general/text_style_templates.dart';

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
            // NavigationDestination(
            //   icon: Badge(
            //     label: Text(
            //       '2',
            //     ),
            //     child: Icon(
            //       Icons.folder_copy_rounded,
            //       color: currentPageIndex == 2
            //           ? ConfigProvider.backgroundColor
            //           : Colors.black,
            //     ),
            //   ),
            //   label: 'Templates',
            // ),
          ],
        ),
      ),
      body: <Widget>[
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

        /// Track page

        /// Messages page
        // const Card(
        //   shadowColor: Colors.transparent,
        //   child: SizedBox.expand(
        //     child: Center(
        //       child: Text(
        //         'Templates',
        //       ),
        //     ),
        //   ),
        // ),
      ][currentPageIndex],
    );
  }
}
