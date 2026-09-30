import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_saravana/Screens/login_sections/terms_and_conditions_screen.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_assets.dart';
import 'package:flutter/services.dart';
import '../../services/otp_api.dart';
import '../../services/shared_prefs_helper.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String token;
  final bool isNewUser;

  const OtpScreen({
    super.key, 
    required this.phoneNumber,
    required this.token,
    required this.isNewUser,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _secondsRemaining = 45;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _secondsRemaining = 45;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  String get _formattedTime {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  bool _isLoading = false;

  Future<void> _onVerify() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter all 6 digits of the OTP',
            style: GoogleFonts.inter(fontSize: 13.sp),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await OtpApiService.verifyOtp(
      mobile: widget.phoneNumber,
      otp: otp,
      token: widget.token,
    );

    setState(() {
      _isLoading = false;
    });

    if (response != null && response['error'] == false) {
      if (!mounted) return;
      
      final cusId = response['cus_id'];
      final token = response['token'];
      if (cusId != null) {
        await SharedPrefsHelper.saveCusId(cusId is int ? cusId : int.parse(cusId.toString()));
      }
      if (token != null) {
        await SharedPrefsHelper.saveToken(token.toString());
      }
      await SharedPrefsHelper.saveIsNewUser(widget.isNewUser);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['error_msg'] ?? 'OTP Verified Successfully!',
            style: GoogleFonts.inter(fontSize: 13.sp),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => TermsAndConditionsScreen(
            isNewUser: widget.isNewUser,
          ),
        ),
        (route) => false,
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response?['error_msg'] ?? 'OTP Verification Failed',
            style: GoogleFonts.inter(fontSize: 13.sp),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
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
          false, // Prevents bottom buttons from jumping up when keyboard opens
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

                      // Center 2-step progress pill indicator (Group 12 in Figma: Step 2 active)
                      Container(
                        width: 26.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                        child: Row(
                          children: [
                            const Expanded(flex: 2, child: SizedBox.shrink()),
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(3.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 48.h),

                  // Title: "Enter your OTP"
                  Text(
                    'Enter your OTP',
                    style: GoogleFonts.inter(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF000000),
                      height: 38 / 30,
                      letterSpacing: -0.5,
                    ),
                  ),

                  SizedBox(height: 14.h),

                  // Subtitle: "We've sent a 6-digit OTP to your\nregistered mobile number."
                  Text(
                    "We've sent a 6-digit OTP to your\nregistered mobile number.",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xB3000000), // 70% opacity black
                      height: 18 / 14,
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // 6 OTP digit boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 48.w,
                        height: 43.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDEDED),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Center(
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF1E1E1E),
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                if (index < 5) {
                                  _focusNodes[index + 1].requestFocus();
                                } else {
                                  _focusNodes[index].unfocus();
                                }
                              } else if (value.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: 24.h),

                  // Resend OTP and Timer Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // "Didn't receive OTP 00:45"
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(
                                0xB3000000,
                              ), // 70% opacity black
                            ),
                            children: [
                              const TextSpan(text: "Didn't receive OTP "),
                              TextSpan(
                                text: _formattedTime,
                                style: GoogleFonts.inter(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // "Resend OTP"
                      InkWell(
                        onTap: _canResend ? _startCountdown : null,
                        borderRadius: BorderRadius.circular(4.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 4.h,
                            horizontal: 4.w,
                          ),
                          child: Text(
                            'Resend OTP',
                            style: GoogleFonts.inter(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                              color: _canResend
                                  ? AppColors.primary
                                  : AppColors.primary.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Verify Button
                  SizedBox(
                    width: double.infinity,
                    height: 45.h,
                    child: ElevatedButton(
                      onPressed: _onVerify,
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
                                'Verify',
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
