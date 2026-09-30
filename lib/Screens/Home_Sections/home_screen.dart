import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/Screens/Home_Sections/notification_screen.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import '../../constants/app_colors.dart';
import '../../widgets/chit_enquiry.dart';
import '../chit_schemes/chitschema.dart';
import 'need_help_screen.dart';
import '../settings_sections/faq.dart';
import '../../services/profile_view_api.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onMyChitsTap;
  final VoidCallback? onPaymentTap;
  const HomeScreen({super.key, this.onMenuTap, this.onMyChitsTap, this.onPaymentTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'Hello Akhil';

  @override
  void initState() {
    super.initState();
    _fetchProfileName();
  }

  Future<void> _fetchProfileName() async {
    final response = await ProfileViewApiService.fetchProfile();
    if (response != null && response['error'] == false) {
      final profile = response['profile'];
      if (profile != null && profile['name'] != null) {
        setState(() {
          _userName = "Hello ${profile['name']}";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = AppColors.primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Color(0xFFF3F3F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black, size: 24.w),
          onPressed: widget.onMenuTap ?? () {},
        ),
        title: Text(
          _userName,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NeedHelpScreen()),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFF9B9B9B), width: 0.5),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/scheme_images/need_help.png',
                    width: 16.w,
                    height: 16.h,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Need Help ?',
                    style: TextStyle(color: primaryColor, fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
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
      body: Stack(
        children: [
          SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Image.asset(
              'assets/home_images/home_banner.png',
              width: double.infinity,
              height: 150.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150.h,
                color: primaryColor.withOpacity(0.2),
                child: const Center(
                  child: Text('assets/home_images/home_banner.png missing'),
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
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Horizontal Cards (My Chit, Available Chits, Chit Scheme)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                children: [
                  Expanded(
                    child: _buildCategoryCard(
                      'My Chit',
                      'Chit Overview',
                      const [Color(0xFFFFFFFF), Color(0xFF43D389)],
                      'assets/home_images/book.png',
                      onTap: widget.onMyChitsTap,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _buildCategoryCard(
                      'Available Chits',
                      'View available chit plans',
                      const [Color(0xFFFFFFFF), Color(0xFFE9C958)],
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
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _buildCategoryCard(
                      'Chit Scheme',
                      'Explore available chit plans',
                      const [Color(0xFFFFFFFF), Color(0xFFD23D51)],
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
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Payment Due Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Color(0xFFD7D7D7)),
                ),
                padding: EdgeInsets.all(14.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12.r,
                              backgroundColor: primaryColor,
                              child: Icon(
                                Icons.currency_rupee,
                                color: Colors.white,
                                size: 15.w,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Payment Due',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp,
                                        color: primaryColor,
                                      ),
                                    ),
                                    SizedBox(width: 90.w),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        'View Details >',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  'You have 1 pending payment',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      height: 24.h,
                      color: Color(0xFFD7D7D7),
                      thickness: 0.5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Due Date',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '25 May 2025',
                              style: TextStyle(
                                color: Color(0xFFDB1111),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amount',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '5,000',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (widget.onPaymentTap != null) {
                              widget.onPaymentTap!();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD40909),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                          child: Text(
                            'Pay Now',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Payment Assistance Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFAFAFA),
                  border: Border.all(color: Color(0xFFEEEAEA), width: 0.8),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x14000000), // #00000014
                      offset: const Offset(0, 8),
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: const Color(0x0A000000), // #0000000A
                      offset: const Offset(0, 0),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Assistance',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Need help paying your due?\nContact your agent.',
                          style: TextStyle(
                            color: Color(0xFF767676),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) =>
                              _buildNeedHelpBottomSheet(context),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Text(
                        'Call Now',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Plan Your Growth Section
            Container(
              color: primaryColor,
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 16.h,
                bottom: 20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Let\'s Plan Your Growth',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
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
                  SizedBox(height: 16.h),
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
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox(),
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
                                'Or',
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
                                              const ChitSchemaScreen(initialTab: 0),
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
            // Explore Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 180.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildExploreCard(
                          '10,00,000',
                          '10,000',
                          true,
                          primaryColor,
                        ),
                        SizedBox(width: 16.w),
                        _buildExploreCard(
                          '50,00,000',
                          '700',
                          true,
                          primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Quick Links Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Links',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildQuickLinkCard(
                    "assets/home_images/quick_link1.png",
                    'About Siva Saravana Chits ( P ) LTD',
                    'About Siva Saravana Chits ( P ) LTD',
                  ),
                  SizedBox(height: 15.h),
                  _buildQuickLinkCard(
                    'assets/home_images/quick_link2.png',
                    'Faq',
                    'Frequently asked questions',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FAQScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
      const ChatboxWidget(),
      ],
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
        height: 70.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [-0.07, 0.9],
          ),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Color(0xFFF4F2F2), width: 0.68),
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
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
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
                  SizedBox(height: 5.h),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 7.sp, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreCard(
    String amount,
    String subAmount,
    bool isPopular,
    Color primaryColor,
  ) {
    return Container(
      width: 260.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Color(0xFFE4E4E4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x14000000), // #00000014
            offset: const Offset(0, 8),
            blurRadius: 16,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0x0A000000), // #0000000A
            offset: const Offset(0, 0),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '14 slots left',
                style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
              ),
              if (isPopular)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE8E8),
                    border: Border.all(color: Color(0xFFDA5353)),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'Popular',
                    style: TextStyle(color: Color(0xFFDA5353), fontSize: 10.sp),
                  ),
                ),
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            '₹ $amount',
            style: TextStyle(
              color: primaryColor,
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Subscription - ₹ $subAmount',
            style: TextStyle(color: primaryColor, fontSize: 14.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            'Installments - 50 months',
            style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
          ),
          Text(
            'Start date : 01 Oct, 2026',
            style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
          ),
          SizedBox(height: 15.h),
          SizedBox(
            width: double.infinity,
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ChitEnquirySheet(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: Text(
                    'Enquire now',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinkCard(String imagePath, String title, String subtitle, {VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x14000000), // #00000014
            offset: const Offset(0, 8),
            blurRadius: 16,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0x0A000000), // #0000000A
            offset: const Offset(0, 0),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ListTile(
        leading: Image.asset(imagePath, height: 25.h, width: 25.w),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey, fontSize: 12.sp),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
          size: 12.w,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildNeedHelpBottomSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 20.w, color: Colors.grey[600]),
              ),
            ),
          ),
          Text(
            'Need help?',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'We\'re here to assist with your chit plans & queries.',
            style: TextStyle(fontSize: 14.sp, color: Color(0xFF64748B)),
          ),
          SizedBox(height: 15.h),
          _buildHelpCard(
            icon: Icons.phone_outlined,
            title: 'General Enquiry',
            subtitle: 'Account, group & plan queries',
            badgeText: '9 AM - 6 PM',
            badgeColor: const Color(0xFFE6F4EA),
            badgeTextColor: const Color(0xFF137333),
            phoneNumber: '+91 90 4783 4783',
          ),
          SizedBox(height: 10.h),
          _buildHelpCard(
            icon: Icons.headset_mic_outlined,
            title: 'Collection Support',
            subtitle: 'Payment, dues & settlement',
            badgeText: 'Priority',
            badgeColor: Colors.grey[200]!,
            badgeTextColor: Colors.grey[700]!,
            phoneNumber: '+91 98 4329 9444',
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildHelpCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String phoneNumber,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Color(0xFFF1FBF9)),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Color(0xFFE2E8F0)),
                ),
                child: Icon(icon, color: const Color(0xFF334155), size: 15.w),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Divider(color: Color(0xFFE2E8F0), height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                phoneNumber,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF22378A), // Dark blue
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669), // Green
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 3.h,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Call', style: TextStyle(fontSize: 14.sp)),
                    SizedBox(width: 4.w),
                    Icon(Icons.arrow_forward, size: 16.w),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
