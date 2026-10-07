import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/Screens/payment_sections/payment_success.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';

import '../Home_Sections/drawers_screen.dart';

class PaymentProofScreen extends StatefulWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  const PaymentProofScreen({Key? key, this.onBackTap, this.onMenuTap}) : super(key: key);

  @override
  State<PaymentProofScreen> createState() => _PaymentProofScreenState();
}

class _PaymentProofScreenState extends State<PaymentProofScreen> {
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
            'Payment Proof',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account and UPI Info Card
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

            // QR Code Card
            Image.asset(
              'assets/QR scaner.png',
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 25.h),

            // UTR Form Field
            RichText(
              text: TextSpan(
                text: 'UTR / Transaction ID ',
                style: TextStyle(color: Colors.black87, fontSize: 14.sp, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(text: '*', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter UTR / Transaction ID',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Date Form Field
            RichText(
              text: TextSpan(
                text: 'Payment Date ',
                style: TextStyle(color: Colors.black87, fontSize: 14.sp, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(text: '*', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              decoration: InputDecoration(
                hintText: '08/20/2025',
                hintStyle: TextStyle(color: Colors.black87, fontSize: 14.sp),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: Icon(Icons.calendar_today_outlined, color: Colors.grey.shade500, size: 20.sp),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Upload Screenshot
            RichText(
              text: TextSpan(
                text: 'Upload Payment Screenshot ',
                style: TextStyle(color: Colors.black87, fontSize: 14.sp, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(text: '*', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid), // Dashed normally, using solid for simplicity or use CustomPaint if needed
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F6ED),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.cloud_upload_outlined, color: const Color(0xFF0C8A4B), size: 28.sp),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Click to upload screenshot',
                    style: TextStyle(color: Colors.black87, fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'JPG, PNG up to 5MB',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12.sp),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),

            // Submit Button
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentSuccessScreen()),
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
                  'Submit Payment proof',
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
}
