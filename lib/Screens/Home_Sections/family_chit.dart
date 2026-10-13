import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/Screens/Home_Sections/drawers_screen.dart';
import 'package:siva_saravana/services/chit_scheme_api.dart';
import 'package:siva_saravana/services/translation_service.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';

class AppColors {
  static const Color scaffoldBackground = Color(0xFFF3F3F5);
  static const Color primary = Color(0xFF0C8A4B);
  static const Color white = Colors.white;
  static const Color textDark = Colors.black87;
  static const Color textGrey = Colors.grey;
  static const Color textBody = Colors.black;
  static const Color textLightGrey = Colors.grey;
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color activeGreenDot = Colors.greenAccent;
  static const Color unpricedBg = Color(0xFFFFF7E6);
  static const Color unpricedBorder = Colors.orangeAccent;
  static const Color unpricedText = Colors.orange;
  static const Color startCalBg = Color(0xFFE0F2FE);
  static const Color startCalIcon = Colors.blue;
  static const Color endCalBg = Color(0xFFF3E8FF);
  static const Color endCalIcon = Colors.purple;
}

class FamilyChitScreen extends StatefulWidget {
  final VoidCallback? onMenuTap;

  const FamilyChitScreen({super.key, this.onMenuTap});

  @override
  State<FamilyChitScreen> createState() => _FamilyChitScreenState();
}

class _FamilyChitScreenState extends State<FamilyChitScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  bool _isLoading = true;
  List<dynamic> _familyChits = [];

  @override
  void initState() {
    super.initState();
    _fetchFamilyChits();
  }

  Future<void> _fetchFamilyChits() async {
    setState(() => _isLoading = true);
    try {
      final response = await ChitSchemeApiService.fetchPaymentChits();
      if (mounted) {
        if (response != null && response['family_chits'] is List) {
          final list = List<dynamic>.from(response['family_chits']);
          setState(() {
            _familyChits = list;
            _isLoading = false;
          });
        } else {
          setState(() {
            _familyChits = [];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _familyChits = [];
          _isLoading = false;
        });
      }
    }
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return '0';
    final n = num.tryParse(amount.toString());
    if (n != null) {
      return n.toStringAsFixed(0);
    }
    return amount.toString();
  }

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
        backgroundColor: AppColors.scaffoldBackground,
        onDrawerChanged: (isOpened) {
          if (widget.onMenuTap == null) {
            setState(() {
              _isDrawerOpen = isOpened;
            });
          }
        },
        drawer: widget.onMenuTap == null ? const DrawersScreen() : null,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldBackground,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu, color: AppColors.textDark, size: 24.sp),
            onPressed: () {
              if (widget.onMenuTap != null) {
                widget.onMenuTap!();
              } else {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
          titleSpacing: 0,
          surfaceTintColor: Colors.transparent,
          title: TrText(
            'Family Chit',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Stack(
          children: [
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _fetchFamilyChits,
                    child: _familyChits.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: 180.h),
                              Center(
                                child: TrText(
                                  'No family chits found.',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            itemCount: _familyChits.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 6.h),
                                child: _buildFamilyChitCard(
                                  index,
                                  _familyChits[index],
                                ),
                              );
                            },
                          ),
                  ),
            const ChatboxWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyChitCard(int index, dynamic chit) {
    final String name = chit['name']?.toString() ?? '';
    final String groupDetail =
        chit['group_detail']?.toString() ??
        chit['group_name']?.toString() ??
        '';
    final String status = chit['status']?.toString() ?? 'Active';
    final String chitValue =
        chit['chit_value_display']?.toString() ??
        _formatAmount(chit['chit_value']);
    final String priceStatus = chit['prize_status']?.toString() ?? '-';
    final String startDate =
        chit['start_date_display']?.toString() ??
        chit['start_date']?.toString() ??
        '-';
    final String endDate =
        chit['end_date_display']?.toString() ??
        chit['end_date']?.toString() ??
        '-';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0x44FEF3C7),
          width: 0.8.w,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 2),
            blurRadius: 6,
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 8),
            blurRadius: 24,
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Green Header Bar: Avatar, Member Name, Group Badge, Active Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              color: AppColors.primary,
              child: Row(
                children: [
                  // White circular avatar with person icon
                  Container(
                    width: 28.w,
                    height: 28.w,
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/payment_profile.png',
                      width: 10.w,
                      height: 10.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Name & Group badge in Expanded
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 6.w),

                        // Group badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x44FFFFFF),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Text(
                            groupDetail,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 6.w),

                  // Active status badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x55FFFFFF),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          color: const Color(0xFF00A859),
                          size: 8.w,
                        ),
                        SizedBox(width: 4.w),
                        TrText(
                          status,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Card Body (White section)
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Chit Value & Status Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TrText(
                            'CHIT VALUE',
                            style: TextStyle(
                              color: const Color(0xFF6B7280),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            chitValue.startsWith('₹') ? chitValue : '₹ $chitValue',
                            style: TextStyle(
                              color: AppColors.textBody,
                              fontSize: 16.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      // Pill Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF2E8),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: const Color(0xFFFFE0CC),
                            width: 1.0.w,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              color: const Color(0xFFE05A17),
                              size: 13.sp,
                            ),
                            SizedBox(width: 4.w),
                            TrText(
                              priceStatus,
                              style: TextStyle(
                                color: const Color(0xFFE05A17),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  // Row 2: Start Date & End Date Container Box
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: const Color(0xFFF3F4F6),
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Left: Start Date
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 28.w,
                                height: 28.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(7.r),
                                  border: Border.all(
                                    color: const Color(0xFFDBEAFE),
                                    width: 1.w,
                                  ),
                                ),
                                child: Icon(
                                  Icons.calendar_today_outlined,
                                  color: const Color(0xFF0D6EFD),
                                  size: 14.sp,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    TrText(
                                      'START',
                                      style: TextStyle(
                                        color: AppColors.textLightGrey,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      startDate,
                                      style: TextStyle(
                                        color: AppColors.textDark,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Divider
                        Container(
                          height: 24.h,
                          width: 1.w,
                          color: const Color(0xFFE5E7EB),
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                        ),

                        // Right: End Date
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 28.w,
                                height: 28.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAF5FF),
                                  borderRadius: BorderRadius.circular(7.r),
                                  border: Border.all(
                                    color: const Color(0xFFF3E8FF),
                                  ),
                                ),
                                child: Icon(
                                  Icons.calendar_today_outlined,
                                  color: const Color(0xFFA855F7),
                                  size: 14.sp,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    TrText(
                                      'END',
                                      style: TextStyle(
                                        color: AppColors.textLightGrey,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      endDate,
                                      style: TextStyle(
                                        color: AppColors.textDark,
                                        fontSize: 11.5.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
