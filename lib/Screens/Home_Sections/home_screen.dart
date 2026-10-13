import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/Screens/Home_Sections/notification_screen.dart';
import 'package:siva_saravana/Screens/settings_sections/about_us.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import 'package:siva_saravana/widgets/need_help_bottom_sheet.dart';
import '../../constants/app_colors.dart';
import '../../widgets/chit_enquiry.dart';
import '../chit_schemes/chit_schemes.dart';
import 'need_help_screen.dart';
import '../settings_sections/faq.dart';
import '../../services/profile_view_api.dart';
import '../../services/shared_prefs_helper.dart';
import '../../services/chit_scheme_api.dart';
import '../../services/translation_service.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onMyChitsTap;
  final VoidCallback? onPaymentTap;
  const HomeScreen({
    super.key,
    this.onMenuTap,
    this.onMyChitsTap,
    this.onPaymentTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = '';
  List<dynamic> _exploreChits = [];
  bool _isLoadingExplore = true;

  List<String> _bannerImages = [];
  bool _isLoadingBanners = true;
  int _currentBannerIndex = 0;
  late final PageController _bannerPageController;
  Timer? _bannerTimer;

  final TextEditingController _investmentController = TextEditingController();
  final TextEditingController _emiAmountController = TextEditingController();
  String _noOfEmis = '20';
  String _noOfMembers = '20';

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerPageController.dispose();
    _investmentController.dispose();
    _emiAmountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _bannerPageController = PageController();
    _fetchProfileName();
    _fetchExploreChits();
    _fetchHomeBanners();
  }

  Future<void> _fetchHomeBanners() async {
    final data = await ChitSchemeApiService.fetchHomeBanners();
    if (data != null && data.isNotEmpty) {
      final List<String> urls = [];
      for (var item in data) {
        if (item is Map &&
            item['file'] != null &&
            item['file'].toString().isNotEmpty) {
          urls.add(item['file'].toString());
        } else if (item is String && item.isNotEmpty) {
          urls.add(item);
        }
      }
      if (mounted) {
        setState(() {
          _bannerImages = urls;
          _isLoadingBanners = false;
        });
        _startBannerAutoScroll();
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoadingBanners = false;
        });
      }
    }
  }

  void _startBannerAutoScroll() {
    _bannerTimer?.cancel();
    if (_bannerImages.length > 1) {
      _bannerTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (_bannerPageController.hasClients) {
          final nextIndex = (_currentBannerIndex + 1) % _bannerImages.length;
          _bannerPageController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  Future<void> _fetchExploreChits() async {
    final data = await ChitSchemeApiService.fetchAvailableChits();
    if (data != null && data.isNotEmpty) {
      data.sort((a, b) {
        final aSlots = int.tryParse(a['bal_sub']?.toString() ?? '0') ?? 0;
        final bSlots = int.tryParse(b['bal_sub']?.toString() ?? '0') ?? 0;
        return bSlots.compareTo(aSlots);
      });
      if (mounted) {
        setState(() {
          _exploreChits = data;
          _isLoadingExplore = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoadingExplore = false;
        });
      }
    }
  }

  String _formatAmount(double amount) {
    if (amount % 1 == 0) {
      return NumberFormat('#,##,###').format(amount);
    }
    return NumberFormat('#,##,###.##').format(amount);
  }

  Future<void> _fetchProfileName() async {
    final savedName = await SharedPrefsHelper.getUserName();
    if (savedName.isNotEmpty) {
      if (mounted) {
        setState(() {
          _userName = savedName;
        });
      }
    }
    final response = await ProfileViewApiService.fetchProfile();
    if (response != null && response['error'] == false) {
      final profile = response['profile'];
      if (profile != null && profile['name'] != null) {
        if (mounted) {
          setState(() {
            _userName = "${profile['name']}";
          });
        }
        SharedPrefsHelper.saveUserName(_userName);
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
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black, size: 24.w),
          onPressed: widget.onMenuTap ?? () {},
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TrText(
              'Hello',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Flexible(
              child: Text(
                ' $_userName',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
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
                  TrText(
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Section
                _buildBannerSection(primaryColor),
                SizedBox(height: 16.h),

                // Horizontal Cards (My Chit, Available Chits, Chit Scheme)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                      const ChitSchemesScreen(initialTab: 1),
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
                                      const ChitSchemesScreen(initialTab: 0),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TrText(
                                    'Payment Due',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp,
                                      color: primaryColor,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  TrText(
                                    'You have 1 pending payment',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 180.h,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 10.h),
                                _buildPaymentItem(
                                  'SSC001',
                                  '25 July 2025',
                                  '5,000',
                                ),
                                SizedBox(height: 10.h),
                                _buildPaymentItem(
                                  'SSC002',
                                  '25 June 2025',
                                  '5,000',
                                ),
                                SizedBox(height: 10.h),
                                _buildPaymentItem(
                                  'SSC003',
                                  '25 May 2025',
                                  '5,000',
                                ),
                                SizedBox(height: 10.h),
                                _buildPaymentItem(
                                  'SSC004',
                                  '25 Apr 2025',
                                  '5,000',
                                ),
                                SizedBox(height: 10.h),
                                _buildPaymentItem(
                                  'SSC005',
                                  '25 Mar 2025',
                                  '5,000',
                                ),
                                SizedBox(height: 10.h),
                                _buildPaymentItem(
                                  'SSC006',
                                  '25 Feb 2025',
                                  '5,000',
                                ),
                              ],
                            ),
                          ),
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TrText(
                                'Payment Assistance',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              TrText(
                                'Need help paying your due?\nContact your agent.',
                                style: TextStyle(
                                  color: Color(0xFF767676),
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => NeedHelpBottomSheet(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                          child: TrText(
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
                      TrText(
                        'Let\'s Plan Your Growth',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 16.w,
                        runSpacing: 8.h,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle_outlined,
                                color: Colors.white,
                                size: 15.w,
                              ),
                              SizedBox(width: 6.w),
                              TrText(
                                'Smart Savings Scheme',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                color: const Color(0xFFE2E2E2),
                                size: 15.w,
                              ),
                              SizedBox(width: 6.w),
                              TrText(
                                'Quick Cash',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                color: const Color(0xFFE2E2E2),
                                size: 15.w,
                              ),
                              SizedBox(width: 6.w),
                              TrText(
                                'Flexi Cash',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
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
                                TrText(
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
                                    controller: _investmentController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(fontSize: 13.sp),
                                    decoration: InputDecoration(
                                      hintText: 'ex: 1,00,000',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 10.h,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                TrText(
                                  'Enter values in multiples of Lakhs (min-1 Lakh to max-1 Crore)',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Center(
                                  child: TrText(
                                    'Or',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                TrText(
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
                                    controller: _emiAmountController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(fontSize: 13.sp),
                                    decoration: InputDecoration(
                                      hintText: 'ex: 1,00,000',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 10.h,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                TrText(
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
                                          TrText(
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
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                color: Colors.grey.withOpacity(
                                                  0.3,
                                                ),
                                              ),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                isExpanded: true,
                                                value: _noOfEmis,
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  size: 20.w,
                                                  color: Colors.grey,
                                                ),
                                                items: ['20', '30', '40'].map((
                                                  String value,
                                                ) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
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
                                                onChanged: (val) {
                                                  if (val != null)
                                                    setState(
                                                      () => _noOfEmis = val,
                                                    );
                                                },
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
                                          TrText(
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
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                color: Colors.grey.withOpacity(
                                                  0.3,
                                                ),
                                              ),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                isExpanded: true,
                                                value: _noOfMembers,
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  size: 20.w,
                                                  color: Colors.grey,
                                                ),
                                                items: ['20', '30', '40'].map((
                                                  String value,
                                                ) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
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
                                                onChanged: (val) {
                                                  if (val != null)
                                                    setState(
                                                      () => _noOfMembers = val,
                                                    );
                                                },
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: TrText(
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
                                          Map<String, String> growthParams = {
                                            'ch_value': _investmentController
                                                .text
                                                .trim(),
                                            'emi_amount': _emiAmountController
                                                .text
                                                .trim(),
                                            'no_of_emis': _noOfEmis,
                                            'no_of_members': _noOfMembers,
                                          };
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChitSchemesScreen(
                                                    initialTab: 0,
                                                    growthPlanParams:
                                                        growthParams,
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
                                        child: TrText(
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
                      TrText(
                        'Explore',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _isLoadingExplore
                          ? const Center(child: CircularProgressIndicator())
                          : _exploreChits.isEmpty
                          ? const Center(child: TrText('No chits available'))
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: List.generate(
                                    _exploreChits.length,
                                    (index) {
                                      final chit = _exploreChits[index];
                                      final isPopular = index == 0;
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          right:
                                              index == _exploreChits.length - 1
                                              ? 0
                                              : 16.w,
                                        ),
                                        child: _buildExploreCard(
                                          chit,
                                          isPopular,
                                          primaryColor,
                                        ),
                                      );
                                    },
                                  ),
                                ),
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
                      TrText(
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutUsScreen(),
                            ),
                          );
                        },
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
        constraints: BoxConstraints(minHeight: 70.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [-0.07, 0.9],
          ),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFF4F2F2), width: 0.68),
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
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2F7F6),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFDFDFDF),
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
                      const Spacer(),
                      Icon(
                        Icons.chevron_right,
                        size: 20.w,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  TrText(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  TrText(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

  Widget _buildExploreCard(dynamic chit, bool isPopular, Color primaryColor) {
    final double chitValue =
        double.tryParse(chit['value']?.toString() ?? '0') ?? 0;
    final String amount = _formatAmount(chitValue);

    // Attempting to calculate subscription amount (installment amount) if 'subAmount' isn't directly available.
    // Assuming value / total_month = subscription amount roughly, or checking for specific keys.
    final double subAmountVal =
        chitValue /
        (double.tryParse(chit['total_month']?.toString() ?? '1') ?? 1);
    final String subAmount = _formatAmount(
      subAmountVal,
    ); // Default rough calculation if not in API

    final String slotsLeft = chit['bal_sub']?.toString() ?? '0';
    final String installments = chit['total_month']?.toString() ?? '0';

    // There is no start_date in available chits api, so use a placeholder or omit
    // Using current UI placeholder if needed, or if API provides it:
    final String startDate = chit['start_date']?.toString() ?? 'TBD';
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
      padding: EdgeInsets.all(14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$slotsLeft ',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
                  ),
                  TrText(
                    'slots left',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
                  ),
                ],
              ),
              if (isPopular)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w,),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE8E8),
                    border: Border.all(color: Color(0xFFDA5353)),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: TrText(
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
          Row(
            children: [
              TrText(
                'Subscription',
                style: TextStyle(color: primaryColor, fontSize: 14.sp),
              ),
              Text(
                ' - ₹ $subAmount',
                style: TextStyle(color: primaryColor, fontSize: 14.sp),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              TrText(
                'Installments',
                style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
              ),
              Text(
                ' - $installments ',
                style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
              ),
              TrText(
                'months',
                style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
              ),
            ],
          ),
          // Start date is typically not provided in this API so omitting or keeping placeholder
          // But I'll hide it if it's 'TBD' or just show placeholder if we want to keep UI exactly same.
          // The user instruction implies "bind the available chit" so I'll just leave it out if we don't have it or keep it as placeholder.
          if (startDate != 'TBD')
            Row(
              children: [
                TrText(
                  'Start date',
                  style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
                ),
                Text(
                  ' : $startDate',
                  style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
                ),
              ],
            )
          else
            const SizedBox(),
          SizedBox(height: 5.h),
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
                  child: TrText(
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

  Widget _buildQuickLinkCard(
    String imagePath,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
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
        title: TrText(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp),
        ),
        subtitle: TrText(
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

  Widget _buildPaymentItem(String id, String dueDate, String amount) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFD7D7D7), width: 0.5),
      ),
      child: Row(
        children: [
          // ID
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                id,
                style: TextStyle(
                  color: const Color(0xFF1E3A8A), // Dark blue
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          // Due Date
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TrText(
                  'Due Date',
                  style: TextStyle(color: Colors.grey, fontSize: 9.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    dueDate,
                    style: TextStyle(
                      color: const Color(0xFFDB1111),
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 4.w),
          // Amount
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TrText(
                  'Amount',
                  style: TextStyle(color: Colors.grey, fontSize: 9.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '₹ $amount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 4.w),
          // Button
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: SizedBox(
              height: 28.h,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.onPaymentTap != null) {
                    widget.onPaymentTap!();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD40909),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: TrText(
                    'Pay Now',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerSection(Color primaryColor) {
    if (_isLoadingBanners) {
      return Container(
        width: double.infinity,
        height: 150.h,
        color: Colors.grey.shade100,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      );
    }

    if (_bannerImages.isEmpty) {
      return Image.asset(
        'assets/home_images/home_banner.png',
        width: double.infinity,
        height: 150.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 150.h,
          color: primaryColor.withValues(alpha: 0.2),
          child: const Center(
            child: Text('assets/home_images/home_banner.png missing'),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 150.h,
          width: double.infinity,
          child: PageView.builder(
            controller: _bannerPageController,
            itemCount: _bannerImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final imageUrl = _bannerImages[index];
              return Image.network(
                imageUrl,
                width: double.infinity,
                height: 150.h,
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 150.h,
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150.h,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              );
            },
          ),
        ),
        if (_bannerImages.length > 1) ...[
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_bannerImages.length, (index) {
              final bool isSelected = index == _currentBannerIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                width: isSelected ? 24.w : 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4.r),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

