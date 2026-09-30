import 'package:flutter/material.dart';
import 'Home_Sections/home_screen.dart';
import 'Home_Sections/my_chits.dart';
import 'Home_Sections/drawers_screen.dart';
import 'Home_Sections/payment.dart';
import 'Home_Sections/passbook.dart';
import '../widgets/bottom_nav.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        onMyChitsTap: () {
          setState(() {
            _currentIndex = 1;
          });
        },
        onPaymentTap: () {
          setState(() {
            _currentIndex = 2;
          });
        },
      ),
      MyChitsScreen(
        onBackToHome: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
      PaymentScreen(
        onBackToHome: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
      PassbookScreen(
        onBackToHome: () {
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
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const DrawersScreen(),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNav(
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
