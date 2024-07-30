import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../widgets/exercise_selection_button.dart';
import '../widgets/general/text_style_templates.dart';

import '../providers/config_provider.dart';

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
    var textTemplates = TextStyleTemplates();
    return Scaffold(
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
            return textTemplates.smallBoldTextStyle(
              Colors.black,
            );
          }),
        ),
        child: NavigationBar(
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
                Feather.user,
                color: currentPageIndex == 0
                    ? ConfigProvider.backgroundColor
                    : Colors.black,
              ),
              label: 'Profile',
            ),
            NavigationDestination(
              icon: Badge(
                child: Icon(
                  Feather.feather,
                  color: currentPageIndex == 1
                      ? ConfigProvider.backgroundColor
                      : Colors.black,
                ),
              ),
              label: 'Track',
            ),
            NavigationDestination(
              icon: Badge(
                label: Text(
                  '2',
                ),
                child: Icon(
                  Feather.folder,
                  color: currentPageIndex == 2
                      ? ConfigProvider.backgroundColor
                      : Colors.black,
                ),
              ),
              label: 'Templates',
            ),
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
        const Center(
          child: ExerciseSelectionButton(),
        ),

        /// Messages page
        const Card(
          shadowColor: Colors.transparent,
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Templates',
              ),
            ),
          ),
        ),
      ][currentPageIndex],
    );
  }
}
