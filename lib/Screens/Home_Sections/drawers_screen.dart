import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/Screens/Prebitting/prebitting.dart';
import 'package:siva_saravana/Screens/reward/reward.dart';
import 'package:siva_saravana/Screens/growth_plan/calculator_screen.dart';
import 'package:siva_saravana/Screens/growth_plan/chatbot_screen.dart';
import 'package:siva_saravana/Screens/settings_sections/profile_screen.dart';
import 'package:siva_saravana/Screens/settings_sections/setting_screen.dart';
import 'package:siva_saravana/Screens/Home_Sections/payment.dart';
import 'package:siva_saravana/Screens/Home_Sections/passbook.dart';
import 'package:siva_saravana/Screens/statements/statement.dart';
import 'package:siva_saravana/Screens/Home_Sections/family_chit.dart';
import 'package:siva_saravana/services/profile_view_api.dart';

import 'package:siva_saravana/services/shared_prefs_helper.dart';

class DrawersScreen extends StatefulWidget {
  final bool isFirstTimeUser;
  const DrawersScreen({super.key, this.isFirstTimeUser = false});

  @override
  State<DrawersScreen> createState() => _DrawersScreenState();
}

class _DrawersScreenState extends State<DrawersScreen> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final savedName = await SharedPrefsHelper.getUserName();
    if (savedName.isNotEmpty) {
      if (mounted) {
        setState(() {
          _userName = savedName;
        });
      }
    } else {
      final response = await ProfileViewApiService.fetchProfile();
      if (mounted) {
        setState(() {
          if (response != null && response['error'] == false) {
            _userName = response['profile']?['name']?.toString() ?? 'User';
            SharedPrefsHelper.saveUserName(_userName);
          } else {
            _userName = 'User';
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerItem(String imagePath, String title, {VoidCallback? onTap}) {
      return ListTile(
        leading: Container(
          padding: EdgeInsets.all(6.w),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Image.asset(imagePath, height: 20.h, width: 20.w),
        ),
        title: Text(title, style: TextStyle(fontSize: 14.sp)),
        trailing: Icon(Icons.chevron_right, color: Colors.black54, size: 20.w),
        onTap: () {
          Navigator.pop(context);
          if (onTap != null) {
            onTap();
          }
        },
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.h),
      );
    }

    return Drawer(
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          // Background Image
          Positioned(
            right: -20.w,
            bottom: -20.h,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/home_images/ssc_pot.png',
                height: 300.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[600],
                          size: 24.w,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            _userName.isEmpty ? 'Loading...' : _userName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10.h),
                            if (!widget.isFirstTimeUser)
                            _buildDrawerItem('assets/drawer/profile.png', 'Profile',
                            onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                                );
                              }
                            ),
                            if (!widget.isFirstTimeUser)
                              _buildDrawerItem(
                                'assets/drawer/payment.png',
                                'Payment',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PaymentScreen()),
                                  );
                                },
                              ),
                            _buildDrawerItem(
                              'assets/drawer/calculator.png',
                              'Let\'s Plan Your Growth',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CalculatorScreen()),
                                );
                              },
                            ),
                            if (!widget.isFirstTimeUser)
                              _buildDrawerItem(
                                'assets/drawer/passbook.png',
                                'Passbook',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PassbookScreen()),
                                  );
                                },
                              ),
                            _buildDrawerItem(
                              'assets/drawer/chatbot.png',
                              'Chatbot',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ChatbotScreen()),
                                );
                              },
                            ),
                            if (!widget.isFirstTimeUser) ...[
                              _buildDrawerItem(
                                'assets/drawer/prebiding.png',
                                'Prebiding',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PrebiddingListScreen()),
                                  );
                                },
                              ),
                              _buildDrawerItem(
                                'assets/drawer/statement.png',
                                'Statement',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const StatementScreen()),
                                  );
                                },
                              ),
                              _buildDrawerItem(
                                'assets/drawer/profile.png',
                                'Family Chit',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const FamilyChitScreen()),
                                  );
                                },
                              ),
                            ],
                            SizedBox(height: 10.h),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10.h),
                            _buildDrawerItem(
                              'assets/drawer/settings.png',
                              'Settings',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SettingScreen()),
                                );
                              }
                            ),
                            _buildDrawerItem(
                              'assets/drawer/rewards.png',
                              'Rewards & Achievements',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RewardsAchievementsScreen()),
                                );
                              },
                            ),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Center(
                        child: Text(
                          'App V1.0125',
                          style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
