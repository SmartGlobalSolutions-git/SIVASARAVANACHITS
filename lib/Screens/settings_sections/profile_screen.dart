import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

import '../../services/profile_view_api.dart';

/// The Profile screen matching the provided design.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    const avatarDiameter = 136.0;

    return Scaffold(
      backgroundColor: AppColors.bottomSheetCardBg,
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
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppColors.profileHeaderIcon,
                            size: 22.r,
                          ),
                          onPressed: () => Navigator.of(context).maybePop(),
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
                        margin: EdgeInsets.only(top: (avatarDiameter * 0.58).r),
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
                              SizedBox(height: (avatarDiameter * 0.42 + 14).r),

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
                                  _profileData?['mobile']?.toString() ?? 'N/A',
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

                      // Profile Avatar with 3px solid #689419 border and edit badge
                      Positioned(
                        top: 0,
                        child: Stack(
                          children: [
                            Container(
                              width: avatarDiameter.r,
                              height: avatarDiameter.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.profileBorder,
                                  width: 3.w,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/profile/profile_img.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            // Small green edit badge on bottom-right
                            Positioned(
                              bottom: 4.r,
                              right: 6.r,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _showChangePhotoBottomSheet(context),
                                child: Image.asset(
                                  'assets/profile/edit.png',
                                  width: 24.r,
                                  height: 24.r,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  /// Builds the white card containing personal information rows.
  Widget _buildPersonalInformationCard() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.profileCardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.profileCardBorder,
          width: 0.93.w,
        ),
        boxShadow: [
          // Drop shadow 1: X: 0, Y: 0.93, Blur: 1.86, Spread: 0, rgba(0, 0, 0, 0.05)
          BoxShadow(
            color: AppColors.profileCardShadow1,
            offset: Offset(0, 0.93.h),
            blurRadius: 1.86.r,
            spreadRadius: 0,
          ),
          // Drop shadow 2: X: 0, Y: 0, Blur: 0, Spread: 0.93, rgba(0, 0, 0, 0.03)
          BoxShadow(
            color: AppColors.profileCardShadow2,
            offset: Offset.zero,
            blurRadius: 0,
            spreadRadius: 0.93.r,
          ),
        ],
      ),
      child: Column(
        children: [
          
          _buildInfoRow(
            iconAsset: 'assets/profile/email.png',
            title: 'Email Address',
            subtext: (_profileData?['email']?.toString().isNotEmpty == true) 
                ? _profileData!['email'] 
                : 'N/A',
            hasTopBorder: true,
          ),

          // Aadhar Number
          _buildInfoRow(
            iconAsset: 'assets/profile/gender.png', // Using existing icon
            title: 'Aadhar Number',
            subtext: (_profileData?['aadhar_no']?.toString().isNotEmpty == true) 
                ? _profileData!['aadhar_no'] 
                : 'N/A',
            hasTopBorder: true,
          ),

          // 4. Address
          _buildInfoRow(
            iconAsset: 'assets/profile/address.png',
            title: 'Address',
            subtext: (_profileData?['address']?.toString().isNotEmpty == true) 
                ? _profileData!['address'] 
                : 'N/A',
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
            child: Image.asset(
              iconAsset,
              fit: BoxFit.contain,
            ),
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

  /// Displays the "Change Profile Photo" modal bottom sheet matching the UI design.
  void _showChangePhotoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.bottomSheetBg,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
            20.w,
            20.h,
            20.w,
            MediaQuery.of(sheetContext).padding.bottom + 16.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: Title + Subtitle on left, Close icon on right
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Change Profile Photo',
                          style: GoogleFonts.manrope(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.bottomSheetTitle,
                            letterSpacing: -0.45,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Choose an option to update your profile photo',
                          style: GoogleFonts.manrope(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.bottomSheetSubtitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(sheetContext).pop(),
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: Icon(
                        Icons.close,
                        size: 22.r,
                        color: AppColors.bottomSheetCloseIcon,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Divider(
                height: 1.h,
                thickness: 1.h,
                color: AppColors.bottomSheetDivider,
              ),
              SizedBox(height: 16.h),

              // 1. Take Photo container (border: 1px solid #F3F4F6, shadow: 0 1px 2px #0000000D, bg: #FFFFFF, radius: 16px)
              _buildBottomSheetOption(
                iconAsset: 'assets/profile/photo.png',
                iconBgColor: AppColors.bottomSheetGreenIconBg,
                title: 'Take Photo',
                subtitle: 'Use camera to capture instant photo',
                titleColor: AppColors.bottomSheetItemTitle,
                chevronColor: AppColors.bottomSheetChevron,
                bgColor: AppColors.bottomSheetCardBg,
                borderColor: AppColors.bottomSheetCardBorder,
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.bottomSheetCardShadow,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                ],
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Take Photo selected'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              SizedBox(height: 12.h),

              // 2. Choose from Gallery container (border: 1px solid #F3F4F6, shadow: 0 1px 2px #0000000D, bg: #FFFFFF, radius: 16px)
              _buildBottomSheetOption(
                iconAsset: 'assets/profile/gallery.png',
                iconBgColor: AppColors.bottomSheetGreenIconBg,
                title: 'Choose from Gallery',
                subtitle: 'Browse device storage or photos',
                titleColor: AppColors.bottomSheetItemTitle,
                chevronColor: AppColors.bottomSheetChevron,
                bgColor: AppColors.bottomSheetCardBg,
                borderColor: AppColors.bottomSheetCardBorder,
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.bottomSheetCardShadow,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                ],
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Choose from Gallery selected'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              SizedBox(height: 12.h),

              // 3. Remove Photo container (border: 1px solid #FFE4E6, shadow: 0 1px 2px #0000000D, bg: #FFF1F24D, radius: 16px)
              _buildBottomSheetOption(
                iconAsset: 'assets/profile/delete.png',
                iconBgColor: AppColors.bottomSheetRedIconBg,
                title: 'Remove Photo',
                subtitle: 'Delete current picture and use initials/avatar',
                titleColor: AppColors.bottomSheetDeleteText,
                chevronColor: AppColors.bottomSheetDeleteChevron,
                bgColor: AppColors.bottomSheetDeleteBg,
                borderColor: AppColors.bottomSheetDeleteBorder,
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.bottomSheetCardShadow,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                ],
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Photo removed'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              SizedBox(height: 18.h),

              // Cancel button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14.r),
                  onTap: () => Navigator.of(sheetContext).pop(),
                  child: Container(
                    width: double.infinity,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: AppColors.bottomSheetCancelBg,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.bottomSheetCancelText,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds an option card in the bottom sheet with 16px border radius,
  /// specified border, box-shadow, background color, and Manrope text.
  Widget _buildBottomSheetOption({
    required String iconAsset,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required Color titleColor,
    required Color chevronColor,
    required Color bgColor,
    required Color borderColor,
    required List<BoxShadow> boxShadow,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: borderColor,
          width: 1.w,
        ),
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Row(
              children: [
                // Icon badge container
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.all(11.r),
                  child: Image.asset(
                    iconAsset,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 14.w),

                // Text contents (Manrope)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.manrope(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        subtitle,
                        style: GoogleFonts.manrope(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.bottomSheetItemSubtitle,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),

                // Trailing chevron
                Icon(
                  Icons.chevron_right,
                  size: 20.r,
                  color: chevronColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
