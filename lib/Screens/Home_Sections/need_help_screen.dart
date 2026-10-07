import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_saravana/Screens/growth_plan/chatbot_screen.dart';
import '../../constants/app_colors.dart';

import 'package:siva_saravana/services/profile_view_api.dart';
import '../../services/help_support_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'drawers_screen.dart';

class NeedHelpScreen extends StatefulWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  const NeedHelpScreen({super.key, this.onBackTap, this.onMenuTap});

  @override
  State<NeedHelpScreen> createState() => _NeedHelpScreenState();
}

class _NeedHelpScreenState extends State<NeedHelpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  String _userName = '';
  String _mobile = '-';
  String _email = '-';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _fetchContactInfo();
  }

  Future<void> _fetchContactInfo() async {
    final contact = await HelpSupportApiService.fetchHelpSupport();
    if (mounted) {
      setState(() {
        if (contact != null) {
          final mobileStr = contact['mobile']?.toString().trim() ?? '';
          final emailStr = contact['email']?.toString().trim() ?? '';
          _mobile = mobileStr.isNotEmpty ? mobileStr : '-';
          _email = emailStr.isNotEmpty ? emailStr : '-';
        }
      });
    }
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    if (phoneNumber == '-' || phoneNumber.isEmpty) return;
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch phone dialer')),
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _sendEmail(String emailAddress) async {
    if (emailAddress == '-' || emailAddress.isEmpty) return;
    final Uri launchUri = Uri(scheme: 'mailto', path: emailAddress);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email client')),
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

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
        backgroundColor: const Color(0xFFF5F5F5), // Light gray background matching design
        onDrawerChanged: (isOpened) {
          if (widget.onMenuTap == null) {
            setState(() {
              _isDrawerOpen = isOpened;
            });
          }
        },
        drawer: widget.onMenuTap == null ? const DrawersScreen() : null,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.black, size: 24.w),
            onPressed: () {
              if (widget.onMenuTap != null) {
                widget.onMenuTap!();
              } else {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
        title: Text(
          'Need Help?',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
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
              'Find your query in the FAQs',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 20.h),
            
            // Chat with us button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatbotScreen()),
                  );
                },
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
                    subtitle: _mobile,
                    onTap: () => _makePhoneCall(_mobile),
                  ),
                  Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                  _buildContactTile(
                    icon: Icons.support_agent_outlined,
                    title: 'Agent Call',
                    subtitle: _mobile,
                    onTap: () => _makePhoneCall(_mobile),
                  ),
                  Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                  _buildContactTile(
                    icon: Icons.mail_outline,
                    title: 'Email',
                    subtitle: _email,
                    onTap: () => _sendEmail(_email),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32.h),
          ],
        ),
      ),
      )
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    String? subtitle,
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
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey,
        size: 24.w,
      ),
    );
  }
}

