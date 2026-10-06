import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_assets.dart';
import '../../services/login_api.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final String _selectedCountryCode = '+91';
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onGetOtp() async {
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your mobile number';
      });
      return;
    }

    if (phoneNumber.length != 10) {
      setState(() {
        _errorMessage = 'Please enter a valid 10-digit mobile number';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    final response = await LoginApiService.login(phoneNumber);

    setState(() {
      _isLoading = false;
    });

    if (response != null && response['error'] == false) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(
            phoneNumber: phoneNumber,
            token: response['token'] ?? '',
            isNewUser: response['is_new_user'] ?? false,
          ),
        ),
      );
    } else {
      setState(() {
        _errorMessage = response?['error_msg'] ?? 'Something went wrong';
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _errorMessage!,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
          behavior: SnackBarBehavior.fixed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = ScreenUtil().statusBarHeight;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset:
          false, // Prevents bottom button from jumping up when keyboard opens
      body: Stack(
        children: [
          // 1. Watermark logo matching Figma inspector (Width: 420px, Height: 550px, Top: 408px, Left: 69px, Opacity: 8%)
          Positioned(
            top: 408.h,
            left: 69.w,
            width: 420.w,
            height: 550.h,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.08,
                child: Image.asset(
                  AppAssets.logo,
                  fit: BoxFit.contain,
                  alignment: Alignment.topLeft,
                ),
              ),
            ),
          ),

          // 2. Main content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: topPadding > 0 ? 12.h : 20.h),

                  // Top Navigation Bar: Back arrow on left & Progress indicator in center
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Back button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(20.r),
                          child: Container(
                            width: 32.r,
                            height: 32.r,
                            alignment: Alignment.centerLeft,
                            child: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFF1E1E1E),
                              size: 22,
                            ),
                          ),
                        ),
                      ),

                      // Center 2-step progress pill indicator (Group 12 in Figma: Step 1 active)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 18.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            width: 5.h,
                            height: 5.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 48.h),

                  // Title: "Login to manage\nyour chit account?"
                  Text(
                    'Login to manage\nyour chit account?',
                    style: GoogleFonts.inter(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF000000),
                      height: 38 / 30,
                      letterSpacing: -0.5,
                    ),
                  ),

                  SizedBox(height: 18.h),

                  // Subtitle: "Access your chit account and manage\nyour payments with ease."
                  Text(
                    'Access your chit account and manage\nyour payments with ease.',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xB3000000), // 70% opacity black
                      height: 18 / 14,
                    ),
                  ),

                  SizedBox(height: 28.h),

                  // Phone Number Input Row
                  Row(
                    children: [
                      // Country Code Selector (+91)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: const Color(0xFFD1D5DB),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedCountryCode,
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1E1E1E),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 10.w),

                      // Phone input field with dash-formatted placeholder
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: _errorMessage != null
                                  ? Colors.redAccent
                                  : const Color(0xFFD1D5DB),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF1E1E1E),
                                letterSpacing: 1.2,
                              ),
                              onChanged: (value) {
                                if (_errorMessage != null) {
                                  setState(() {
                                    _errorMessage = null;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: 'Enter mobile number',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (_errorMessage != null) ...[
                    SizedBox(height: 6.h),
                    Padding(
                      padding: EdgeInsets.only(left: 68.w),
                      child: Text(
                        _errorMessage!,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],

                  const Spacer(),

                  // Get OTP Button
                  SizedBox(
                    width: double.infinity,
                    height: 45.h,
                    child: ElevatedButton(
                      onPressed: _onGetOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBackground,
                        foregroundColor: AppColors.textWhite,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(68.r),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              'Get OTP',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
