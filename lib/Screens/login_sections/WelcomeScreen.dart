// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import 'top_header.dart';
import '../login_sections/user_type_selection_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---------- TOP GREEN CURVED HEADER WITH LOGO ----------
          const TopHeader(),

          // ---------- BODY CONTENT ----------
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [

                  // "Welcome to" + "SIVA SARAVANA"
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome to\n',
                          style: GoogleFonts.inter(
                            color: AppColors.textPrimary,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                        TextSpan(
                          text: 'SIVA SARAVANA',
                          style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Description paragraph matching Figma 14px size and 18px line height
                  Text(
                    'SIVA SARAVANA is a trusted chit fund company '
                    'offering reliable, flexible, and transparent '
                    'financial solutions for individuals, families, and '
                    'businesses.\n\n'
                    'With a customer-first approach and dedicated '
                    'service, we strive to build long-term '
                    'relationships based on trust, transparency, and '
                    'reliability.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Tagline
                  Text(
                    'Save Smart. Plan Better. Grow Together.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: AppColors.primary,
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Star rating (5 / 5)
                  const _StarRating(rating: 5.0),

                  SizedBox(height: 8.h),
                  
                  GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse('https://share.google/pKfmHR3lFxKz51G3J');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_sharp,
                          color: AppColors.starGold,
                          size: 24.r,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '4.9 176 Google reviews',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF1E3A8A), // Dark blue
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: const Color(0xFF1E3A8A),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Get Started button navigating to UserTypeSelectionScreen
                  SizedBox(
                    width: double.infinity,
                    height: 40.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserTypeSelectionScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBackground,
                        foregroundColor: AppColors.textWhite,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                      child: Text(
                        'Get Started',
                        style: GoogleFonts.inter(
                          fontSize: 15.5.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Terms & Privacy text matching Figma 10px / 13px line-height
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        height: 1.6,
                        color: AppColors.textLightGray,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        const TextSpan(text: 'By continuing,you agree to our\n'),
                        TextSpan(
                          text: 'Terms & Use & Privacy Policy',
                          style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 5-Star rating row supporting half stars and custom colors
class _StarRating extends StatelessWidget {
  final double rating;
  const _StarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        IconData icon;
        if (rating >= index + 1) {
          icon = Icons.star_sharp;
        } else if (rating > index && rating < index + 1) {
          icon = Icons.star_half_sharp;
        } else {
          icon = Icons.star_border_rounded;
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.5.w),
          child: Icon(
            icon,
            color: AppColors.starGold,
            size: 20.r,
          ),
        );
      }),
    );
  }
}