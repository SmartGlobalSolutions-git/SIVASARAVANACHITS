import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/Screens/Prebitting/terms_condition.dart';

const Color kScreenBg = Color(0xFFF7F7F7);
const Color kAuctionCardBg = Color(0xFFFFFCF0);
const Color kAuctionCardBorder = Color(0xFFE2E5E8);
const Color kLabelGrey = Color(0xFF64748B);
const Color kValueDark = Color(0xFF0F172A);
const Color kTodayBg = Color(0xFFD1FAE5);
const Color kTodayText = Color(0xFF047857);
const Color kAmountGreen = Color(0xFF018F46);
const Color kClosesRed = Color(0xFFBA1111);
const Color kTimerBoxBg = Color(0xFF22378A);
const Color kTimerBoxBorder = Color(0xFF10B981);
const Color kHeadingDark = Color(0xFF1A1C1C);
const Color kInputLabelBrown = Color(0xFF4D4732);
const Color kInputBg = Color(0xFFF9F9F9);
const Color kInputBorder = Color(0xFF7BE6AF);
const Color kTermsCardBg = Color(0xFFFFFFFF);
const Color kTermsCardBorder = Color(0xFFD0C6AB);
const Color kCheckboxGreen = Color(0xFF018F46);

// ----------------------------------------------------------------------
// SCREEN
// ----------------------------------------------------------------------
class PrebiddingDetailScreen extends StatefulWidget {
  final String groupName;
  final String groupCode;
  final DateTime auctionDateTime;
  final double lastAuctionAmount;
  final double minBid;
  final double maxBid;

  const PrebiddingDetailScreen({
    super.key,
    required this.groupName,
    required this.groupCode,
    required this.auctionDateTime,
    required this.lastAuctionAmount,
    this.minBid = 5000,
    this.maxBid = 300000,
  });

  @override
  State<PrebiddingDetailScreen> createState() =>
      _PrebiddingDetailScreenState();
}

