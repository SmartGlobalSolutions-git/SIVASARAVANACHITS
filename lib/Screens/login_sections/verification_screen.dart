import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_assets.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import '../../constants/app_colors.dart';

/// Screen for User Verification matching the Figma design specifications.
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with SingleTickerProviderStateMixin {
  // Expansion state for Aadhaar Card
  bool _isAadhaarExpanded = true;

  // Upload status flags for demo interaction feedback
  bool _isAadhaarFrontUploaded = false;
  bool _isAadhaarBackUploaded = false;
  bool _isPanUploaded = false;
  bool _isSalarySlipUploaded = false;
  bool _isVoterIdUploaded = false;
  bool _isLiveImageCaptured = false;

  // Animation controller for floating AI Chatbot (tuned for lively, smooth speed)
  late final AnimationController _chatbotAnimController;

  @override
  void initState() {
    super.initState();
    // Slightly faster and livelier floating animation speed (~950ms)
    _chatbotAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _chatbotAnimController.dispose();
    super.dispose();
  }

  /// Show the custom Success Bottom Modal Sheet matching the Figma design
  void _showSubmittedSuccessfullySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (context) {
        final bottomPadding = MediaQuery.of(context).padding.bottom;
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(36.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            top: 40.h,
            bottom: bottomPadding > 0 ? bottomPadding + 36.h : 48.h,
            left: 20.w,
            right: 20.w,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Submitted Successfully Image 1 (Contains both badge & text)
              Image.asset(
                AppAssets.submittedSuccessfully,
                width: 240.w,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Column(
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F8F0),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                          size: 60.sp,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Submitted Successfully',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF018F46),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          // Main layout: Fixed Top Header + Scrollable Card List
          Column(
            children: [
              // 1. Fixed Top Header: Back Arrow + "Verification" Title (Stable & Fixed)
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: statusBarHeight > 0 ? statusBarHeight + 8.h : 22.h,
                  bottom: 12.h,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      borderRadius: BorderRadius.circular(20.r),
                      child: Padding(
                        padding: EdgeInsets.all(4.r),
                        child: Icon(
                          Icons.arrow_back,
                          color: const Color(0xFF111827),
                          size: 24.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Verification',
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),

              // Subtle bottom divider under the fixed header
              Container(
                height: 0.8.h,
                color: const Color(0xFFF3F4F6),
              ),

              // 2. Scrollable Verification Document Cards
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    top: 14.h,
                    bottom: 120.h, // extra space so cards are not covered by submit button
                  ),
                  children: [
                    // Card 1: Aadhaar Card (Expandable with uploaded aadhar.png icon)
                    _buildAadhaarCard(),
                    SizedBox(height: 12.h),

                    // Card 2: PAN Card
                    _buildDocumentCard(
                      iconAsset: AppAssets.panCard,
                      iconBgColor: const Color(0xFFEEF5FF),
                      title: 'PAN Card',
                      subtitle: 'Upload clear PAN card\nimage',
                      actionLabel: _isPanUploaded ? 'Uploaded' : 'Upload',
                      isUploaded: _isPanUploaded,
                      onActionTap: () {
                        setState(() {
                          _isPanUploaded = !_isPanUploaded;
                        });
                      },
                    ),
                    SizedBox(height: 12.h),

                    // Card 3: Salary Slip
                    _buildDocumentCard(
                      iconAsset: AppAssets.salarySlip,
                      iconBgColor: const Color(0xFFFEF7EB),
                      title: 'Salary Slip',
                      subtitle: 'Upload latest salary slip',
                      actionLabel: _isSalarySlipUploaded ? 'Uploaded' : 'Upload',
                      isUploaded: _isSalarySlipUploaded,
                      onActionTap: () {
                        setState(() {
                          _isSalarySlipUploaded = !_isSalarySlipUploaded;
                        });
                      },
                    ),
                    SizedBox(height: 12.h),

                    // Card 4: Voter ID
                    _buildDocumentCard(
                      iconAsset: AppAssets.voterId,
                      iconBgColor: const Color(0xFFF5EEFF),
                      title: 'Voter ID',
                      subtitle: 'Upload your Voter ID\ndocument',
                      actionLabel: _isVoterIdUploaded ? 'Uploaded' : 'Upload',
                      isUploaded: _isVoterIdUploaded,
                      onActionTap: () {
                        setState(() {
                          _isVoterIdUploaded = !_isVoterIdUploaded;
                        });
                      },
                    ),
                    SizedBox(height: 12.h),

                    // Card 5: Live Image (Capture)
                    _buildDocumentCard(
                      iconAsset: AppAssets.liveImage,
                      iconBgColor: const Color(0xFFE8F8F5),
                      title: 'Live Image',
                      subtitle: 'Capture a live selfie using\ncamera',
                      actionLabel: _isLiveImageCaptured ? 'Captured' : 'Capture',
                      isCamera: true,
                      isUploaded: _isLiveImageCaptured,
                      onActionTap: () {
                        setState(() {
                          _isLiveImageCaptured = !_isLiveImageCaptured;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 4. Fixed Bottom Submit Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 8.h,
                bottom: bottomPadding > 0 ? bottomPadding + 10.h : 20.h,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _showSubmittedSuccessfullySheet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const ChatboxWidget(),
        ],
      ),
    );
  }

  /// Card 1: Aadhaar Card with expandable Front & Back side dashed upload containers
  Widget _buildAadhaarCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: const Color(0xFFF3F4F6),
          width: 0.93.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 1.87),
            blurRadius: 9.34,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.all(15.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          InkWell(
            onTap: () {
              setState(() {
                _isAadhaarExpanded = !_isAadhaarExpanded;
              });
            },
            borderRadius: BorderRadius.circular(10.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Aadhaar Icon Container with uploaded aadhar.png asset
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8F5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.all(6.r),
                  child: Image.asset(
                    AppAssets.aadharCard,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.credit_card,
                        color: AppColors.primary,
                        size: 24.sp,
                      );
                    },
                  ),
                ),
                SizedBox(width: 14.w),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aadhaar Card',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF111827),
                          letterSpacing: -0.1,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Upload front side and back side',
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),

                // Expand / Collapse Chevron Arrow
                Icon(
                  _isAadhaarExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFF374151),
                  size: 22.sp,
                ),
              ],
            ),
          ),

          // Expanded Content: Front Side and Back Side dashed border boxes
          if (_isAadhaarExpanded) ...[
            SizedBox(height: 14.h),
            Row(
              children: [
                // Front Side Box
                Expanded(
                  child: _buildDashedUploadBox(
                    title: 'Front Side',
                    isUploaded: _isAadhaarFrontUploaded,
                    onTap: () {
                      setState(() {
                        _isAadhaarFrontUploaded = !_isAadhaarFrontUploaded;
                      });
                    },
                  ),
                ),
                SizedBox(width: 12.w),

                // Back Side Box
                Expanded(
                  child: _buildDashedUploadBox(
                    title: 'Back Side',
                    isUploaded: _isAadhaarBackUploaded,
                    onTap: () {
                      setState(() {
                        _isAadhaarBackUploaded = !_isAadhaarBackUploaded;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Dashed border upload box with camera icon
  Widget _buildDashedUploadBox({
    required String title,
    required bool isUploaded,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: CustomPaint(
        painter: DashedRectPainter(
          color: isUploaded ? const Color(0xFF018F46) : const Color(0xFF34D399),
          strokeWidth: 1.2,
          gap: 3.5,
          dashLength: 5.0,
          radius: 12.r,
        ),
        child: Container(
          height: 76.h,
          decoration: BoxDecoration(
            color: isUploaded
                ? const Color(0xFF018F46).withValues(alpha: 0.06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isUploaded ? Icons.check_circle_outline : Icons.camera_alt_outlined,
                color: const Color(0xFF018F46),
                size: 22.sp,
              ),
              SizedBox(height: 6.h),
              Text(
                isUploaded ? 'Uploaded ✓' : title,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E1E1E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Generic Document Card for PAN, Salary Slip, Voter ID, Live Image
  Widget _buildDocumentCard({
    required String iconAsset,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback onActionTap,
    bool isCamera = false,
    bool isUploaded = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: const Color(0xFFF3F4F6),
          width: 0.93.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 1.87),
            blurRadius: 9.34,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Container
          Image.asset(
            iconAsset,
            fit: BoxFit.contain,
            height: 30.h,
            width: 30.w,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                isCamera ? Icons.camera_alt : Icons.description_outlined,
                color: AppColors.primary,
                size: 24.sp,
              );
            },
          ),
          SizedBox(width: 20.w),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                    letterSpacing: -0.1,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 10.w),

          // Action Button (Upload / Capture)
          InkWell(
            onTap: onActionTap,
            borderRadius: BorderRadius.circular(20.r),
            child: isUploaded
                ? Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF018F46),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          actionLabel,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : isCamera
                    ? Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F8F0),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 7.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              color: const Color(0xFF018F46),
                              size: 15.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              actionLabel,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF018F46),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Image.asset(
                        AppAssets.uploadIcon,
                        width: 82.w,
                        height: 32.h,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F8F0),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_upward_rounded,
                                  color: const Color(0xFF018F46),
                                  size: 15.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Upload',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF018F46),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter to draw rounded dashed borders
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double radius;

  const DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.dashLength,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashedPath = _createDashedPath(path, dashLength, gap);

    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source, double dashLength, double gap) {
    final Path dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double length = draw ? dashLength : gap;
        if (draw) {
          final double extractLength = math.min(length, metric.length - distance);
          dest.addPath(
            metric.extractPath(distance, distance + extractLength),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.radius != radius;
  }
}
