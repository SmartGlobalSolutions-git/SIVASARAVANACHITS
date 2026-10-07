import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/help_support_api.dart';

class NeedHelpBottomSheet extends StatefulWidget {
  const NeedHelpBottomSheet({super.key});

  @override
  State<NeedHelpBottomSheet> createState() => _NeedHelpBottomSheetState();
}

class _NeedHelpBottomSheetState extends State<NeedHelpBottomSheet> {
  String _mobile = '-';

  @override
  void initState() {
    super.initState();
    _fetchContactInfo();
  }

  Future<void> _fetchContactInfo() async {
    final contact = await HelpSupportApiService.fetchHelpSupport();
    if (mounted) {
      setState(() {
        if (contact != null) {
          final mobileStr = contact['mobile']?.toString().trim() ?? '';
          _mobile = mobileStr.isNotEmpty ? mobileStr : '-';
        }
      });
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    if (phoneNumber == '-' || phoneNumber.isEmpty) return;
    
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch phone dialer')),
          );
        }
      }
    } catch (e) {
      debugPrint('Could not launch phone dialer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          
          // Close button
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 20.sp, color: Colors.black54),
              ),
            ),
          ),
          
          Text(
            'Need help?',
            style: GoogleFonts.inter(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'We\'re here to assist with your chit plans & queries.',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 24.h),
          
          _buildHelpCard(
            icon: Icons.phone_outlined,
            title: 'General Enquiry',
            subtitle: 'Account, group & plan queries',
            badgeText: '9 AM - 6 PM',
            badgeColor: const Color(0xFFECFDF5),
            badgeTextColor: const Color(0xFF059669),
            phoneNumber: _mobile,
          ),
          SizedBox(height: 10.h),
          _buildHelpCard(
            icon: Icons.headset_mic_outlined,
            title: 'Collection Support',
            subtitle: 'Payment, dues & settlement',
            badgeText: 'Priority',
            badgeColor: Colors.grey[200]!,
            badgeTextColor: Colors.grey[700]!,
            phoneNumber: _mobile,
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String phoneNumber,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF334155),
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Timing Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          Divider(color: const Color(0xFFE2E8F0), height: 1),
          SizedBox(height: 10.h),
          
          // Phone Number and Call Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                phoneNumber,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
              
              ElevatedButton(
                onPressed: () => _makePhoneCall(phoneNumber),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Call',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.arrow_forward, size: 16.sp, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
