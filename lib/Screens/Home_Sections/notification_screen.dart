import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_saravana/constants/app_assets.dart';
import '../../constants/app_colors.dart';
import 'drawers_screen.dart';

/// Model representing a single notification item
class NotificationItemData {
  final String iconAsset;
  final String title;
  final String subtitle;
  final String? highlightedSubtitlePart; // e.g. "15 Sep 2026"
  final String time;
  final Color timeColor;
  final Color dotColor;
  final VoidCallback? onTap;

  const NotificationItemData({
    required this.iconAsset,
    required this.title,
    required this.subtitle,
    this.highlightedSubtitlePart,
    required this.time,
    required this.timeColor,
    required this.dotColor,
    this.onTap,
  });
}

class NotificationScreen extends StatefulWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  const NotificationScreen({super.key, this.onBackTap, this.onMenuTap});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Dot & Time Color definitions matching Figma design
  static const Color _greenDot = Color(0xFF00A859);
  static const Color _redDot = Color(0xFFDC2626);
  static const Color _orangeDot = Color(0xFFF59E0B);
  static const Color _purpleDot = Color(0xFF7C3AED);

  static const Color _timeGreen = Color(0xFF00A859);
  static const Color _timeDark = Color(0xFF374151);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  late final List<NotificationItemData> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      // 1. Auction Date Announced
      const NotificationItemData(
        iconAsset: AppAssets.notifAuctionDate,
        title: 'Auction Date Announced',
        subtitle:
            'Your chit auction for “Monthly Savings Chit”\nis Scheduled for ',
        highlightedSubtitlePart: '15 Sep 2026',
        time: '10:30 AM',
        timeColor: _timeGreen,
        dotColor: _greenDot,
      ),

      // 2. Auction Reminder
      const NotificationItemData(
        iconAsset: AppAssets.notifAuctionReminder,
        title: 'Auction Reminder',
        subtitle:
            'Your upcoming chit auction is tomorrow.\nCheck the auction details.',
        time: '09:00 AM',
        timeColor: _timeGreen,
        dotColor: _greenDot,
      ),

      // 3. Payment Due
      const NotificationItemData(
        iconAsset: AppAssets.notifPaymentDue,
        title: 'Payment Due',
        subtitle: 'Your ₹5,000 chit payment is due on\n10 Sep 2026.',
        time: 'Yesterday , 8:45 PM',
        timeColor: _timeGreen,
        dotColor: _redDot,
      ),

      // 4. Payment Successful
      const NotificationItemData(
        iconAsset: AppAssets.notifPaymentSuccessful,
        title: 'Payment Successful',
        subtitle:
            'Your ₹5,000 payment for “Monthly\nSavings Chit”Was  Successfully received.',
        time: 'Yesterday ,11:45 PM',
        timeColor: _timeGreen,
        dotColor: _greenDot,
      ),

      // 5. Payment Due Tomorrow
      const NotificationItemData(
        iconAsset: AppAssets.notifDueTomorrow,
        title: 'Payment Due Tomorrow',
        subtitle:
            'Your upcoming chit installment is due\ntomorrow. Pay on time to avoid\ndelays.',
        time: 'Today ,9:00 AM',
        timeColor: _timeGreen,
        dotColor: _orangeDot,
      ),

      // 6. Overdue Payment
      const NotificationItemData(
        iconAsset: AppAssets.notifOverduePayment,
        title: 'Overdue Payment',
        subtitle:
            'Your ₹5,000 installment is overdue.\nPlease make your payment as soon as\npossible.',
        time: '2 Sep, 7:30 PM',
        timeColor: _timeGreen,
        dotColor: _orangeDot,
      ),

      // 7. Enrollment Confirmed
      const NotificationItemData(
        iconAsset: AppAssets.notifEnrollmentConfirmed,
        title: 'Enrolllment Confirmed',
        subtitle:
            'Your enrolllment in “Monthly Savings\nChit-₹1 Lakh”has been successfully confirmed.',
        time: '1 Sep, 10:20 AM',
        timeColor: _timeDark,
        dotColor: _purpleDot,
      ),

      // 8. New Chit Enrollment
      const NotificationItemData(
        iconAsset: AppAssets.notifNewChitEnrollment,
        title: 'New Chit Enrollment',
        subtitle:
            'You have successfully joined a new chit group.\nView your chit details.',
        time: '1 Sep, 10:20 AM',
        timeColor: _timeDark,
        dotColor: _purpleDot,
      ),

      // 9. Welcome to SIVA SARAVANA!
      const NotificationItemData(
        iconAsset: AppAssets.notifWelcome,
        title: 'Welcome to SIVA SARAVANA!',
        subtitle:
            'Your account has been created successfully.\nStart managing your chit plans with ease.',
        time: '9:30 AM',
        timeColor: _timeDark,
        dotColor: _purpleDot,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

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
        backgroundColor: AppColors.background,
        onDrawerChanged: (isOpened) {
          if (widget.onMenuTap == null) {
            setState(() {
              _isDrawerOpen = isOpened;
            });
          }
        },
        drawer: widget.onMenuTap == null ? const DrawersScreen() : null,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu, color: const Color(0xFF1E1E1E), size: 24.sp),
            onPressed: () {
              if (widget.onMenuTap != null) {
                widget.onMenuTap!();
              } else {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
          title: Text(
          'Notification',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E1E1E),
          ),
        ),
        titleSpacing: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          // 2. Scrollable Notification List
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(
                top: 6.h,
                bottom: bottomPadding > 0 ? bottomPadding + 20.h : 30.h,
              ),
              itemCount: _notifications.length,
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1.h,
                  thickness: 0.5.h,
                  color: const Color(0xFFE5E7EB),
                );
              },
              itemBuilder: (context, index) {
                final item = _notifications[index];
                return _buildNotificationCard(item);
              },
            ),
          ),
        ],
      ),
    ));
  }


  Widget _buildNotificationCard(NotificationItemData item) {
    return InkWell(
      onTap: item.onTap ??
          () {
            // Placeholder click action / feedback
          },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading Icon Asset
            ClipRRect(
              borderRadius: BorderRadius.circular(22.r),
              child: Image.asset(
                item.iconAsset,
                width: 44.w,
                height: 44.h,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: item.dotColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_none,
                      color: item.dotColor,
                      size: 22.sp,
                    ),
                  );
                },
              ),
            ),

            SizedBox(width: 14.w),

            // Text and Time Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row: Notification Title on left, Time + Dot on right
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title Text
                      Expanded(
                        child: Text(
                          item.title,
                          style: GoogleFonts.inter(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111827),
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(width: 6.w),

                      // Time Text
                      Text(
                        item.time,
                        style: GoogleFonts.inter(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w600,
                          color: item.timeColor,
                          letterSpacing: -0.1,
                        ),
                      ),

                      SizedBox(width: 5.w),

                      // Colored Status Dot
                      Container(
                        width: 6.5.r,
                        height: 6.5.r,
                        decoration: BoxDecoration(
                          color: item.dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Subtitle / Description Text (with optional bold green highlighted part)
                  if (item.highlightedSubtitlePart != null)
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          color: const Color(0xFF4B5563),
                          height: 1.35,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(text: item.subtitle),
                          TextSpan(
                            text: item.highlightedSubtitlePart,
                            style: GoogleFonts.inter(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00A859),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Text(
                      item.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        color: const Color(0xFF4B5563),
                        height: 1.35,
                        fontWeight: FontWeight.w400,
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
