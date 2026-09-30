import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/Screens/Home_Sections/need_help_screen.dart';
import 'package:siva_saravana/Screens/Home_Sections/notification_screen.dart';
import 'package:siva_saravana/constants/app_colors.dart';
import 'package:siva_saravana/Screens/statements/chit_statement.dart';
import 'package:siva_saravana/Screens/statements/passbook_statement.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import 'package:intl/intl.dart';

class MyChitDetailScreen extends StatefulWidget {
  final dynamic chitItem;
  const MyChitDetailScreen({super.key, required this.chitItem});

  @override
  State<MyChitDetailScreen> createState() => _MyChitDetailScreenState();
}

class _MyChitDetailScreenState extends State<MyChitDetailScreen> {
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
    if (dateString == null || dateString == '0' || dateString.toString().isEmpty) return '-';
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
        leadingWidth: 40.w,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24.sp,
          ),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
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
                  Image.asset('assets/scheme_images/need_help.png', width: 16.w, height: 16.h,),
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
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _buildChitHeaderCard(),
                SizedBox(height: 12.h),
                _buildRunningBalance(),
                SizedBox(height: 12.h),
                _buildChitDuration(),
                SizedBox(height: 12.h),
                _buildActionButtons(),
                SizedBox(height: 16.h),
                _buildPrebiddingSection(),
                SizedBox(height: 20.h),
                Text(
                  'Next Action Date : 01 Sep 2026',
                  style: TextStyle(
                    color: const Color(0xFF4B23A0),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8FDF2),
                  shape: BoxShape.circle,
                ),
                child: Image.asset('assets/home_images/persons.png', height: 24.h, width: 24.w,),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chitItem['Chit Name']?.toString() ?? 'Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'CHIT ID ',
                          style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                        ),
                        Text(
                          widget.chitItem['Chit_id']?.toString() ?? '',
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
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3FAF5),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFE2F5EA)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF018F46),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      widget.chitItem['Chit Status']?.toString() ?? 'Unpriced',
                      style: TextStyle(
                        color: const Color(0xFF018F46),
                        fontWeight: FontWeight.bold,
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
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '₹ ${_formatAmount(widget.chitItem['Chit Value'])}',
                    style: TextStyle(
                      color: AppColors.primaryColor,
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
                    'Start Date',
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _formatDate(widget.chitItem['Sdate']),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'End Date',
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _formatDate(widget.chitItem['Ag_date']),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(color: Colors.grey.shade200, height: 1),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/home_images/arrow.png', width: 24.w, height: 24.h,),
              SizedBox(width: 8.w),
              Text(
                'TOTAL DIVIDEND',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                '₹ ${_formatAmount(widget.chitItem['Int Amount'] ?? 0)}',
                style: TextStyle(
                  color: const Color(0xFF0F3B20), // Dark green color
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRunningBalance() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8DE), // Light yellow bg
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFFD9AB07)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Coins icon placeholder or material icon
          Image.asset('assets/home_images/coin_plant.png', width: 24.w, height: 24.h,),
          SizedBox(width: 8.w),
          Text(
            'RUNNING BALANCE',
            style: TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '₹ ${_formatAmount(widget.chitItem['cur_run_bal'])}',
            style: TextStyle(
              color: const Color(0xFF0F3B20), // Dark green
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChitDuration() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                'Chit Duration',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '${widget.chitItem['Paid Due'] ?? 0}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: ' / ${widget.chitItem['No Ins'] ?? 0} Months',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          // Custom Progress Bar representation
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Background track
              Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
              // Filled track
              FractionallySizedBox(
                widthFactor: ((widget.chitItem['Paid Due'] ?? 0) as num) / ((widget.chitItem['No Ins'] ?? 1) as num > 0 ? (widget.chitItem['No Ins'] as num) : 1),
                child: Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
              // Points along the track (1, 5, 10, 15, 20)
              _buildProgressPoint(0.0, '1', isCompleted: true),
              _buildProgressPoint(5/20, '5', isCompleted: true),
              _buildProgressPoint(10/20, '10', isCompleted: false),
              _buildProgressPoint(15/20, '15', isCompleted: false),
              _buildProgressPoint(1.0, '20', isCompleted: false),
              // The bubble on top of the current position
              Positioned(
                left: (MediaQuery.of(context).size.width - 64.w) * (((widget.chitItem['Paid Due'] ?? 0) as num) / ((widget.chitItem['No Ins'] ?? 1) as num > 0 ? (widget.chitItem['No Ins'] as num) : 1)) - 16.w, // Approximate center
                top: -18.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '${widget.chitItem['Paid Due'] ?? 0}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Completed: ${widget.chitItem['Paid Due'] ?? 0}',
                    style: TextStyle(color: Colors.black87, fontSize: 12.sp),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Remaining: ${((widget.chitItem['No Ins'] ?? 0) as num) - ((widget.chitItem['Paid Due'] ?? 0) as num)}',
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressPoint(double positionFactor, String label, {required bool isCompleted}) {
    return Positioned(
      left: (MediaQuery.of(context).size.width - 64.w) * positionFactor - 4.w, // approximation based on padding
      top: -1.h,
      child: Column(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.primaryColor : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              color: isCompleted ? AppColors.primaryColor : Colors.grey,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
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
                MaterialPageRoute(builder: (context) => ChitStatementScreen(chitId: widget.chitItem['Chit_id'])),
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
                  Icon(Icons.insert_drive_file, color: Colors.white, size: 24.w),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chit Statement',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white, size: 16.w),
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
                MaterialPageRoute(builder: (context) => PassbookStatementScreen(chitId: widget.chitItem['Chit_id'])),
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
                  Icon(Icons.menu_book, color: Colors.white, size: 24.w),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Passbook',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white, size: 16.w),
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
            color: const Color(0xFFE8DBFF), // Light purple
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Image.asset('assets/home_images/clock.png', width: 28.w, height: 28.w),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time Left',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Auction Countdown',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _buildCountdownBlock('00', 'Days'),
              Text(':', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
              _buildCountdownBlock('01', 'Hours'),
              Text(':', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
              _buildCountdownBlock('45', 'Minutes'),
              Text(':', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
              _buildCountdownBlock('30', 'Seconds'),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        // Auction Details
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2F8), // Light blue grey
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset('assets/home_images/auction.png', width: 16.w, height: 16.w),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Auction Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.blueGrey.withOpacity(0.2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Auction Date', style: TextStyle(color: Colors.blueGrey, fontSize: 10.sp)),
                      SizedBox(height: 4.h),
                      Text('12/08/2026', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp)),
                    ],
                  ),
                  Container(width: 1, height: 30.h, color: Colors.blueGrey.withOpacity(0.2)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Auction No.', style: TextStyle(color: Colors.blueGrey, fontSize: 10.sp)),
                      SizedBox(height: 4.h),
                      Text('6', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp)),
                    ],
                  ),
                  Container(width: 1, height: 30.h, color: Colors.blueGrey.withOpacity(0.2)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Auction Time', style: TextStyle(color: Colors.blueGrey, fontSize: 10.sp)),
                      SizedBox(height: 4.h),
                      Text('4:00 PM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp)),
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
          height: 80.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 110.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5A122), // Orange
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(8.r)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/home_images/auction.gif', width: 32.w, height: 32.w),
                    SizedBox(height: 4.h),
                    Text(
                      'Previous Auction\nDetail',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Auction Date', style: TextStyle(color: Colors.grey.shade800, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                          SizedBox(height: 6.h),
                          Text('12/08/2026', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: Colors.black)),
                        ],
                      ),
                      Container(width: 1, height: 40.h, color: Colors.grey.shade300),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Auction Amount', style: TextStyle(color: Colors.grey.shade800, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                          SizedBox(height: 6.h),
                          Text('50,00,000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: AppColors.primaryColor)),
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
              color: Colors.red.shade300,
              fontSize: 12.sp,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        // Prebid Button
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            onPressed: () {},
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
                SizedBox(width: 8.w),
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
            style: TextStyle(
              fontSize: 8.sp,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
