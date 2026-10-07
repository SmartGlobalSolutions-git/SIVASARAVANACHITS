import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/chit_enquiry_api.dart';

class ChitEnquirySheet extends StatefulWidget {
  const ChitEnquirySheet({super.key});

  @override
  State<ChitEnquirySheet> createState() => _ChitEnquirySheetState();
}

class _ChitEnquirySheetState extends State<ChitEnquirySheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitEnquiry() async {
    final String name = _nameController.text.trim();
    final String mobile = _mobileController.text.trim();
    final String email = _emailController.text.trim();
    final String message = _messageController.text.trim();

    if (name.isEmpty || mobile.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill Name, Mobile Number, and Message fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await ChitEnquiryApi.submitEnquiry(
      name: name,
      mobile: mobile,
      email: email,
      remarks: message,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Enquiry submitted successfully')),
      );
      Navigator.pop(context); // Close the dialog
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Submission failed')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

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
            _buildInputField('Name', 'Enter your Name', _nameController),
            SizedBox(height: 16.h),
            _buildInputField('Mobile Number', 'Enter mobile number', _mobileController, keyboardType: TextInputType.phone),
            SizedBox(height: 16.h),
            _buildInputField('Mail ID (Optional)', 'Enter mail ID', _emailController, keyboardType: TextInputType.emailAddress),
            SizedBox(height: 16.h),
            _buildInputField('Message', 'Tell us your requirement', _messageController, maxLines: 4),
            SizedBox(height: 24.h),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitEnquiry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEAB308), // Yellow/Gold color
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 24.h,
                        width: 24.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : Row(
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

  Widget _buildInputField(String label, String hint, TextEditingController controller, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
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
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
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
