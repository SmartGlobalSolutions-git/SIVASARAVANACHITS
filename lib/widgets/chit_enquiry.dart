import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ChitEnquirySheet extends StatelessWidget {
  const ChitEnquirySheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 24.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            // Logo
            Image.asset(
              'assets/home_images/ssc_pot.png',
              height: 60.h,
              errorBuilder: (context, error, stackTrace) =>
                  SizedBox(height: 60.h),
            ),
            SizedBox(height: 8.h),
            Text(
              'SIVA SARAVANA',
              style: GoogleFonts.inter(
                color: const Color(0xFF0F9D58),
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'CHITS ( P ) LTD',
              style: GoogleFonts.inter(
                color: const Color(0xFF0F9D58),
                fontSize: 12.sp,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Chit Enquiry',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Find the right plan for you',
              style: GoogleFonts.inter(
                color: Colors.grey[600],
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 24.h),

            // Form Fields
            _buildInputField('Name', 'Enter your Name'),
            SizedBox(height: 16.h),
            _buildInputField('Mobile Number', 'Enter mobile number'),
            SizedBox(height: 16.h),
            _buildInputField('Mail ID (Optional)', 'Enter mail ID'),
            SizedBox(height: 16.h),
            _buildInputField('Message', 'Tell us your requirement', maxLines: 4),
            SizedBox(height: 24.h),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEAB308), // Yellow/Gold color
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Submit Enquiry',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.arrow_forward, size: 20.w),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Terms text
            Text(
              'By submitting, you agree to be contacted by our team',
              style: GoogleFonts.inter(
                color: Colors.grey[500],
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),)
    );
  }

  Widget _buildInputField(String label, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          maxLines: maxLines,
          style: GoogleFonts.inter(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xFF018F46)),
            ),
          ),
        ),
      ],
    );
  }
}
