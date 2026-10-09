import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/Screens/Home_Sections/drawers_screen.dart';
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

  const FamilyChitScreen({Key? key, this.onMenuTap}) : super(key: key);

  @override
  State<FamilyChitScreen> createState() => _FamilyChitScreenState();
}

class _FamilyChitScreenState extends State<FamilyChitScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  List<bool> selectedFamilyChits = [true, true, true];

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
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              if (widget.onMenuTap != null) {
                widget.onMenuTap!();
              } else {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
            child: const Icon(Icons.menu, color: AppColors.textDark),
          ),
          titleSpacing: 0,
          surfaceTintColor: Colors.transparent,
          title: Text(
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
            ListView(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              children: [
                _buildFamilyChitCard(
                  0,
                  'Harish',
                  'Unpriced',
                  '₹10,00,000',
                  '01 Jan 2024',
                  '31 Aug 2025',
                ),
                SizedBox(height: 10.h),
                _buildFamilyChitCard(
                  1,
                  'Harish',
                  'Unpriced',
                  '₹10,00,000',
                  '01 Jan 2024',
                  '31 Aug 2025',
                ),
                SizedBox(height: 10.h),
                _buildFamilyChitCard(
                  2,
                  'Harish',
                  'Unpriced',
                  '₹10,00,000',
                  '01 Jan 2024',
                  '31 Aug 2025',
                ),
              ],
            ),
            const ChatboxWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyChitCard(
    int index,
    String name,
    String priceStatus,
    String chitValue,
    String startDate,
    String endDate,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFamilyChits[index] = !selectedFamilyChits[index];
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selectedFamilyChits[index]
                ? AppColors.primary
                : const Color(0x44FEF3C7),
            width: 0.8.w,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0A000000),
              offset: const Offset(0, 2),
              blurRadius: 6,
              spreadRadius: -1,
            ),
            BoxShadow(
              color: const Color(0x0F000000),
              offset: const Offset(0, 8),
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
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
                    SizedBox(width: 10.w),

                    // Name
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Group badge "10 - L"
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0x44FFFFFF),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Text(
                        '10 - L',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Active status badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0x55FFFFFF),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            color: Color(0xFF00A859),
                            size: 10.w,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Active',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),

                    // Checkbox
                    Container(
                      width: 22.w,
                      height: 22.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: AppColors.white,
                          width: 1.6.w,
                        ),
                        color: selectedFamilyChits[index]
                            ? AppColors.white
                            : Colors.transparent,
                      ),
                      child: selectedFamilyChits[index]
                          ? Icon(
                              Icons.check,
                              size: 15.sp,
                              color: AppColors.primary,
                            )
                          : null,
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
                    // Row 1: Chit Value & Unpriced Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CHIT VALUE',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              chitValue,
                              style: TextStyle(
                                color: AppColors.textBody,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        // Unpriced Pill Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFF2E8),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Color(0xFFFFE0CC),
                              width: 1.0.w,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                color: Color(0xFFE05A17),
                                size: 13.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                priceStatus,
                                style: TextStyle(
                                  color: Color(0xFFE05A17),
                                  fontSize: 11.5.sp,
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
                                    color: Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(7.r),
                                    border: Border.all(
                                      color: Color(0xFFDBEAFE),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.calendar_today_outlined,
                                    color: Color(0xFF0D6EFD),
                                    size: 14.sp,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
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
                                    color: Color(0xFFFAF5FF),
                                    borderRadius: BorderRadius.circular(7.r),
                                    border: Border.all(color: Color(0xFFF3E8FF))
                                  ),
                                  child: Icon(
                                    Icons.calendar_today_outlined,
                                    color: Color(0xFFA855F7),
                                    size: 14.sp,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
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
      ),
    );
  }
}
