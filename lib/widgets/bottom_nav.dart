import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0x4D000000),
            width: 0.8.w,
          ),
        ),
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Color(0xFF707B83),
        selectedFontSize: 12.sp,
        unselectedFontSize: 12.sp,
        iconSize: 24.w,
        currentIndex: currentIndex,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/bottom_nav/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/bottom_nav/chit.png')),
            label: 'My Chits',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/bottom_nav/payment.png')),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/bottom_nav/passbook.png')),
            label: 'Passbook',
          ),
        ],
      ),
    );
  }
}
