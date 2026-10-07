import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Home_Sections/drawers_screen.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import 'payment_proof.dart';

class PaymentMethodScreen extends StatefulWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  const PaymentMethodScreen({Key? key, this.onBackTap, this.onMenuTap}) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  int _selectedMethod = 1; // 0 for Online, 1 for NEFT/RTGS

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
            'Payment Methods',
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Amount to Pay',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5.h),
            Text(
              '₹ 25,000',
              style: TextStyle(color: const Color(0xFF0C8A4B), fontSize: 26.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30.h),
            Text(
              'Select Payment Method',
              style: TextStyle(color: Colors.black87, fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.h),

            // Online Payment Option
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMethod = 0;
                });
              },
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: _selectedMethod == 0 ? const Color(0xFF0C8A4B) : Colors.grey.shade300,
                    width: _selectedMethod == 0 ? 1.5.w : 1.w,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F5F9),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.credit_card, color: const Color(0xFF1B3C73), size: 24.sp),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Online Payment',
                            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Pay securely using UPI, Debit/Credit Card, Net Banking',
                            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      _selectedMethod == 0 ? Icons.check_circle : Icons.circle_outlined,
                      color: _selectedMethod == 0 ? const Color(0xFF0C8A4B) : Colors.grey.shade400,
                      size: 24.sp,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.h),

            // NEFT/RTGS Option
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMethod = 1;
                });
              },
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: _selectedMethod == 1 ? const Color(0xFF0C8A4B) : Colors.grey.shade300,
                    width: _selectedMethod == 1 ? 1.5.w : 1.w,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F6ED), // Light green tint
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.account_balance, color: const Color(0xFF0C8A4B), size: 24.sp),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NEFT / RTGS/QR',
                            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Pay using NEFT or RTGS and upload payment proof',
                            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      _selectedMethod == 1 ? Icons.check_circle : Icons.circle_outlined,
                      color: _selectedMethod == 1 ? const Color(0xFF0C8A4B) : Colors.grey.shade400,
                      size: 24.sp,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),
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
                  color: const Color(0xFF0C8A4B),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Continue',
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
