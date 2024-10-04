import 'package:flutter/material.dart';

import '../providers/config_provider.dart';

import '../widgets/workout/__workout_page.dart';
import '../widgets/exercise_selection_button.dart';
import '../widgets/general/text_style_templates.dart';

class MainContentNavigator extends StatefulWidget {
  static const routeName = '/main';
  const MainContentNavigator({super.key});

  @override
  State<MainContentNavigator> createState() => _MainContentNavigatorState();
}

class _MainContentNavigatorState extends State<MainContentNavigator> {
  int currentPageIndex = 1;

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
                Icons.bug_report_rounded,
                color: currentPageIndex == 0
                    ? ConfigProvider.backgroundColor
                    : Colors.black,
              ),
              label: 'Debug',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.fitness_center_rounded,
                color: currentPageIndex == 1
                    ? ConfigProvider.backgroundColor
                    : Colors.black,
              ),
              label: 'Workout',
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
        /// Profile
        const Card(
          shadowColor: Colors.transparent,
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Profile',
              ),
            ),
          ),
        ),

        /// Track page
        const WorkoutPage(),

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
