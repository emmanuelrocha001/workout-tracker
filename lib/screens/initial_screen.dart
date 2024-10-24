import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './splash_screen.dart';
import './main_content_navigator.dart';

class InitialScreen extends StatefulWidget {
  static const routeName = '/initial';
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  void _navigate({required String initialScreenRoute}) async {
    Navigator.of(context).pushReplacementNamed(initialScreenRoute);
  }

  void _getInitialView() async {
    // run init code

    _navigate(initialScreenRoute: MainContentNavigator.routeName);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), _getInitialView);
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
