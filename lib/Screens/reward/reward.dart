import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../services/reward_api.dart';
import '../../services/translation_service.dart';
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

class _StatCardStyle {
  final String iconAsset;
  final Color numberColor;
  final Color cardBg;
  final Color cardBorder;

  const _StatCardStyle({
    required this.iconAsset,
    required this.numberColor,
    required this.cardBg,
    required this.cardBorder,
  });
}

const List<_StatCardStyle> _defaultStyles = [
  _StatCardStyle(
    iconAsset: 'assets/reward/trust.png',
    numberColor: Color(0xFFB45A00),
    cardBg: Color(0xFFFFFDF4),
    cardBorder: Color(0xFFFDECB2),
  ),
  _StatCardStyle(
    iconAsset: 'assets/reward/branch.png',
    numberColor: Color(0xFF1E3A8A),
    cardBg: Color(0xFFEFF3FF),
    cardBorder: Color(0xFFC7D6FA),
  ),
  _StatCardStyle(
    iconAsset: 'assets/reward/growth.png',
    numberColor: Color(0xFF018F46),
    cardBg: Color(0xFFECFDF5),
    cardBorder: Color(0xFFA7F3D0),
  ),
  _StatCardStyle(
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
  bool _isLoading = true;
  String? _errorMessage;

  Map<String, dynamic>? _sections;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final res = await RewardApiService.fetchRewardsAchievements();

    if (mounted) {
      if (res != null && res['error'] == false && res['sections'] != null) {
        setState(() {
          _sections = res['sections'] as Map<String, dynamic>;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = res?['error_msg'] ?? 'Failed to load rewards & achievements';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _sections?['title']?.toString() ?? 'Rewards & Achievements';
    final header = _sections?['header'] as Map<String, dynamic>?;
    final stats = _sections?['stats'] as List<dynamic>? ?? [];
    final trustedCard = _sections?['trusted_card'] as Map<String, dynamic>?;

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
          title: TrText(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: kHeroTitleSpan))
            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
                          SizedBox(height: 12.h),
                          TrText(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: _fetchData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kHeroTitleSpan,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: const TrText('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchData,
                    color: kHeroTitleSpan,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeroSection(header),
                          SizedBox(height: 24.h),
                          _buildStatGrid(stats),
                          SizedBox(height: 16.h),
                          _buildProviderCard(trustedCard),
                          SizedBox(height: 16.h),
                          _buildBottomBanner(),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  // ---------------------------- HERO ----------------------------
  Widget _buildHeroSection(Map<String, dynamic>? header) {
    final titleLine1 = header?['title_line1']?.toString() ?? '';
    final titleLine2 = header?['title_line2']?.toString() ?? '';
    final subtitle = header?['subtitle']?.toString() ?? '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (titleLine1.isNotEmpty)
                TrText(
                  titleLine1,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 26.sp,
                    height: 35 / 26,
                    letterSpacing: -0.65,
                    color: kHeroTitleBase,
                  ),
                ),
              if (titleLine2.isNotEmpty)
                TrText(
                  titleLine2,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 26.sp,
                    height: 35 / 26,
                    letterSpacing: -0.65,
                    color: kHeroTitleSpan,
                  ),
                ),
              if (subtitle.isNotEmpty) ...[
                SizedBox(height: 8.h),
                TrText(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 11.45.sp,
                    color: kHeroSubtitle,
                  ),
                ),
              ],
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
  Widget _buildStatGrid(List<dynamic> stats) {
    if (stats.isEmpty) return const SizedBox.shrink();

    List<Widget> rows = [];
    for (int i = 0; i < stats.length; i += 2) {
      final stat1 = stats[i] as Map<String, dynamic>;
      final stat2 = (i + 1 < stats.length) ? stats[i + 1] as Map<String, dynamic>? : null;

      final style1 = _defaultStyles[i % _defaultStyles.length];
      final style2 = _defaultStyles[(i + 1) % _defaultStyles.length];

      rows.add(
        Row(
          children: [
            Expanded(
              child: _StatCard(
                value: stat1['value']?.toString() ?? '',
                label: stat1['label']?.toString() ?? '',
                style: style1,
              ),
            ),
            SizedBox(width: 12.w),
            if (stat2 != null)
              Expanded(
                child: _StatCard(
                  value: stat2['value']?.toString() ?? '',
                  label: stat2['label']?.toString() ?? '',
                  style: style2,
                ),
              )
            else
              const Spacer(),
          ],
        ),
      );

      if (i + 2 < stats.length) {
        rows.add(SizedBox(height: 12.h));
      }
    }

    return Column(children: rows);
  }

  // ---------------------------- TRUSTED PROVIDER CARD ----------------------------
  Widget _buildProviderCard(Map<String, dynamic>? cardData) {
    final title = cardData?['title']?.toString() ?? '';
    final description = cardData?['description']?.toString() ?? '';

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
                if (title.isNotEmpty)
                  TrText(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 14.79.sp,
                      height: 20.33 / 14.79,
                      color: kProviderHeading,
                    ),
                  ),
                if (description.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  TrText(
                    description,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 11.55.sp,
                      height: 17.33 / 11.55,
                      color: kProviderBody,
                    ),
                  ),
                ],
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
// One stat card in the grid.
// ----------------------------------------------------------------------
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final _StatCardStyle style;

  const _StatCard({
    required this.value,
    required this.label,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.5.w,
      height: 100.5.h,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: style.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: style.cardBorder.withValues(alpha: 0.75),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                  fontSize: 23.sp,
                  height: 1.0,
                  letterSpacing: -0.57,
                  color: style.numberColor,
                ),
              ),
              SizedBox(height: 8.h),
              TrText(
                label,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
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
            child: Image.asset(style.iconAsset, width: 42.w, height: 42.h),
          ),
        ],
      ),
    );
  }
}