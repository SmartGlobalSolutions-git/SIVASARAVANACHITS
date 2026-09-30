import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_assets.dart';

/// Top curved green header with family photo + emerald gradient overlay + white circular logo
class TopHeader extends StatelessWidget {
  const TopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = ScreenUtil().statusBarHeight;
    final headerHeight = 287.h;

    return ClipPath(
      clipper: const BottomArcClipper(),
      child: SizedBox(
        height: headerHeight,
        width: 1.sw,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Family background photo
            Image.asset(
              AppAssets.headerBackground,
              fit: BoxFit.contain,
              alignment: const Alignment(0, 0),
              errorBuilder: (context, error, stackTrace) {
                return Container(color: AppColors.primaryDark);
              },
            ),

            // 2. Green gradient overlay for rich emerald tint
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00002914), // rgba(0, 41, 20, 0) - 0%
                    Color(0xFF018F46), // #018F46 - 100%
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            ),

            // 3. Logo + Brand Names, centered
            Padding(
              padding: EdgeInsets.only(
                top: topPadding > 0 ? topPadding : 1.h,
                bottom: 20.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // White circular container for the SSC logo
                  Container(
                    width: 66.r,
                    height: 66.r,
                    decoration: const BoxDecoration(
                      color: AppColors.circleBackground,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x20000000),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(8.r),
                    child: ClipOval(
                      child: Image.asset(
                        AppAssets.logo,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.savings_rounded,
                            color: AppColors.primary,
                            size: 32.r,
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Brand name: SIVA SARAVANA
                  Text(
                    'SIVA SARAVANA',
                    style: GoogleFonts.inter(
                      color: AppColors.textWhite,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Brand sub-title: CHITS ( P ) LTD
                  Text(
                    'CHITS ( P ) LTD',
                    style: GoogleFonts.inter(
                      color: AppColors.textWhite,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Draws the bottom concave curve / dome arc seen in the design
class BottomArcClipper extends CustomClipper<Path> {
  const BottomArcClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    final curveOffset = 120.h; // Deeper curve sides

    // Start at top-left
    path.lineTo(0, size.height - curveOffset);

    // Deep quadratic curve down to the bottom center, and up to the right
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20.h,
      size.width,
      size.height - curveOffset,
    );

    // Right edge to top-right
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
