import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/Screens/Home_Sections/notification_screen.dart';
import 'package:siva_saravana/Screens/chit_schemes/chitschema.dart';
import '../../constants/app_colors.dart';
import 'package:siva_saravana/widgets/need_help_bottom_sheet.dart';

class FirstTimeHomeScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onPlansTap;

  const FirstTimeHomeScreen({super.key, this.onMenuTap, this.onPlansTap});

  @override
  Widget build(BuildContext context) {
    const primaryColor = AppColors.primaryColor;

    return Scaffold(
      backgroundColor: Color(0xFFF2F6F2),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Color(0xFFFDFEFE),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black, size: 24.w),
          onPressed: onMenuTap ?? () {},
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/home_images/logo.png', // Fallback, assuming logo path based on standard layout
              height: 32.h,
              errorBuilder: (context, error, stackTrace) => const Text(
                'SIVA SARAVANA',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
            child: Image.asset(
              'assets/home_images/notification.png',
              width: 24.w,
              height: 24.h,
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.h),
            // Banner 1
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.asset(
                  'assets/home_images/home_banner_1.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150.h,
                    color: primaryColor.withOpacity(0.2),
                    child: const Center(child: Text('Banner 1')),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Dot Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.w),
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.w),
                Container(
                  width: 24.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // Why Choose Us Banner
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Image.asset(
                'assets/home_images/home_banner_2.png', // Assuming this might be the "Why Choose Us" or another banner
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 80.h,
                  color: primaryColor.withOpacity(0.1),
                  child: const Center(child: Text('Why Choose Us Banner')),
                ),
              ),
            ),
            SizedBox(height: 15.h),

            // Stats Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Image.asset(
                'assets/home_images/banner_branch.png',
                width: double.infinity,
              ),
            ),
            SizedBox(height: 15.h),

            // Horizontal Cards (Chit Scheme, Available Chits)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: _buildCategoryCard(
                      'Chit Scheme',
                      'Explore available chit plans',
                      const [Color(0xFFFFFFFF), Color(0xFFDBFFED)],
                      'assets/home_images/group.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ChitSchemaScreen(initialTab: 0),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildCategoryCard(
                      'Available Chits',
                      'View available chit plans',
                      const [Color(0xFFFFFFFF), Color(0xFFFFF4CE)],
                      'assets/home_images/calender.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ChitSchemaScreen(initialTab: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Unlock Financial Growth Banner
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x14000000),
                      offset: const Offset(0, 8),
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: const Color(0x0A000000),
                      offset: const Offset(0, 0),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Unlock Financial Growth\nwith Chit Funds!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Secure Your Future with Smart\nInvestments Today!',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const NeedHelpBottomSheet(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Text(
                        'Contact Us',
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Let's Plan Your Growth Section
            Container(
              color: primaryColor,
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 24.h,
                bottom: 24.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Let\'s Plan Your Growth',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Icon(
                        Icons.radio_button_checked,
                        color: Colors.white,
                        size: 18.w,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Smart Savings Scheme',
                        style: TextStyle(color: Colors.white, fontSize: 13.sp),
                      ),
                      SizedBox(width: 16.w),
                      Icon(
                        Icons.radio_button_off,
                        color: Colors.white.withOpacity(0.5),
                        size: 18.w,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Quick Cash',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(
                        Icons.radio_button_off,
                        color: Colors.white.withOpacity(0.5),
                        size: 18.w,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Flexi Cash',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.all(16.w),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          bottom: 20,
                          child: Opacity(
                            opacity: 0.1,
                            child: Image.asset(
                              'assets/home_images/ssc_pot.png',
                              height: 120.h,
                              errorBuilder: (c, e, s) => const SizedBox(),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Investment Amount ₹',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 13.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              height: 40.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: TextField(
                                style: TextStyle(fontSize: 13.sp),
                                decoration: InputDecoration(
                                  hintText: 'ex: 1,00,000',
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 10.h,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Enter values in multiples of Lakhs (min-1 Lakh to max-1 Crore)',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Center(
                              child: Text(
                                'or',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'EMI Amount ₹',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 13.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              height: 40.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: TextField(
                                style: TextStyle(fontSize: 13.sp),
                                decoration: InputDecoration(
                                  hintText: 'ex: 1,00,000',
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 10.h,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Enter values in multiples of 5000 (min-5000 to max-5Lakhs)',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'No Of EMI\'s',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Container(
                                        height: 38.h,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: '20',
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 20.w,
                                              color: Colors.grey,
                                            ),
                                            items: ['20', '30', '40'].map((
                                              String value,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (_) {},
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'No Of Chit Members',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Container(
                                        height: 38.h,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: '20',
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 20.w,
                                              color: Colors.grey,
                                            ),
                                            items: ['20', '30', '40'].map((
                                              String value,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (_) {},
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Note:\nEnter Values In Multiples Of\nLakhs In Investment.',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Color(0xFF8E8E8E),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 120.w,
                                  height: 35.h,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ChitSchemaScreen(
                                                initialTab: 0,
                                              ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Banner and Quick Links
            SizedBox(height: 16.h),
            Image.asset(
              'assets/home_images/home_banner_3.png',
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150.h,
                color: Colors.grey[200],
                child: const Center(child: Text('Save Smart Banner')),
              ),
            ),
            SizedBox(height: 24.h),

            // Quick Links
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Links',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 4.h,
                      ),
                      leading: Image.asset(
                        'assets/home_images/quick_link1.png',
                        width: 24.w,
                        height: 24.h,
                      ),
                      title: Text(
                        'About Siva Saravana Chits ( P ) LTD',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        'About Siva Saravana Chits ( P ) LTD',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.black54,
                        size: 20.sp,
                      ),
                      onTap: () {
                        // Navigate to about screen
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    String subtitle,
    List<Color> gradientColors,
    String imagePath, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [-0.1, 1],
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Color(0xFFF4F2F2), width: 1),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 5,
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/home_images/ssc_pot.png',
                  height: 60.h,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: Color(0xFFE2F7F6),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFFDFDFDF),
                            width: 0.2,
                          ),
                        ),
                        child: Image.asset(
                          imagePath,
                          width: 14.w,
                          height: 14.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.chevron_right,
                        size: 20.w,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 10.sp, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
