import 'package:flutter/material.dart';
import 'package:siva_saravana/Screens/chit_schemes/chit_schemes.dart';
import 'first_time_home_screen.dart';
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
  bool _isDrawerOpen = false;

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
      ChitSchemesScreen(
        initialTab: 0,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        onBackTap: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
      NeedHelpScreen(
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
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
    return PopScope(
      canPop: _currentIndex == 0 && !_isDrawerOpen,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        
        if (_isDrawerOpen) {
          _scaffoldKey.currentState?.closeDrawer();
          return;
        }
        
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        onDrawerChanged: (isOpened) {
          setState(() {
            _isDrawerOpen = isOpened;
          });
        },
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
      ),
    );
  }
}
