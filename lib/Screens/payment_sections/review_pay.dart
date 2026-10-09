import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/constants/app_colors.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import 'payment_proof.dart';

import '../Home_Sections/drawers_screen.dart';

class ReviewPayScreen extends StatefulWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  const ReviewPayScreen({Key? key, this.onBackTap, this.onMenuTap}) : super(key: key);

  @override
  State<ReviewPayScreen> createState() => _ReviewPayScreenState();
}

class _ReviewPayScreenState extends State<ReviewPayScreen> {
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
        backgroundColor: const Color(0xFFF3F3F5),
        onDrawerChanged: (isOpened) {
          if (widget.onMenuTap == null) {
            setState(() {
              _isDrawerOpen = isOpened;
            });
          }
        },
        drawer: widget.onMenuTap == null ? const DrawersScreen() : null,
        appBar: AppBar(
          backgroundColor: const Color(0xFFF3F3F5),
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          surfaceTintColor: Colors.transparent,
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
            'Review & Pay',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          children: [
            // Overview Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Chits Overview',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 15.h),
                  Divider(color: Colors.grey.shade300),
                  SizedBox(height: 10.h),
                  _buildChitSummaryItem('1,00,000', '12345', '20,000', '10,000'),
                  SizedBox(height: 15.h),
                  _buildChitSummaryItem('1,00,000', '12345', '20,000', '10,000'),
                  SizedBox(height: 15.h),
                  Divider(color: Colors.grey.shade300),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount to Pay',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 14.sp),
                      ),
                      Text(
                        '₹ 25,000',
                        style: TextStyle(color: const Color(0xFF0C8A4B), fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/scheme_images/ac.png',
                        height: 30.h,
                        width: 30.w,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 10.w),
                      Text('A/C No : ', style: TextStyle(color: Colors.grey.shade700, fontSize: 14.sp)),
                      Text('10108011866', style: TextStyle(color: const Color(0xFF1B3C73), fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Divider(color: Colors.grey.shade300),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Image.asset(
                        'assets/scheme_images/upi.png',
                        height: 30.h,
                        width: 30.w,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 10.w),
                      Text('UPI ID : ', style: TextStyle(color: Colors.grey.shade700, fontSize: 14.sp)),
                      Text('10108011866@ubicaps', style: TextStyle(color: const Color(0xFF1B3C73), fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            // Account and UPI Info Card
            Image.asset(
              'assets/QR scaner.png',
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 25.h),
            // Pay Button
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentProofScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Pay ₹ 25,000',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
          const ChatboxWidget(),
        ],
      ),
    ));
  }

  Widget _buildChitSummaryItem(String chitAmount, String chitId, String dueAmount, String payingAmount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Chit Amount',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
            ),
            RichText(
              text: TextSpan(
                text: 'Chit ID ',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
                children: [
                  TextSpan(
                    text: chitId,
                    style: TextStyle(color: const Color(0xFF0C8A4B), fontSize: 13.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Text(
          '₹ $chitAmount',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0C8A4B),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Due Amount', style: TextStyle(color: Colors.grey.shade700, fontSize: 13.sp)),
            Text('₹ $dueAmount', style: TextStyle(color: Colors.black87, fontSize: 13.sp, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Paying Amount', style: TextStyle(color: Colors.grey.shade700, fontSize: 13.sp)),
            Text('₹ $payingAmount', style: TextStyle(color: const Color(0xFF0C8A4B), fontSize: 13.sp, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