class _PrebiddingDetailScreenState extends State<PrebiddingDetailScreen> {
  late final TextEditingController _amountController;
  bool _agreedToTerms = true;
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: '25,000');
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final diff = widget.auctionDateTime.difference(DateTime.now());
    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _amountController.dispose();
    super.dispose();
  }

  String _formatAmount(double v) {
    final String s = v.toInt().toString();
    final reversed = s.split('').reversed.toList();
    final buffer = StringBuffer();
    for (int i = 0; i < reversed.length; i++) {
      if (i != 0 && i % 3 == 0) buffer.write(',');
      buffer.write(reversed[i]);
    }
    return buffer.toString().split('').reversed.join();
  }

  bool get _isAuctionToday {
    final now = DateTime.now();
    return now.year == widget.auctionDateTime.year &&
        now.month == widget.auctionDateTime.month &&
        now.day == widget.auctionDateTime.day;
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return "${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}";
  }

  String _formatTime(DateTime d) {
    final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final minute = d.minute.toString().padLeft(2, '0');
    final period = d.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScreenBg,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAuctionDetailsCard(),
            SizedBox(height: 24.h),
            _buildCountdownRow(),
            SizedBox(height: 24.h),
            Text(
              'Pre-Bid Details',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 14.57.sp,
                height: 25.5 / 14.57,
                color: kHeadingDark,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Enter Pre-Bid Amount',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 12.75.sp,
                height: 21.85 / 12.75,
                color: kInputLabelBrown,
              ),
            ),
            SizedBox(height: 8.h),
            _buildAmountInput(),
            SizedBox(height: 6.h),
            Text(
              'Enter amount between ₹${_formatAmount(widget.minBid)} and ₹${_formatAmount(widget.maxBid)}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 10.sp,
                height: 14.57 / 10,
                letterSpacing: 0.55,
                color: kInputLabelBrown,
              ),
            ),
            SizedBox(height: 16.h),
            _buildTermsCard(context),
          ],
        ),
      ),
    );
  }

  // ---------------------------- APP BAR ----------------------------
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black, size: 20.sp),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Prebidding',
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
          color: Colors.black,
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 8.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: const Color(0xFF9B9B9B), width: 0.6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/prebitting/help.png',
                width: 14.sp,
                height: 14.sp,
                
              ),
              SizedBox(width: 4.w),
              Text(
                'Need Help ?',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 10.sp,
                  height: 1.0,
                  color: const Color(0xFF018F46),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: Image.asset(
            'assets/prebitting/notification.png',
            width: 22.sp,
            height: 22.sp,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // ---------------------------- AUCTION DETAILS CARD ----------------------------
  Widget _buildAuctionDetailsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(19.w, 19.h, 19.w, 24.h),
      decoration: BoxDecoration(
        color: kAuctionCardBg,
        borderRadius: BorderRadius.circular(7.84.r),
        border: Border.all(color: kAuctionCardBorder, width: 0.59),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row: lock icon + "Auction Details".
          Row(
            children: [
              Container(
                width: 32.sp,
                height: 32.sp,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4CD),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/prebitting/auction.png',
                  width: 16.sp,
                  height: 16.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'Auction Details',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 13.71.sp,
                  height: 19.59 / 13.71,
                  color: kValueDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          // AUCTION DATE row.
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: const Color(0xFF94A3B8), size: 16.sp),
              SizedBox(width: 8.w),
              Text(
                'AUCTION DATE',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 10.77.sp,
                  height: 16.16 / 10.77,
                  letterSpacing: 0.54,
                  color: kLabelGrey,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  _formatDate(widget.auctionDateTime),
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    fontSize: 13.71.sp,
                    height: 19.59 / 13.71,
                    color: kValueDark,
                  ),
                ),
              ),
              if (_isAuctionToday) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.88.w, vertical: 1.96.h),
                  decoration: BoxDecoration(
                    color: kTodayBg.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(3.92.r),
                  ),
                  child: Text(
                    'Today',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      fontSize: 9.79.sp,
                      height: 14.69 / 9.79,
                      color: kTodayText,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 10.h),
          // AUCTION STARTS AT row.
          Row(
            children: [
              Icon(Icons.access_time, color: const Color(0xFF94A3B8), size: 16.sp),
              SizedBox(width: 8.w),
              Text(
                'AUCTION STARTS AT',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 10.77.sp,
                  height: 16.16 / 10.77,
                  letterSpacing: 0.54,
                  color: kLabelGrey,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  _formatTime(widget.auctionDateTime),
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    fontSize: 13.71.sp,
                    height: 19.59 / 13.71,
                    color: kValueDark,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Last Auction Amount',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 15.67.sp,
                    color: kAmountGreen,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                '₹ ${_formatAmount(widget.lastAuctionAmount)}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                  color: kAmountGreen,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Center(
            child: Text(
              'Pre-Bid Closes 2 Hrs Before Start',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                fontSize: 11.75.sp,
                height: 15.67 / 11.75,
                color: kClosesRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------- COUNTDOWN ----------------------------
  Widget _buildCountdownRow() {
    final days = _remaining.inDays.toString().padLeft(2, '0');
    final hours = _remaining.inHours.remainder(24).toString().padLeft(2, '0');
    final mins = _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TimerBox(value: days, label: 'DAYS'),
        _timerSeparator(),
        _TimerBox(value: hours, label: 'HOURS'),
        _timerSeparator(),
        _TimerBox(value: mins, label: 'MINS'),
        _timerSeparator(),
        _TimerBox(value: secs, label: 'SECS'),
      ],
    );
  }

  Widget _timerSeparator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Text(
        ':',
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w800,
          fontSize: 24.22.sp,
          color: kAmountGreen,
        ),
      ),
    );
  }

  // ---------------------------- AMOUNT INPUT ----------------------------
  Widget _buildAmountInput() {
    return Container(
      width: double.infinity,
      height: 50.h,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: kInputBg,
        borderRadius: BorderRadius.circular(7.28.r),
        border: Border.all(color: kInputBorder, width: 1.82),
      ),
      child: Row(
        children: [
          Text(
            '₹',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
              color: kHeadingDark,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 18.21.sp,
                color: kHeadingDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------- TERMS CARD ----------------------------
  // Exact spec: 324 x 74.21, radius 10.86, border 0.91 #D0C6AB, bg #FFFFFF.
  Widget _buildTermsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: kTermsCardBg,
        borderRadius: BorderRadius.circular(10.86.r),
        border: Border.all(color: kTermsCardBorder, width: 0.91),
      ),
      child: Row(
        children: [
          // Checkbox — 19.91 x 19.91, radius 3.62, bg #018F46, border 0.91 #000000.
          GestureDetector(
            onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
            child: Container(
              width: 19.91.w,
              height: 19.91.h,
              decoration: BoxDecoration(
                color: _agreedToTerms ? kCheckboxGreen : Colors.white,
                borderRadius: BorderRadius.circular(3.62.r),
                border: Border.all(color: Colors.black, width: 0.91),
              ),
              alignment: Alignment.center,
              child: _agreedToTerms
                  ? Icon(
                      Icons.check,
                      size: 16.sp,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: GestureDetector(
              onTap: () => _openTermsAndConditions(context),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'I have read and agree to the\n',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: 'Pre-Bidding Terms & Conditions',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: kAmountGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _openTermsAndConditions(context),
            child: Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(
                Icons.chevron_right,
                size: 24.sp,
                color: kAmountGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openTermsAndConditions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TermsAndConditionsScreen()),
    );
  }
}

class _TimerBox extends StatelessWidget {
  final String value;
  final String label;
  const _TimerBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(8.07.w, 3.53.h, 8.07.w, 7.57.h),
          decoration: BoxDecoration(
            color: kTimerBoxBg,
            borderRadius: BorderRadius.circular(8.07.r),
            border: Border.all(
              color: kTimerBoxBorder.withValues(alpha: 0.2),
              width: 1.01,
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w800,
              fontSize: 24.22.sp,
              height: 1.0,
              letterSpacing: -0.61,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            fontSize: 9.08.sp,
            height: 13.62 / 9.08,
            letterSpacing: 0.45,
            color: kAmountGreen,
          ),
        ),
      ],
    );
  }
}

