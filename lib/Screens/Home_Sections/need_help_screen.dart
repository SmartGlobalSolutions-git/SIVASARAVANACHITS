import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';

import 'package:siva_saravana/services/profile_view_api.dart';

class NeedHelpScreen extends StatefulWidget {
  final VoidCallback? onBackTap;
  const NeedHelpScreen({super.key, this.onBackTap});

  @override
  State<NeedHelpScreen> createState() => _NeedHelpScreenState();
}

class _NeedHelpScreenState extends State<NeedHelpScreen> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final response = await ProfileViewApiService.fetchProfile();
    if (mounted) {
      setState(() {
        if (response != null && response['error'] == false) {
          _userName = response['profile']?['name']?.toString() ?? 'User';
        } else {
          _userName = 'User';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light gray background matching design
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.w),
          onPressed: () {
            if (widget.onBackTap != null) {
              widget.onBackTap!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Need Help?',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text(
              'Hi ${_userName.isEmpty ? 'Loading...' : _userName},',
              style: GoogleFonts.inter(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            Text(
              'How can we help ?',
              style: GoogleFonts.inter(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Search a topic or find your query in the FAQs',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 16.h),
            
            // Search Bar
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'How can we help you ?',
                        hintStyle: GoogleFonts.inter(
                          color: Colors.black38,
                          fontSize: 14.sp,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Icon(Icons.search, color: Colors.black, size: 22.w),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Chat with us button
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Chat with us',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.support_agent, color: Colors.white, size: 20.w),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 12.h),
            
            Center(
              child: Text(
                'Chat with us 24/7 or one of our team',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            
            SizedBox(height: 32.h),
            
            Text(
              'Contact us',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Contact us list
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildContactTile(
                    icon: Icons.phone_in_talk_outlined,
                    title: 'General Enquiry',
                    onTap: () {},
                  ),
                  Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                  _buildContactTile(
                    icon: Icons.support_agent_outlined,
                    title: 'Agent Call',
                    onTap: () {},
                  ),
                  Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                  _buildContactTile(
                    icon: Icons.mail_outline,
                    title: 'Email',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Icon(
          icon,
          color: AppColors.primaryColor,
          size: 20.w,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey,
        size: 24.w,
      ),
    );
  }
}
