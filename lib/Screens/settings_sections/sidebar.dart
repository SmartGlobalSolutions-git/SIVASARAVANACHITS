import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_saravana/Screens/Home_Sections/need_help_screen.dart';
import 'app_colors.dart';
import 'profile_screen.dart';
import 'setting_screen.dart';

/// The navigation sidebar / drawer widget matching the app design,
/// adapted for all screen sizes using flutter_screenutil and Inter font.
class Sidebar extends StatelessWidget {
  /// The greeting text (default: 'Hello')
  final String greeting;

  /// The user's name (default: 'Akhil')
  final String userName;

  /// The version string displayed at the bottom (default: 'App V1.0125')
  final String versionText;

  /// Optional avatar image provider
  final ImageProvider? avatarImage;

  /// Callback when "Need Help ?" button is tapped
  final VoidCallback? onNeedHelpTap;

  /// General callback invoked when any menu item is tapped
  final void Function(String itemTitle)? onMenuItemTap;

  const Sidebar({
    super.key,
    this.greeting = 'Hello',
    this.userName = 'Akhil',
    this.versionText = 'App V1.0125',
    this.avatarImage,
    this.onNeedHelpTap,
    this.onMenuItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final drawerWidth = math.min(1.sw * 0.82, 330.w);

    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        backgroundColor: AppColors.sidebarBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24.r),
            bottomRight: Radius.circular(24.r),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Header Section (User info + Need Help button)
                      _buildHeader(context),
                      SizedBox(height: 20.h),

                      // 2. Primary Menu Card (Profile -> Statement)
                      _buildPrimaryMenuCard(context),
                      SizedBox(height: 16.h),

                      // 3. Secondary Menu Card (Settings & Rewards)
                      _buildSecondaryMenuCard(context),
                      SizedBox(height: 24.h),

                      // 4. App Version
                      _buildVersionFooter(),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the top greeting row with user avatar, name, and "Need Help ?" button.
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // User Profile Avatar
        Container(
          width: 48.r,
          height: 48.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.avatarBackground,
            border: Border.all(
              color: AppColors.avatarBorder,
              width: 1.5.w,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: avatarImage != null
              ? Image(image: avatarImage!, fit: BoxFit.cover)
              : Icon(
                  Icons.person,
                  size: 28.r,
                  color: AppColors.avatarIcon,
                ),
        ),
        SizedBox(width: 12.w),

        // User Greeting & Name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                greeting,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.1,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                userName,
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // "Need Help ?" pill button
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24.r),
            onTap: onNeedHelpTap ??
                () {
                  Navigator.of(context).maybePop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NeedHelpScreen(),
                    ),
                  );
                },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: AppColors.needHelpBackground,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: AppColors.needHelpBorder,
                  width: 1.2.w,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.support_agent,
                    size: 16.r,
                    color: AppColors.needHelpIcon,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Need Help ?',
                    style: GoogleFonts.inter(
                      color: AppColors.needHelpText,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the first rounded card container with 9 items:
  /// Profile, Payment, Let's Plan Your Growth, Verification, Passbook,
  /// Chatbot, Prebiding, Surety, Statement.
  Widget _buildPrimaryMenuCard(BuildContext context) {
    return _buildGroupCard([
      const _SidebarMenuItemData(
        title: 'Profile',
        icon: Icons.account_circle_outlined,
      ),
      const _SidebarMenuItemData(
        title: 'Payment',
        icon: Icons.credit_card_outlined,
      ),
      const _SidebarMenuItemData(
        title: "Let's Plan Your Growth",
        icon: Icons.calculate_outlined,
      ),
      const _SidebarMenuItemData(
        title: 'Verification',
        icon: Icons.verified_outlined,
      ),
      const _SidebarMenuItemData(
        title: 'Passbook',
        icon: Icons.menu_book_outlined,
      ),
      const _SidebarMenuItemData(
        title: 'Chatbot',
        icon: Icons.smart_toy_outlined,
      ),
      const _SidebarMenuItemData(
        title: 'Prebiding',
        icon: Icons.image_outlined,
      ),
      const _SidebarMenuItemData(
        title: 'Surety',
        icon: Icons.gpp_good_outlined,
      ),
      const _SidebarMenuItemData(
        title: 'Statement',
        icon: Icons.article_outlined,
      ),
    ], context);
  }

  /// Builds the second rounded card container with Settings & Rewards.
  Widget _buildSecondaryMenuCard(BuildContext context) {
    return _buildGroupCard([
      const _SidebarMenuItemData(
        title: 'Settings',
        icon: Icons.settings_outlined,
      ),
      const _SidebarMenuItemData(
        title: 'Rewards & Achievements',
        icon: Icons.emoji_events_outlined,
      ),
    ], context);
  }

  /// Helper to wrap menu items in the styled grey card container.
  Widget _buildGroupCard(
    List<_SidebarMenuItemData> items,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(22.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          return _SidebarTile(
            title: item.title,
            icon: item.icon,
            onTap: () {
              if (onMenuItemTap != null) {
                onMenuItemTap!(item.title);
              } else {
                Navigator.of(context).maybePop();
                if (item.title == 'Profile') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                  return;
                }
                if (item.title == 'Settings') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingScreen(),
                    ),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.title} selected'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }

  /// Builds the footer with the app version string.
  Widget _buildVersionFooter() {
    return Center(
      child: Text(
        versionText,
        style: GoogleFonts.inter(
          color: AppColors.textMuted,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// Data class holding menu item configuration.
class _SidebarMenuItemData {
  final String title;
  final IconData icon;

  const _SidebarMenuItemData({
    required this.title,
    required this.icon,
  });
}

/// A reusable tile widget for each menu row in the sidebar card.
class _SidebarTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        splashColor: AppColors.splashColor,
        highlightColor: AppColors.highlightColor,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Row(
            children: [
              // White circular icon badge
              Container(
                width: 38.r,
                height: 38.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.iconCircleBackground,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 20.r,
                    color: AppColors.iconColor,
                  ),
                ),
              ),
              SizedBox(width: 14.w),

              // Title text
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.1,
                  ),
                ),
              ),

              // Trailing chevron arrow
              Icon(
                Icons.chevron_right,
                size: 20.r,
                color: AppColors.chevronColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
