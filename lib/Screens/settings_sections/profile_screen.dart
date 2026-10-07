import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

import '../../services/profile_view_api.dart';

import '../Home_Sections/drawers_screen.dart';

/// The Profile screen matching the provided design.
class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  const ProfileScreen({super.key, this.onBackTap, this.onMenuTap});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final response = await ProfileViewApiService.fetchProfile();
    setState(() {
      _isLoading = false;
      if (response != null && response['error'] == false) {
        _profileData = response['profile'];
      } else {
        _errorMessage = response?['error_msg'] ?? 'Failed to load profile';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const avatarDiameter = 100.0;

    return PopScope(
      canPop: !_isDrawerOpen,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_isDrawerOpen) {
          _scaffoldKey.currentState?.closeDrawer();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.bottomSheetCardBg,
        onDrawerChanged: (isOpened) {
          if (widget.onMenuTap == null) {
            setState(() {
              _isDrawerOpen = isOpened;
            });
          }
        },
        drawer: widget.onMenuTap == null ? const DrawersScreen() : null,
        body: Stack(
          children: [
          // 1. Green Header Background (#058334)
          Container(
            height: 250.h,
            width: double.infinity,
            color: AppColors.profileHeaderBg,
          ),

          // 2. Scrollable Body Content
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // App Bar Row (Back arrow + "Profile" title)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: AppColors.profileHeaderIcon,
                            size: 24.sp,
                          ),
                          onPressed: () {
                            if (widget.onMenuTap != null) {
                              widget.onMenuTap!();
                            } else {
                              _scaffoldKey.currentState?.openDrawer();
                            }
                          },
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Profile',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.profileHeaderTitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Overlapping Container & Profile Info Stack
                  if (_isLoading)
                    SizedBox(
                      height: 300.h,
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  else if (_errorMessage != null)
                    SizedBox(
                      height: 300.h,
                      child: Center(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  else
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        // White Sheet with rounded top corners
                        Container(
                          margin: EdgeInsets.only(
                            top: (avatarDiameter * 0.58).r,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.bottomSheetCardBg,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.r),
                              topRight: Radius.circular(24.r),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Spacing for lower part of avatar
                                SizedBox(
                                  height: (avatarDiameter * 0.45 + 14).r,
                                ),

                                // Name (Inter, #058334)
                                Center(
                                  child: Text(
                                    _profileData?['name']?.toString() ?? 'N/A',
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.profileName,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6.h),

                                // Phone Number (Inter, #000000)
                                Center(
                                  child: Text(
                                    _profileData?['mobile']?.toString() ?? '',
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.profilePhoneAndCode,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4.h),

                                // Customer Code (Inter, #000000)
                                Center(
                                  child: Text(
                                    'Customer ID : ${_profileData?['cus_id']?.toString() ?? 'N/A'}',
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.profilePhoneAndCode,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 28.h),

                                // Section Heading: "Personal information" (Inter)
                                Text(
                                  'Personal information',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.profileItemTitle,
                                  ),
                                ),
                                SizedBox(height: 14),

                                // Details Card (Manrope font)
                                _buildPersonalInformationCard(),
                                SizedBox(height: 36.h),
                              ],
                            ),
                          ),
                        ),

                        // Profile Avatar with 3px solid #689419 border showing first letter
                        Positioned(
                          top: 0,
                          child: Container(
                            width: avatarDiameter.r,
                            height: avatarDiameter.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.bottomSheetCardBg,
                              border: Border.all(
                                color: AppColors.profileBorder,
                                width: 3.w,
                              ),
                            ),
                            alignment: Alignment.center,
                            child:
                                (_profileData?['name']
                                        ?.toString()
                                        .trim()
                                        .isNotEmpty ==
                                    true)
                                ? Text(
                                    _profileData!['name']
                                        .toString()
                                        .trim()[0]
                                        .toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 48.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.profileName,
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 64
                                        .r, // Increased size slightly for icon
                                    color: AppColors.profileName,
                                  ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  /// Builds the white card containing personal information rows.
  Widget _buildPersonalInformationCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.profileCardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Color(0xFFF3F4F6), width: 0.93.w),
        
      ),
      child: Column(
        children: [
          _buildInfoRow(
            iconAsset: 'assets/profile/email.png',
            title: 'Email Address',
            subtext: (_profileData?['email']?.toString().isNotEmpty == true)
                ? _profileData!['email']
                : '-',
          ),

          // Aadhar Number
          _buildInfoRow(
            iconAsset: 'assets/profile/gender.png', // Using existing icon
            title: 'Aadhar Number',
            subtext: (_profileData?['aadhar_no']?.toString().isNotEmpty == true)
                ? _profileData!['aadhar_no']
                : '-',
            hasTopBorder: true,
          ),

          // 4. Address
          _buildInfoRow(
            iconAsset: 'assets/profile/address.png',
            title: 'Address',
            subtext: (_profileData?['address']?.toString().isNotEmpty == true)
                ? _profileData!['address']
                : '-',
            hasTopBorder: true,
          ),
        ],
      ),
    );
  }

  /// Builds a single information row with 8px radius icon background, Manrope font,
  /// and border-top: 0.93px solid #F3F4F6 when hasTopBorder is true.
  Widget _buildInfoRow({
    required String iconAsset,
    required String title,
    required String subtext,
    bool hasTopBorder = false,
  }) {
    return Container(
      decoration: hasTopBorder
          ? BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.profileCardBorder,
                  width: 0.93.h,
                ),
              ),
            )
          : null,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container (bg #A0FDAA5C, 8px radius)
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: AppColors.profileIconBg,
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.all(10.r),
            child: Image.asset(iconAsset, fit: BoxFit.contain),
          ),
          SizedBox(width: 14.w),

          // Text content (Manrope)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.profileItemTitle,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtext,
                  style: GoogleFonts.manrope(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.profileItemSubtext,
                    height: 1.35,
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
