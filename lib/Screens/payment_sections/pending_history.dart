import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PendingHistoryScreen extends StatelessWidget {
  const PendingHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          'Receipt Pending',
          style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for the illustration
            Image.asset('assets/pay aprove.gif', width: 150.w,), // fallback icon
            SizedBox(height: 30.h),
            Text(
              'Receipt Pending',
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 15.h),
            Text(
              'Your payment is being processed. The\nreceipt will be generated shortly once the\npayment is confirmed.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600, height: 1.5),
            ),
            SizedBox(height: 40.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF6E4),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Color(0Xfffde6b8)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.timelapse, color: Colors.orange, size: 24.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Please check back later or refresh to\nview your receipt.',
                      style: TextStyle(color: Colors.brown.shade700, fontSize: 13.sp, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),// pushes content up slightly
          ],
        ),
      ),
    );
  }
}
