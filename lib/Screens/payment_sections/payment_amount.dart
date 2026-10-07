import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/constants/app_colors.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import 'review_pay.dart';

import '../Home_Sections/drawers_screen.dart';

class PaymentAmountScreen extends StatefulWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  const PaymentAmountScreen({Key? key, this.onBackTap, this.onMenuTap}) : super(key: key);

  @override
  State<PaymentAmountScreen> createState() => _PaymentAmountScreenState();
}

class _PaymentAmountScreenState extends State<PaymentAmountScreen> {
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
        backgroundColor: const Color(0xFFF4F5F9),
        onDrawerChanged: (isOpened) {
          if (widget.onMenuTap == null) {
            setState(() {
              _isDrawerOpen = isOpened;
            });
          }
        },
        drawer: widget.onMenuTap == null ? const DrawersScreen() : null,
        appBar: AppBar(
          backgroundColor: const Color(0xFFF4F5F9),
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
            'Payment',
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
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text(
                  'My Chits Overview',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 15.h),
                _buildChitAmountCard(
                  chitAmount: '1,00,000',
                  chitId: '12345',
                  dueAmount: '20,000',
                  enteredAmount: '10,000',
                  quickActions: ['₹ 5,000', '₹ 10,000', '₹ 15,000', '₹ 20,000'],
                ),
                SizedBox(height: 15.h),
                _buildChitAmountCard(
                  chitAmount: '2,00,000',
                  chitId: '12345',
                  dueAmount: '30,000',
                  enteredAmount: '15,000',
                  quickActions: ['₹ 5,000', '₹ 10,000', '₹ 15,000', '₹ 30,000'],
                ),
                SizedBox(height: 120.h),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
              decoration: const BoxDecoration(
                color: Color(0xFFF4F5F9),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pay Selected( 2 )',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ReviewPayScreen()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0C8A4B),
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
                ],
              ),
            ),
          ),
          const ChatboxWidget(),
        ],
      ),
    ));
  }

  Widget _buildChitAmountCard({
    required String chitAmount,
    required String chitId,
    required String dueAmount,
    required String enteredAmount,
    required List<String> quickActions,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Chit Amount',
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Color(0xFFD9AB07),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      'Running',
                      style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  text: 'Chit ID ',
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
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
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0C8A4B),
            ),
          ),
          SizedBox(height: 15.h),
          Divider(color: Colors.grey.shade300),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Due Amount',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14.sp),
              ),
              Text(
                '₹ $dueAmount',
                style: TextStyle(color: const Color(0xFF0C8A4B), fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enter Amount',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14.sp),
              ),
              Container(
                width: 120.w,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF0C8A4B)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.centerRight,
                child: Text(
                  '₹ $enteredAmount',
                  style: TextStyle(color: const Color(0xFF0C8A4B), fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Divider(color: Colors.grey.shade300),
          SizedBox(height: 10.h),
          Text(
            'Quick Action',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 12.sp),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: quickActions.map((action) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  action,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12.sp),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
