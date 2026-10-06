import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/Screens/Home_Sections/need_help_screen.dart';
import 'package:siva_saravana/Screens/Home_Sections/notification_screen.dart';
import 'package:siva_saravana/constants/app_colors.dart';
import 'package:siva_saravana/Screens/statements/chit_statement.dart';
import 'package:siva_saravana/Screens/statements/passbook_statement.dart';
import 'package:siva_saravana/Screens/Prebitting/prebid_detail.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import 'package:intl/intl.dart';
import '../../services/profile_view_api.dart';

class MyChitDetailScreen extends StatefulWidget {
  final dynamic chitItem;
  const MyChitDetailScreen({super.key, required this.chitItem});

  @override
  State<MyChitDetailScreen> createState() => _MyChitDetailScreenState();
}

class _MyChitDetailScreenState extends State<MyChitDetailScreen> {
  String _userName = '';
  Timer? _auctionTimer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _fetchProfileName();
    _startAuctionTimer();
  }

  @override
  void dispose() {
    _auctionTimer?.cancel();
    super.dispose();
  }

  void _startAuctionTimer() {
    String dateStr = widget.chitItem['Auction Date']?.toString() ?? '';
    String timeStr = widget.chitItem['Auction Time']?.toString() ?? '';

    if (dateStr.isEmpty || dateStr == '0') return;

    DateTime? targetDate;
    try {
      if (timeStr.isNotEmpty) {
        // Simple heuristic: check if timeStr is e.g. "10:30 AM" or "14:30"
        // Try parsing concatenated string first
        try {
          targetDate = DateTime.parse('$dateStr $timeStr');
        } catch (e) {
          // If parsing fails, just use the date
          targetDate = DateTime.parse(dateStr);
        }
      } else {
        targetDate = DateTime.parse(dateStr);
      }
    } catch (e) {
      return;
    }

    if (targetDate != null) {
      _updateTimeLeft(targetDate);
      _auctionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        _updateTimeLeft(targetDate!);
      });
    }
  }

  void _updateTimeLeft(DateTime targetDate) {
    final now = DateTime.now();
    if (targetDate.isAfter(now)) {
      setState(() {
        _timeLeft = targetDate.difference(now);
      });
    } else {
      setState(() {
        _timeLeft = Duration.zero;
      });
      _auctionTimer?.cancel();
    }
  }

  Future<void> _fetchProfileName() async {
    final response = await ProfileViewApiService.fetchProfile();
    if (mounted && response != null && response['error'] == false) {
      final profile = response['profile'];
      if (profile != null && profile['name'] != null) {
        setState(() {
          _userName = profile['name'];
        });
      }
    }
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return '0';
    try {
      final formatter = NumberFormat('#,##,###');
      if (amount is int) return formatter.format(amount);
      if (amount is double) return formatter.format(amount);
      if (amount is String) return formatter.format(double.parse(amount));
    } catch (e) {
      return amount.toString();
    }
    return amount.toString();
  }

  String _formatDate(dynamic dateString) {
    if (dateString == null ||
        dateString == '0' ||
        dateString.toString().isEmpty)
      return '-';
    try {
      final DateTime parsed = DateTime.parse(dateString.toString());
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (e) {
      return dateString.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F5),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        titleSpacing: 0,
        title: Text(
          'Chits detail',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
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
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Color(0xFF9B9B9B), width: 0.5.w),
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
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w),
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
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _buildChitHeaderCard(),
                SizedBox(height: 15.h),
                _buildRunningBalance(),
                SizedBox(height: 12.h),
                _buildChitDuration(),
                SizedBox(height: 15.h),
                _buildActionButtons(),
                SizedBox(height: 16.h),
                _buildPrebiddingSection(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
          const ChatboxWidget(),
        ],
      ),
    );
  }

  Widget _buildChitHeaderCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Color(0xFFE2E5E8), width: 0.6),
        boxShadow: [
          BoxShadow(
            color: const Color(0x40000000),
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      // Removed outer padding so inner containers can expand full width
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: const Color(0x33018F46),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/home_images/persons.png',
                        height: 24.h,
                        width: 24.w,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$_userName - ${widget.chitItem['Chit_id']?.toString() ?? ''}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.sp,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Text(
                                'GROUP CODE ',
                                style: TextStyle(
                                  color: Color(0xFF475569),
                                  fontSize: 12.sp,
                                ),
                              ),
                              Text(
                                widget.chitItem['Group Name']?.toString() ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(color: const Color(0x66A7F3D0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFF008744),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            widget.chitItem['Chit Status']?.toString() ??
                                '',
                            style: TextStyle(
                              color: const Color(0xFF00562E),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
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
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chit Value',
                          style: TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '₹ ${_formatAmount(widget.chitItem['Chit Value'])}',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Date',
                          style: TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _formatDate(widget.chitItem['Start Date']),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End Date',
                          style: TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _formatDate(widget.chitItem['End Date']),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5FF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/home_images/arrow.png',
                  width: 24.w,
                  height: 24.h,
                ),
                SizedBox(width: 12.w),
                Text(
                  'TOTAL DIVIDEND',
                  style: TextStyle(
                    color: const Color(0xFF022C22),
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '₹ ${_formatAmount(widget.chitItem['Total Dividend'] ?? 0)}',
                  style: TextStyle(
                    color: const Color(0xFF003E21), // Dark green color
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRunningBalance() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8DE), // Light yellow bg
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFD9AB07)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Coins icon placeholder or material icon
          Image.asset(
            'assets/home_images/coin_plant.png',
            width: 28.w,
            height: 28.h,
          ),
          SizedBox(width: 12.w),
          Text(
            'RUNNING BALANCE',
            style: TextStyle(
              color: Color(0xFF022C22),
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            '₹ ${_formatAmount(widget.chitItem['Running Balance'])}',
            style: TextStyle(
              color: const Color(0xFF003E21), // Dark green
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChitDuration() {
    num paidDue = 0;
    if (widget.chitItem['Paid Due'] != null && widget.chitItem['Paid Due'].toString().toLowerCase() != 'null') {
      paidDue = num.tryParse(widget.chitItem['Paid Due'].toString()) ?? 0;
    } else {
      paidDue = num.tryParse(widget.chitItem['Due']?.toString() ?? '0') ?? 0;
    }
    num noIns = num.tryParse(widget.chitItem['No Ins']?.toString() ?? '1') ?? 1;
    if (noIns < 1) noIns = 1;

    double progress = (noIns > 1 && paidDue > 1)
        ? (paidDue - 1) / (noIns - 1)
        : 0.0;
    if (progress > 1.0) progress = 1.0;
    if (progress < 0.0) progress = 0.0;

    int remaining = (noIns - paidDue).toInt();
    if (remaining < 0) remaining = 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x10000000),
            offset: const Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chit Duration',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Color(0xFF1E293B),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '${paidDue.toInt()}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: Color(0xFF1E293B),
                  ),
                  children: [
                    TextSpan(
                      text: ' / ${noIns.toInt()} Months',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Builder(
            builder: (context) {
              double totalWidth =
                  1.sw - 75.w; // account for horizontal paddings
              double dotWidth = 12.w;
              double trackWidth = totalWidth - dotWidth;

              List<int> milestones = [1];
              for (int i = 5; i < noIns.toInt(); i += 5) {
                milestones.add(i);
              }
              if (!milestones.contains(noIns.toInt())) {
                milestones.add(noIns.toInt());
              }
              milestones.sort();

              return Column(
                children: [
                  // Track and Tooltip
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Invisible container to set height and width
                      SizedBox(height: 12.h, width: totalWidth),
                      // Grey Track Wrapping Green Track
                      Positioned(
                        left: dotWidth / 2,
                        child: Container(
                          height: 12.h,
                          width: trackWidth,
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: Color(0x99E2E8F0),
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: (trackWidth - 4.w) * progress,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF0D9488)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                        ),
                      ),
                      // Tooltip
                      if (paidDue > 0)
                        Positioned(
                          left:
                              (dotWidth / 2) + ((trackWidth - 4.w) * progress),
                          top: -6.h,
                          child: FractionalTranslation(
                            translation: Offset(-0.5, 0),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF059669),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    '${paidDue.toInt()}th',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                CustomPaint(
                                  size: Size(12.w, 6.h),
                                  painter: TrianglePainter(
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Milestones below the track
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(height: 40.h, width: totalWidth),
                      ...milestones.map((m) {
                        double factor = (noIns > 1)
                            ? (m - 1) / (noIns - 1)
                            : 1.0;
                        bool isCompleted = m <= paidDue;

                        return Positioned(
                          left: (dotWidth / 2) + (trackWidth * factor),
                          top: 0,
                          child: FractionalTranslation(
                            translation: Offset(-0.5, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: isCompleted
                                      ? Color(0xFF059669)
                                      : Color(0xFFCBD5E1),
                                  size: 10.sp,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  '$m',
                                  style: TextStyle(
                                    color: isCompleted
                                        ? Color(0xFF047857)
                                        : Color(0xFF94A3B8),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, color: Color(0xFF059669), size: 13.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Completed: ${paidDue.toInt()}',
                    style: TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.circle, color: Color(0xFFCBD5E1), size: 13.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Remaining: $remaining',
                    style: TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChitStatementScreen(chitId: widget.chitItem['Chit_id']),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF4558A2), // Blueish purple
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/faq/statement.png',
                    width: 20.w,
                    height: 20.h,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chit Statement',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 20.w,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PassbookStatementScreen(
                    chitId: widget.chitItem['Chit_id'],
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF7BB22D), // Light green block
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/faq/passbook.png',
                    width: 20.w,
                    height: 20.h,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Passbook',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 20.w,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrebiddingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prebidding',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12.h),
        // Time Left Banner
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xB2E2CEF6), // Light purple
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Color(0xFFF3E8FF)),
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/home_images/clock.png',
                width: 30.w,
                height: 30.w,
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time Left',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Auction Countdown',
                    style: TextStyle(fontSize: 10.sp, color: Color(0xFF505255)),
                  ),
                ],
              ),
              const Spacer(),
              _buildCountdownBlock(_timeLeft.inDays.toString().padLeft(2, '0'), 'Days'),
              Text(
                ':',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
              _buildCountdownBlock((_timeLeft.inHours % 24).toString().padLeft(2, '0'), 'Hours'),
              Text(
                ':',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
              _buildCountdownBlock((_timeLeft.inMinutes % 60).toString().padLeft(2, '0'), 'Minutes'),
              Text(
                ':',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
              _buildCountdownBlock((_timeLeft.inSeconds % 60).toString().padLeft(2, '0'), 'Seconds'),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        // Auction Details
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFE2EDF8),
            border: Border.all(color: Color(0xFFF1F5F9)), // Light blue grey
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/home_images/auction.png',
                    width: 25.w,
                    height: 25.w,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Auction Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Divider(color: Color(0xFFCDD2DA), thickness: 0.7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auction Date',
                        style: TextStyle(
                          color: Color(0xFF505255),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _formatDate(widget.chitItem['Auction Date']),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 30.h, color: Color(0xFFCDD2DA)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Auction No.',
                        style: TextStyle(
                          color: Color(0xFF505255),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        widget.chitItem['Auction No']?.toString() ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 30.h, color: Color(0xFFCDD2DA)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auction Time',
                        style: TextStyle(
                          color: Color(0xFF505255),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        widget.chitItem['Auction Time']?.toString() ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        // Previous Auction Detail
        Container(
          height: 100.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Color(0xFFD4D4D4)),
          ),
          child: Row(
            children: [
              Container(
                width: 90.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9A21E), // Orange/Gold
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(8.r),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/home_images/auction.gif',
                      width: 50.w,
                      height: 50.w,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Previous Auction Detail',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                'assets/home_images/date.png',
                                width: 24.w,
                                height: 24.w,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                'assets/home_images/bid_amount.png',
                                width: 24.w,
                                height: 24.w,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                'assets/home_images/prize_amount.png',
                                width: 24.w,
                                height: 24.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Auction Date',
                                  style: TextStyle(
                                    color: Color(0xFF505255),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  _formatDate(widget.chitItem['Prev Auction Date']),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 0.8,
                            height: 35.h,
                            color: Color(0xFFA7A7A7),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Bid Amount',
                                  style: TextStyle(
                                    color: Color(0xFF505255),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  _formatAmount(widget.chitItem['Prev Bid Amount'] ?? 0),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.sp,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 0.8,
                            height: 35.h,
                            color: Color(0xFFA7A7A7),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Prized Amount',
                                  style: TextStyle(
                                    color: Color(0xFF505255),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  _formatAmount(widget.chitItem['Prev Prize Amount'] ?? 0),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.sp,
                                    color: Color(0xFF059669),
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
        ),
        SizedBox(height: 10.h),
        Center(
          child: Text(
            'Pre-Bidding closes 2 hours before the auction',
            style: TextStyle(
              color: Color(0xFFDA5353),
              fontSize: 12.sp,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        // Prebid Button
        SizedBox(
          width: double.infinity,
          height: 40.h,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrebiddingDetailScreen(
                    groupName: widget.chitItem['Group Name']?.toString() ?? '',
                    groupCode: widget.chitItem['Chit_id']?.toString() ?? '',
                    auctionDateTime: DateTime.now().add(const Duration(days: 1)),
                    lastAuctionAmount: double.tryParse(widget.chitItem['Prev Bid Amount']?.toString() ?? '0') ?? 0.0,
                    chitId: widget.chitItem['Chit_id']?.toString() ?? '',
                    grpId: widget.chitItem['group_id']?.toString() ?? '',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Prebid',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 15.w),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20.w),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountdownBlock(String value, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(fontSize: 8.sp, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
