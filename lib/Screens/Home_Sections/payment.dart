import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import '../payment_sections/payment_history.dart';
import '../payment_sections/payment_amount.dart';

class AppColors {
  static const Color scaffoldBackground = Color(0xFFF3F3F5);
  static const Color primary = Color(0xFF0C8A4B);
  static const Color white = Colors.white;
  static const Color textDark = Colors.black87;
  static const Color textGrey = Colors.grey;
  static const Color textBody = Colors.black;
  static const Color textLightGrey = Colors.grey;
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color cardSubContainer = Color(0xFFF8FAFC);
  static const Color cardSubDivider = Color(0xFFE2E8F0);
  static const Color checkboxInactive = Colors.grey;
  static const Color activeGreenDot = Colors.greenAccent;
  static const Color unpricedBg = Color(0xFFFFF7E6);
  static const Color unpricedBorder = Colors.orangeAccent;
  static const Color unpricedText = Colors.orange;
  static const Color startCalBg = Color(0xFFE0F2FE);
  static const Color startCalIcon = Colors.blue;
  static const Color endCalBg = Color(0xFFF3E8FF);
  static const Color endCalIcon = Colors.purple;
  static const Color viewDetailsBlue = Color(0xFF1B3C73);
  static const Color cardBorder = Color(0xFFE2E8F0);
  static const Color primaryGradientEnd = Color(0xFF096b3a);
  static const Color waveAccent = Color(0xFF4ade80);
}

class PaymentScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const PaymentScreen({Key? key, this.onBackToHome}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isMyChitsOverview = true;
  bool isIndividualChit = true;
  List<bool> selectedIndividualChits = [true, true];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            if (widget.onBackToHome != null) {
              widget.onBackToHome!();
            } else {
              Navigator.pop(context);
            }
          },
          child: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        titleSpacing: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Payment',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Tabs
              Container(
                color: AppColors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isMyChitsOverview = true),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          decoration: BoxDecoration(
                            color: isMyChitsOverview
                                ? const Color(0xFFE8F6ED)
                                : AppColors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: isMyChitsOverview
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 2.h,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'My Chits Overview',
                            style: TextStyle(
                              color: isMyChitsOverview
                                  ? AppColors.primary
                                  : AppColors.textGrey,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaymentHistory(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          decoration: BoxDecoration(
                            color: !isMyChitsOverview
                                ? const Color(0xFFE8F6ED)
                                : AppColors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: !isMyChitsOverview
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 2.h,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Payment History',
                            style: TextStyle(
                              color: !isMyChitsOverview
                                  ? AppColors.primary
                                  : AppColors.textGrey,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),

              // Buttons Individual / Family
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isIndividualChit = true),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            color: isIndividualChit
                                ? AppColors.primary
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(25.r),
                            border: Border.all(color: AppColors.primary),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Individual Chit',
                            style: TextStyle(
                              color: isIndividualChit
                                  ? AppColors.white
                                  : AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isIndividualChit = false),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            color: !isIndividualChit
                                ? AppColors.primary
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(25.r),
                            border: Border.all(color: AppColors.primary),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Family Chit',
                            style: TextStyle(
                              color: !isIndividualChit
                                  ? AppColors.white
                                  : AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // List
              Expanded(
                child: isIndividualChit
                    ? ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 5.h,
                        ),
                        children: [
                          _buildIndividualChitCard(0),
                          SizedBox(height: 15.h),
                          _buildIndividualChitCard(1),
                          SizedBox(height: 20.h),
                          Container(
                            padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Pay Selected( ${selectedIndividualChits.where((e) => e).length} )',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PaymentAmountScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(25.r),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Pay ₹ 25,000',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        children: [
                          _buildFamilyChitCard(
                            'Harish',
                            'Unpriced',
                            '₹10,00,000',
                            '01 Jan 2024',
                            '31 Aug 2025',
                          ),
                          SizedBox(height: 15.h),
                          _buildFamilyChitCard(
                            'Fazil',
                            'Unpriced',
                            '₹10,00,000',
                            '01 Jan 2024',
                            '31 Aug 2025',
                          ),
                          SizedBox(height: 15.h),
                          _buildFamilyChitCard(
                            'Kavin',
                            'Unpriced',
                            '₹10,00,000',
                            '01 Jan 2024',
                            '31 Aug 2025',
                          ),
                        ],
                      ),
              ),
            ],
          ),

          // Bot Icon
          const ChatboxWidget(),
        ],
      ),
    );
  }

  Widget _buildIndividualChitCard(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndividualChits[index] = !selectedIndividualChits[index];
        });
      },
      child: Container(
        decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
            color: selectedIndividualChits[index]
                ? AppColors.primary
                : AppColors.cardBorder,
            width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Stack(
          children: [
            // Top-right curved green decorative swoosh
            Positioned(
              top: 0,
              right: 0,
              width: 95.w,
              height: 55.h,
              child: const IgnorePointer(
                child: CustomPaint(painter: CardTopRightWavePainter()),
              ),
            ),

            // Card Inner Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row: Avatar, Name, Group, Customer Badge, Checkbox
                Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar with group icon
                      Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.groups,
                          color: AppColors.white,
                          size: 26.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),

                      // Customer Name & Group Detail
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chandru',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            RichText(
                              text: TextSpan(
                                text: 'Group Detail ',
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(
                                    text: '10-L',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // "Customer" badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.2.w,
                          ),
                        ),
                        child: Text(
                          'Customer',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(width: 10.w),

                      // Rounded Checkbox
                      Container(
                        width: 22.w,
                        height: 22.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: selectedIndividualChits[index]
                                ? AppColors.primary
                                : AppColors.checkboxInactive,
                            width: 1.6.w,
                          ),
                          color: selectedIndividualChits[index]
                              ? AppColors.primary
                              : AppColors.white,
                        ),
                        child: selectedIndividualChits[index]
                            ? Icon(
                                Icons.check,
                                size: 15.sp,
                                color: AppColors.white,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),

                // 3 Metrics Columns: Chit Value | Start - End Date | Running Balance
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  child: Row(
                    children: [
                      // Metric 1: Chit Value
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: const BoxDecoration(
                                color: AppColors.cardSubContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.account_balance_wallet_rounded,
                                color: AppColors.primary,
                                size: 17.sp,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chit Value',
                                    style: TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    '10,00,000',
                                    style: TextStyle(
                                      color: AppColors.textBody,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
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
                        height: 32.h,
                        width: 1.w,
                        color: AppColors.dividerLight,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                      ),

                      // Metric 2: Start - End Date
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: const BoxDecoration(
                                color: AppColors.cardSubContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.calendar_today_rounded,
                                color: AppColors.primary,
                                size: 15.sp,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Start - End Date',
                                    style: TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    '10 Jan 26 -\n10 Dec 26',
                                    style: TextStyle(
                                      color: AppColors.textBody,
                                      fontSize: 10.5.sp,
                                      fontWeight: FontWeight.bold,
                                      height: 1.15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Divider
                      Container(
                        height: 32.h,
                        width: 1.w,
                        color: AppColors.dividerLight,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                      ),

                      // Metric 3: Running Balance
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: const BoxDecoration(
                                color: AppColors.cardSubContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.currency_rupee_rounded,
                                color: AppColors.primary,
                                size: 16.sp,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Running Balance',
                                    style: TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    '5,00,000',
                                    style: TextStyle(
                                      color: AppColors.textBody,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
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

                SizedBox(height: 6.h),

                // Bank Account & UPI ID Container
                Container(
                  margin: EdgeInsets.fromLTRB(10.w, 2.h, 10.w, 10.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardSubContainer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      // Left: Bank Account
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 30.w,
                              height: 30.w,
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.account_balance_rounded,
                                color: AppColors.primary,
                                size: 16.sp,
                              ),
                            ),
                            SizedBox(width: 7.w),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'A/C No:',
                                    style: TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '10108011866',
                                    style: TextStyle(
                                      color: AppColors.textBody,
                                      fontSize: 11.5.sp,
                                      fontWeight: FontWeight.bold,
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

                      // Center divider
                      Container(
                        height: 24.h,
                        width: 1.w,
                        color: AppColors.cardSubDivider,
                        margin: EdgeInsets.symmetric(horizontal: 6.w),
                      ),

                      // Right: UPI ID
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 30.w,
                              height: 30.w,
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/upi.jpeg',
                                  height: 20.h,
                                  width: 20.w,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(width: 7.w),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'UPI ID:',
                                    style: TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '10108011866@ubicaps',
                                    style: TextStyle(
                                      color: AppColors.textBody,
                                      fontSize: 10.5.sp,
                                      fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    ));
  }

  Widget _buildFamilyChitCard(
    String name,
    String priceStatus,
    String chitValue,
    String startDate,
    String endDate,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
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
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
              color: AppColors.primary,
              child: Row(
                children: [
                  // White circular avatar with person icon
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 24.sp,
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
                      color: Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(10.r),
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
                      color: Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7.w,
                          height: 7.w,
                          decoration: const BoxDecoration(
                            color: AppColors.activeGreenDot,
                            shape: BoxShape.circle,
                          ),
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
                              color: AppColors.textGrey,
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            chitValue,
                            style: TextStyle(
                              color: AppColors.textBody,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
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
                          color: AppColors.unpricedBg,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.unpricedBorder,
                            width: 1.0.w,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              color: AppColors.unpricedText,
                              size: 13.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              priceStatus,
                              style: TextStyle(
                                color: AppColors.unpricedText,
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Row 2: Start Date & End Date Container Box
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 0.8.w,
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
                                  color: AppColors.startCalBg,
                                  borderRadius: BorderRadius.circular(7.r),
                                ),
                                child: Icon(
                                  Icons.calendar_today_outlined,
                                  color: AppColors.startCalIcon,
                                  size: 14.sp,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'START',
                                      style: TextStyle(
                                        color: AppColors.textLightGrey,
                                        fontSize: 9.5.sp,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      startDate,
                                      style: TextStyle(
                                        color: AppColors.textDark,
                                        fontSize: 11.5.sp,
                                        fontWeight: FontWeight.bold,
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
                          height: 26.h,
                          width: 1.w,
                          color: const Color(0xFFE2E8F0),
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
                                  color: AppColors.endCalBg,
                                  borderRadius: BorderRadius.circular(7.r),
                                ),
                                child: Icon(
                                  Icons.calendar_today_outlined,
                                  color: AppColors.endCalIcon,
                                  size: 14.sp,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'END',
                                      style: TextStyle(
                                        color: AppColors.textLightGrey,
                                        fontSize: 9.5.sp,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      endDate,
                                      style: TextStyle(
                                        color: AppColors.textDark,
                                        fontSize: 11.5.sp,
                                        fontWeight: FontWeight.bold,
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

                  SizedBox(height: 10.h),

                  // Row 3: "View Details →" Action
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View Details',
                          style: TextStyle(
                            color: AppColors.viewDetailsBlue,
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.viewDetailsBlue,
                          size: 14.sp,
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

  Widget _buildBotIcon() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.amber,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5),
        ],
      ),
      child: Icon(Icons.smart_toy, color: Colors.black87, size: 30.sp),
    );
  }
}

class CardTopRightWavePainter extends CustomPainter {
  const CardTopRightWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Main emerald wave
    final path1 = Path()
      ..moveTo(w * 0.40, 0)
      ..cubicTo(w * 0.65, h * 0.10, w * 0.80, h * 0.45, w, h * 0.85)
      ..lineTo(w, 0)
      ..close();

    final paint1 = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.primary, AppColors.primaryGradientEnd],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(path1, paint1);

    // Mint wave accent highlight
    final path2 = Path()
      ..moveTo(w * 0.28, 0)
      ..cubicTo(w * 0.58, h * 0.15, w * 0.76, h * 0.60, w, h * 1.0)
      ..lineTo(w, h * 0.85)
      ..cubicTo(w * 0.80, h * 0.45, w * 0.65, h * 0.10, w * 0.40, 0)
      ..close();

    final paint2 = Paint()..color = AppColors.waveAccent.withOpacity(0.65);

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
