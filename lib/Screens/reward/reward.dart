import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Home_Sections/drawers_screen.dart';

const Color kScreenBg = Color(0xFFF7F7F7);
const Color kHeroTitleBase = Color(0xFF0B1A30);
const Color kHeroTitleSpan = Color(0xFF018F46);
const Color kHeroSubtitle = Color(0xFF50607A);
const Color kAccentBar = Color(0xFF018F46);
const Color kProviderCardBg = Color(0xFFFFFDF4);
const Color kProviderCardBorder = Color(0xFFFDECB2);
const Color kProviderHeading = Color(0xFF0B1C33);
const Color kProviderBody = Color(0xFF5B687C);

// ----------------------------------------------------------------------
// STAT CARD DATA
// ----------------------------------------------------------------------
class _StatCardData {
  final String number;
  final String label;
  final String iconAsset;
  final Color numberColor;
  final Color cardBg;
  final Color cardBorder;

  const _StatCardData({
    required this.number,
    required this.label,
    required this.iconAsset,
    required this.numberColor,
    required this.cardBg,
    required this.cardBorder,
  });
}

// NOTE: only the "38+" card's exact colors were visible in the Figma
// inspector (bg #FFFDF4 / border #FDECB2 75% / number #B45A00). The
// other 3 cards' colors below are matched by eye from the screenshot —
// open each card in Figma and swap these if you want pixel-exact hex.
const List<_StatCardData> _statCards = [
  _StatCardData(
    number: '38+',
    label: 'Years of\nTrust &\nService',
    iconAsset: 'assets/reward/trust.png',
    numberColor: Color(0xFFB45A00),
    cardBg: Color(0xFFFFFDF4),
    cardBorder: Color(0xFFFDECB2),
  ),
  _StatCardData(
    number: '10+',
    label: 'Branches\nAcross Tamil\nNadu',
    iconAsset: 'assets/reward/branch.png',
    numberColor: Color(0xFF1E3A8A),
    cardBg: Color(0xFFEFF3FF),
    cardBorder: Color(0xFFC7D6FA),
  ),
  _StatCardData(
    number: '50,000+',
    label: 'Happy\nMembers\nand Growing',
    iconAsset: 'assets/reward/growth.png',
    numberColor: Color(0xFF018F46),
    cardBg: Color(0xFFECFDF5),
    cardBorder: Color(0xFFA7F3D0),
  ),
  _StatCardData(
    number: '500+',
    label: 'Chit Groups Conducted',
    iconAsset: 'assets/reward/group.png',
    numberColor: Color(0xFF9F1239),
    cardBg: Color(0xFFFEF1F2),
    cardBorder: Color(0xFFFBC7CB),
  ),
];

// ----------------------------------------------------------------------
// SCREEN
// ----------------------------------------------------------------------
class RewardsAchievementsScreen extends StatefulWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  const RewardsAchievementsScreen({super.key, this.onBackTap, this.onMenuTap});

  @override
  State<RewardsAchievementsScreen> createState() => _RewardsAchievementsScreenState();
}

class _RewardsAchievementsScreenState extends State<RewardsAchievementsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: kScreenBg,
        onDrawerChanged: (isOpened) {
          if (widget.onMenuTap == null) {
            setState(() {
              _isDrawerOpen = isOpened;
            });
          }
        },
        drawer: widget.onMenuTap == null ? const DrawersScreen() : null,
        appBar: AppBar(
          backgroundColor: kScreenBg,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.black, size: 24.sp),
            onPressed: () {
              if (widget.onMenuTap != null) {
                widget.onMenuTap!();
              } else {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
          title: Text(
            'Rewards & Achievements',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
        ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            SizedBox(height: 24.h),
            _buildStatGrid(),
            SizedBox(height: 16.h),
            _buildProviderCard(),
            SizedBox(height: 16.h),
            _buildBottomBanner(),
          ],
        ),
      ),
    ));
  }

  // ---------------------------- HERO ----------------------------
  Widget _buildHeroSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 26.sp,
                    height: 35 / 26,
                    letterSpacing: -0.65,
                    color: kHeroTitleBase,
                  ),
                  children: [
                    const TextSpan(text: 'A Legacy of\n'),
                    TextSpan(
                      text: 'Trust & Excellence',
                      style: TextStyle(color: kHeroTitleSpan),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Recognised for our commitment to reliable chit fund services.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 11.45.sp,
                  color: kHeroSubtitle,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                width: 40.31.w,
                height: 3.21.h,
                decoration: BoxDecoration(
                  color: kAccentBar,
                  borderRadius: BorderRadius.circular(9161.r),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Image.asset(
          'assets/reward/Trophy.png',
          width: 89.w,
          height: 80.41.h,
        ),
      ],
    );
  }

  // ---------------------------- STAT GRID ----------------------------
  Widget _buildStatGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _StatCard(data: _statCards[0])),
            SizedBox(width: 12.w),
            Expanded(child: _StatCard(data: _statCards[1])),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _StatCard(data: _statCards[2])),
            SizedBox(width: 12.w),
            Expanded(child: _StatCard(data: _statCards[3])),
          ],
        ),
      ],
    );
  }

  // ---------------------------- TRUSTED PROVIDER CARD ----------------------------
  Widget _buildProviderCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.79.w, 13.86.h, 14.79.w, 13.86.h),
      decoration: BoxDecoration(
        color: kProviderCardBg,
        borderRadius: BorderRadius.circular(14.79.r),
        border: Border.all(
          color: kProviderCardBorder.withValues(alpha: 0.8),
          width: 0.92,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/reward/service.png',
            width: 51.75.w,
            height: 51.75.h,
          ),
          SizedBox(width: 14.w),
          Container(width: 1, height: 60.h, color: kProviderCardBorder),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trusted Financial Services Provider',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 14.79.sp,
                    height: 20.33 / 14.79,
                    color: kProviderHeading,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Recognised for our transparency and customer commitment.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 11.55.sp,
                    height: 17.33 / 11.55,
                    color: kProviderBody,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------- BOTTOM BANNER ----------------------------
  Widget _buildBottomBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Stack(
        children: [
          Image.asset(
            'assets/reward/banner.png',
            width: double.infinity,
            height: 137.h,
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// One stat card in the 2x2 grid.
// ----------------------------------------------------------------------
class _StatCard extends StatelessWidget {
  final _StatCardData data;
  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.5.w,
      height: 100.5.h,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: data.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: data.cardBorder.withValues(alpha: 0.75),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.number,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                  fontSize: 23.sp,
                  height: 1.0,
                  letterSpacing: -0.57,
                  color: data.numberColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                data.label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                  height: 1.3,
                  color: const Color(0xFF374151),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(data.iconAsset, width: 42.w, height: 42.h),
          ),
        ],
      ),
    );
  }
}