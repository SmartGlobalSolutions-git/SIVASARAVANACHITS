import 'package:flutter/material.dart';
import 'first_time_home_screen.dart';
import 'chit_schemes/chitschema.dart';
import 'Home_Sections/need_help_screen.dart';
import 'Home_Sections/drawers_screen.dart';
import '../widgets/first_time_bottom_nav.dart';

class FirstTimeMainWrapper extends StatefulWidget {
  const FirstTimeMainWrapper({super.key});

  @override
  State<FirstTimeMainWrapper> createState() => _FirstTimeMainWrapperState();
}

class _FirstTimeMainWrapperState extends State<FirstTimeMainWrapper> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      FirstTimeHomeScreen(
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        onPlansTap: () {
          setState(() {
            _currentIndex = 1;
          });
        },
      ),
      ChitSchemaScreen(
        initialTab: 0,
        onBackTap: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
      NeedHelpScreen(
        onBackTap: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawersScreen(isFirstTimeUser: true),
      body: _pages[_currentIndex],
      bottomNavigationBar: FirstTimeBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
