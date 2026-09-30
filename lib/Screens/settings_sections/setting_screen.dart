import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'profile_screen.dart';
import 'privacy_policy.dart';
import 'terms_and_condition.dart';
import 'help_and_support.dart';
import 'faq.dart';
import 'about_us.dart';
import '../login_sections/user_type_selection_screen.dart';
import '../../services/shared_prefs_helper.dart';

/// The Settings screen displaying Account, App Preferences, Security & Privacy,
/// Support, About, and Logout options, using the asset icons provided.
class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.settingsBackground,
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        elevation: 0.5,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.settingsSubheading,
            size: 22.r,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        titleSpacing: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Setting',
          style: GoogleFonts.inter(
            color: AppColors.settingsSubheading,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          //physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. ACCOUNT
              _buildSectionHeader('ACCOUNT'),
              _buildCard([
                _SettingsTile(
                  assetPath: 'assets/settings/profile.png',
                  title: 'Profile Information',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
              ]),
              SizedBox(height: 16.h),

              // 2. APP PREFERENCES
              _buildSectionHeader('APP PREFERENCES'),
              _buildCard([
                _SettingsTile(
                  assetPath: 'assets/settings/language.png',
                  title: 'Language',
                  trailingText: 'English',
                  onTap: () => _handleItemTap(context, 'Language'),
                ),
              ]),
              SizedBox(height: 16.h),

              // 3. SECURITY & PRIVACY
              _buildSectionHeader('SECURITY & PRIVACY'),
              _buildCard([
                _SettingsTile(
                  assetPath: 'assets/settings/privacy_policy.png',
                  title: 'Privacy Policy',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen(),
                      ),
                    );
                  },
                ),
                _buildDivider(),
                _SettingsTile(
                  assetPath: 'assets/settings/terms_and_condition.png',
                  title: 'Terms & Conditions',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TermsAndConditionsScreen(),
                      ),
                    );
                  },
                ),
              ]),
              SizedBox(height: 16.h),

              // 4. SUPPORT
              _buildSectionHeader('SUPPORT'),
              _buildCard([
                _SettingsTile(
                  assetPath: 'assets/settings/help_and_support.png',
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HelpAndSupportScreen(),
                      ),
                    );
                  },
                ),
                _buildDivider(),
                _SettingsTile(
                  assetPath: 'assets/settings/faq.png',
                  title: 'FAQs',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FAQScreen(),
                      ),
                    );
                  },
                ),
              ]),
              SizedBox(height: 16.h),

              // 5. ABOUT
              _buildSectionHeader('ABOUT'),
              _buildCard([
                _SettingsTile(
                  assetPath: 'assets/settings/about.png',
                  title: 'About Us',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AboutUsScreen(),
                      ),
                    );
                  },
                ),
                _buildDivider(),
                _SettingsTile(
                  assetPath: 'assets/settings/app_version.png',
                  title: 'App Version',
                  trailingText: '1.0.0',
                  showChevron: false,
                  onTap: () => _handleItemTap(context, 'App Version 1.0.0'),
                ),
              ]),
              SizedBox(height: 16.h),

              // 6. LOGOUT BUTTON
              _buildLogoutButton(context),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds uppercase section header label (e.g. ACCOUNT, SUPPORT).
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.settingsSectionHeading,
          letterSpacing: 0.55,
        ),
      ),
    );
  }

  /// Wraps section tiles in a clean white card with square top corners and rounded bottom corners.
  Widget _buildCard(List<Widget> children) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.settingsCardBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.zero,
          topRight: Radius.zero,
          bottomLeft: Radius.circular(14.r),
          bottomRight: Radius.circular(14.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  /// Builds a subtle divider line between items inside the card.
  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.settingsDivider,
      indent: 48.w,
      endIndent: 12.w,
    );
  }

  /// Builds the dedicated Logout button card using assets/settings/logout.png.
  Widget _buildLogoutButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () => _showLogoutConfirmation(context),
        child: Container(
          height: 52.h,
          decoration: BoxDecoration(
            color: AppColors.settingsCardBackground,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/settings/logout.png',
                  width: 18.r,
                  height: 18.r,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Logout',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.logout,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleItemTap(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title tapped'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Logout',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await SharedPrefsHelper.clearPreferences();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const UserTypeSelectionScreen(),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.logout,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                'Logout',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A row tile inside each Settings card using custom asset icons directly.
class _SettingsTile extends StatelessWidget {
  final String assetPath;
  final String title;
  final String? trailingText;
  final bool showChevron;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.assetPath,
    required this.title,
    this.trailingText,
    this.showChevron = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: AppColors.splashColor,
        highlightColor: AppColors.highlightColor,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
          child: Row(
            children: [
              // Custom asset icon from assets/settings/
              Image.asset(
                assetPath,
                width: 22.r,
                height: 22.r,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 14.w),

              // Title (subheading)
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.66.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.settingsSubheading,
                    letterSpacing: -0.1,
                  ),
                ),
              ),

              // Trailing text (e.g. "English" or "1.0.0")
              if (trailingText != null)
                Padding(
                  padding: EdgeInsets.only(right: showChevron ? 4.w : 0),
                  child: Text(
                    trailingText!,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.settingsTrailingText,
                    ),
                  ),
                ),

              // Chevron right arrow
              if (showChevron)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 26.r,
                  color: AppColors.settingsRightArrow,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
