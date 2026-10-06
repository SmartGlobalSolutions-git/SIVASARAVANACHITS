import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../main_wrapper.dart';
import '../first_time_main_wrapper.dart';
import '../../services/terms_and_conditions_api.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  final bool isNewUser;

  const TermsAndConditionsScreen({super.key, this.isNewUser = false});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool _isAgreed = false;
  bool _isLoading = true;
  Map<String, dynamic>? _termsData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await TermsAndConditionsApiService.fetchTermsAndConditions();
    if (mounted) {
      setState(() {
        if (response != null && response['error'] == false) {
          _termsData = response['sections'];
        }
        _isLoading = false;
      });
    }
  }

  void _onAgreeAndContinue() {
    if (!_isAgreed) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget.isNewUser
            ? const FirstTimeMainWrapper()
            : const MainWrapper(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 1. Fixed Top Header Row: Back Arrow + Title (Fixed at top, does NOT scroll)
          Container(
            color: AppColors.background,
            padding: EdgeInsets.only(
              left: 17.w,
              right: 17.w,
              top: statusBarHeight > 0 ? statusBarHeight + 10.h : 24.h,
              bottom: 10.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back button
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.h,
                      horizontal: 2.w,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF000000),
                      size: 22,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // Title "Terms & Condition" (Font: Inter, 16px, Regular 400, #000000)
                Text(
                  _termsData?['title'] ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF000000),
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),

          // 2. Main content area with scrollable terms and fixed bottom action footer
          Expanded(
            child: Stack(
              children: [
                // Scrollable terms content
                Positioned.fill(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _termsData == null
                          ? const Center(child: Text('Failed to load terms and conditions'))
                          : SingleChildScrollView(
                              padding: EdgeInsets.only(
                                left: 17.w,
                                right: 17.w,
                                top: 10.h,
                                bottom: 165.h, // Buffer so sticky bottom footer does not cover text
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_termsData?['sections'] != null)
                                    ...(_termsData!['sections'] as List).map((section) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (section['heading'] != null)
                                            _buildSectionTitle(section['heading']),
                                          if (section['heading'] != null) SizedBox(height: 5.h),
                                          if (section['content'] != null)
                                            _buildParagraph(section['content']),
                                          if (section['content'] != null) SizedBox(height: 14.h),
                                        ],
                                      );
                                    }),
                                  SizedBox(height: 5.h),
                                ],
                              ),
                            ),
                ),

                // 2. Fixed Sticky Footer (Figma: StickyFooter - Width: 360px, Hug 150px, Top-left/right radius: 22.15px, drop shadow)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: 14.77.h,
                      left: 18.46.w,
                      right: 18.46.w,
                      bottom: 22.h + bottomSafeArea,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22.15.r),
                        topRight: Radius.circular(22.15.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0x0D000000,
                          ), // 5% opacity black drop shadow
                          offset: Offset(0, -3.69.h),
                          blurRadius: 14.77.r,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Checkbox Section Row
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isAgreed = !_isAgreed;
                            });
                          },
                          borderRadius: BorderRadius.circular(6.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Small Checkbox Box (Figma: Green border & check icon when selected)
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 18.r,
                                  height: 18.r,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(
                                      color: _isAgreed
                                          ? AppColors.primary
                                          : const Color(0xFFD1D5DB),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: _isAgreed
                                      ? Icon(
                                          Icons.check,
                                          size: 14.r,
                                          color: AppColors.primary,
                                        )
                                      : null,
                                ),
                                SizedBox(width: 10.w),
                                // "I have read and agree to the Terms & Risk Disclosure" (Font: Inter, 12px, Regular 400, #000000)
                                Expanded(
                                  child: Text(
                                    _termsData?['agreement_text'] ?? 'I have read and agree to the Terms & Risk Disclosure',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF000000),
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 18.h),

                        // Action Buttons Row (Disagree & Agree & Continue)
                        Row(
                          children: [
                            // Disagree Button
                            Expanded(
                              child: SizedBox(
                                height: 46.h,
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                    ),
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF000000),
                                    side: const BorderSide(
                                      color: Color(0xFFE5E7EB),
                                      width: 1.2,
                                    ),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Disagree',
                                      maxLines: 1,
                                      style: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 12.w),

                            // Agree & Continue Button (Turns Green only when checkbox is selected)
                            Expanded(
                              child: SizedBox(
                                height: 46.h,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  decoration: BoxDecoration(
                                    color: _isAgreed
                                        ? AppColors.primary
                                        : const Color(0xFFE5E7EB),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _isAgreed
                                        ? _onAgreeAndContinue
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                      ),
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor:
                                          Colors.transparent,
                                      disabledForegroundColor: const Color(
                                        0xFF9CA3AF,
                                      ),
                                      shadowColor: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        _termsData?['button_text'] ?? 'Agree & Continue',
                                        maxLines: 1,
                                        softWrap: false,
                                        style: GoogleFonts.inter(
                                          fontSize: 13.5.sp,
                                          fontWeight: FontWeight.w600,
                                          color: _isAgreed
                                              ? Colors.white
                                              : const Color(0xFF9CA3AF),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF000000),
        height: 20 / 12,
        letterSpacing: 0,
      ),
    );
  }

  Widget _buildParagraph(String content) {
    return Text(
      content,
      textAlign: TextAlign.justify,
      style: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF000000),
        height: 20 / 12,
        letterSpacing: 0,
      ),
    );
  }
}
