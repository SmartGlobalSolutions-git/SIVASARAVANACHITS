import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApprovalHistoryScreen extends StatelessWidget {
  const ApprovalHistoryScreen({Key? key}) : super(key: key);

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
          'Receipt Approval',
          style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Column(
          children: [
            // The image was blank in the screenshot, just text below it
            Image.asset('assets/pay success.gif', width: 150.w,),
            Text(
              'Payment Successful',
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xFF0C8A4B)),
            ),
            SizedBox(height: 10.h),
            Text(
              'Your payment has been completed and the\nreceipt has been generated.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600, height: 1.5),
            ),
            SizedBox(height: 30.h),
            // Details Card
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Chit Number', '1123'),
                  SizedBox(height: 15.h),
                  _buildDetailRow('Group Name', 'L-10'),
                  SizedBox(height: 15.h),
                  _buildDetailRow('Payment Date & Time', '24 Jun 2026, 9:45 AM'),
                  SizedBox(height: 15.h),
                  _buildDetailRow('Amount Paid', '₹4,12,500', isAmount: true),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment Status', style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp, fontWeight: FontWeight.w500)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F6ED),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: const Color(0xFF0C8A4B), size: 14.sp),
                            SizedBox(width: 5.w),
                            Text('Approved', style: TextStyle(color: const Color(0xFF0C8A4B), fontSize: 12.sp, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Blue Alert Box
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1B3C73),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.receipt_long, color: Colors.white, size: 30.sp),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your receipt has been generated successfully.',
                          style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'You can download or share it for your records.',
                          style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            // Download Button
            SizedBox(
              width: 250.w,
              height: 45.h,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.download, color: Colors.white, size: 20.sp),
                label: Text(
                  'Download Receipt',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C8A4B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAmount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: TextStyle(
            color: isAmount ? const Color(0xFF0C8A4B) : Colors.black87,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
