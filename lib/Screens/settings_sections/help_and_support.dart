import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// The Help & Support ("Need Help?") screen matching the design:
/// - White header with back arrow
/// - Background #F3F3F5
/// - Black greeting "Hi Akhil,\nHow can we help ?"
/// - 12px border-radius search bar
/// - "Chat with us" pill button with chat_with_us.png
/// - "Contact us" card with General Enquiry, Collection/Payment Support, and Email
class HelpAndSupportScreen extends StatefulWidget {
  final String userName;

  const HelpAndSupportScreen({
    super.key,
    this.userName = 'Akhil',
  });

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.appBarIcon,
            size: 22.r,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        titleSpacing: 0,
        title: Text(
          'Need Help?',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            height: 1.0,
            letterSpacing: 0,
            color: AppColors.appBarTitle,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            color: AppColors.appBarDivider,
            height: 1.h,
          ),
        ),
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            overscroll: false,
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 36.h),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Black Greetings
                  Text(
                    'Hi ${widget.userName},\nHow can we help ?',
                    style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.helpGreeting,
                      height: 1.25,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // 2. Subtitle
                  Text(
                    'Search a topic or find your query in the FAQs',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.helpSubtitle,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: 18.h),

                  // 3. Search Bar Container (12px border radius)
                  Container(
                    height: 51.h,
                    decoration: BoxDecoration(
                      color: AppColors.searchBarBg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.searchBarBorder,
                        width: 1.w,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.searchBarShadow,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: AppColors.searchBarText,
                            ),
                            decoration: InputDecoration(
                              hintText: 'How can we help you ?',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.searchBarHint,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.search,
                          size: 24.r,
                          color: AppColors.searchBarIcon,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // 4. "Chat with us" pill button
                  Center(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24.r),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Starting chat...'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.chatButtonBg,
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Chat with us',
                                style: GoogleFonts.inter(
                                  color: AppColors.chatButtonText,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Image.asset(
                                'assets/help_and_support/chat_with_us.png',
                                width: 22.r,
                                height: 22.r,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // 5. Subtext under Chat button
                  Center(
                    child: Text(
                      'Chat to ${widget.userName} 24/7 or one of our team',
                      style: GoogleFonts.inter(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.helpSubtitle,
                      ),
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // 6. Section Heading: "Contact us"
                  Text(
                    'Contact us',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.contactHeading,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // 7. Contact Us Card Container (General Enquiry, Collection/Payment Support, Email)
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: AppColors.contactCardBg,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.contactCardBorder,
                        width: 1.w,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.contactCardShadow,
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Row 1: General Enquiry
                        _buildContactRow(
                          iconAsset: 'assets/help_and_support/call.png',
                          title: 'General Enquiry',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Calling General Enquiry...'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        Divider(
                          height: 1.h,
                          thickness: 1.h,
                          color: AppColors.contactDivider,
                        ),

                        // Row 2: Collection/Payment Support
                        _buildContactRow(
                          iconAsset: 'assets/help_and_support/call.png',
                          title: 'Collection/Payment Support',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Calling Collection/Payment Support...'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        Divider(
                          height: 1.h,
                          thickness: 1.h,
                          color: AppColors.contactDivider,
                        ),

                        // Row 3: Email
                        _buildContactRow(
                          iconAsset: 'assets/help_and_support/email.png',
                          title: 'Email',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Opening Email Support...'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds an interactive contact row with rounded icon badge, title, and chevron.
  Widget _buildContactRow({
    required String iconAsset,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            children: [
              // Icon Badge (rounded square with border)
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: AppColors.contactIconBadgeBg,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColors.contactIconBadgeBorder,
                    width: 1.w,
                  ),
                ),
                padding: EdgeInsets.all(9.r),
                child: Image.asset(
                  iconAsset,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 14.w),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.contactItemTitle,
                    letterSpacing: 0,
                  ),
                ),
              ),

              // Chevron right icon
              Icon(
                Icons.chevron_right,
                size: 26.r,
                color: AppColors.contactChevron,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
